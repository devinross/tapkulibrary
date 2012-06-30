//
//  TKImageCache.m
//  Created by Devin Ross on 8/29/11.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKImageCache.h"
#import "TKNetworkQueue.h"
#import "TKHTTPRequest.h"
#import "TKGlobal.h"

#pragma mark -
@interface TKImageRequest : TKHTTPRequest
@property (strong,nonatomic) NSString *key;
@end

@implementation TKImageRequest
@synthesize key;
@end



@interface TKImageCache (private)

- (NSString *) _filePathWithKey:(NSString *)key;
- (BOOL) _imageExistsOnDiskWithKey:(NSString *)key;
- (UIImage*) _imageFromDiskWithKey:(NSString*)key;
- (void) _readImageFromDiskWithKey:(NSString*)key tag:(NSUInteger)tag;
- (void) _sendRequestForURL:(NSURL*)url key:(NSString*)key tag:(NSUInteger)tag;

@end


#pragma mark -
@implementation TKImageCache
@synthesize cacheDirectoryName=_cacheDirectoryName,notificationName=_notificationName;
@synthesize timeTillRefreshCache=_timeTillRefreshCache;
@synthesize imagesQueue=_imagesQueue;
@synthesize shouldNetworkActivity;

- (id) init{
	self = [self initWithCacheDirectoryName:@"imagecache"];
	return self;
}
- (id) initWithCacheDirectoryName:(NSString*)dirName{
	if(!(self=[super init])) return nil;
	
	[self setCountLimit:20];
	self.cacheDirectoryName = dirName;
	
	_requestKeys = [[NSMutableDictionary alloc] init];
	_imagesQueue = [[TKNetworkQueue alloc] init];
	
	self.shouldNetworkActivity = YES;
	
	cache_queue = dispatch_queue_create("com.tapku",NULL);
	
	self.notificationName = @"NewCachedImageFile";
	self.timeTillRefreshCache = -1;
	
	return self;
}
- (void) dealloc{
	dispatch_release(cache_queue);
}



- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded{
	return [self imageForKey:key url:url queueIfNeeded:queueIfNeeded tag:0];
}
- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded tag:(NSUInteger)tag{
	
	if(key==nil) return nil;
	
	id obj = [self objectForKey:key];
	if(obj) return obj;
	
	if([self _imageExistsOnDiskWithKey:key]){
		
		[self _readImageFromDiskWithKey:key tag:tag];
		
		if(self.timeTillRefreshCache > 0){
			
			
			NSString *path = [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
			NSDate *created = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL] fileCreationDate];
			NSTimeInterval timeSince = fabs([created timeIntervalSinceNow]);
			
			if(_timeTillRefreshCache > timeSince) queueIfNeeded = NO;
			
		}else
			queueIfNeeded = NO;
		
	}
	
	if(queueIfNeeded && url)
		[self _sendRequestForURL:url key:key tag:tag];
	
	return nil;
}


- (void) _sendRequestForURL:(NSURL*)url key:(NSString*)key tag:(NSUInteger)tag{
	
	dispatch_async(cache_queue,^{
		
		if([_requestKeys objectForKey:key]!=nil) return;
		
		[_requestKeys setObject:[NSNull null] forKey:key];
		NSString *filePath = [self _filePathWithKey:key];
		
		
		TKImageRequest * request = (TKImageRequest*)[TKImageRequest requestWithURL:url];
		request.tag = tag;
		request.key = key;
		request.delegate = self;
		request.didFinishSelector = @selector(_requestDidFinish:);
		request.didFailSelector = @selector(_requestDidFail:);
		request.downloadDestinationPath = filePath;
		request.showNetworkActivity = self.shouldNetworkActivity;
		[_imagesQueue addOperation:request];
		
	});
	
}
- (void) _requestDidFinish:(TKImageRequest*)request{
	
	NSString *key = request.key;
	
	
	
	if(request.statusCode != 200){
		dispatch_async(cache_queue,^{
			
			if([_requestKeys objectForKey:key])
				[_requestKeys removeObjectForKey:key];
			
			[[NSFileManager defaultManager] removeItemAtPath:request.downloadDestinationPath error:nil];
		});
		return;
	}
	
	
	dispatch_async(cache_queue,^{
		
		if([_requestKeys objectForKey:key])
			[_requestKeys removeObjectForKey:key];
		
		
		UIImage *cacheImage = [self adjustImageRecieved:[self _imageFromDiskWithKey:key]];
		if(cacheImage==nil) return;
		
		[self setObject:cacheImage forKey:request.key];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",cacheImage,@"image",[NSNumber numberWithUnsignedInt:request.tag],@"tag",nil];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[_diskKeys setObject:[NSNull null] forKey:request.key];
			[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:dict];
		});
		
	});
	
	
}
- (void) _requestDidFail:(TKImageRequest*)request{
	
	
	dispatch_async(cache_queue,^{
		NSString *key = request.key;
		
		if([_requestKeys objectForKey:key])
			[_requestKeys removeObjectForKey:key];
	});
}





// for subclassing if you need to process the image
- (UIImage*) adjustImageRecieved:(UIImage*)image{
	return image;
}



- (void) cancelOperations{
	[_imagesQueue cancelAllOperations];
	dispatch_async(cache_queue,^{
		
		[_requestKeys removeAllObjects];
	});
}
- (void) clearCachedImages{
	
	[self removeAllObjects];
	[_diskKeys removeAllObjects];
	dispatch_async(cache_queue,^{
		
		NSError* error = nil;
		NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
		
		
		for( NSString *file in files ) {
			if( file != @"." && file != @".." ) {
				NSString *path = [[self cacheDirectoryPath] stringByAppendingPathComponent:file];
				[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
				
			}
		}
		
		
	});
	
	
}
- (void) removeCachedImagesFromDiskOlderThanTime:(NSTimeInterval)time{
	
	UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
	NSError* error = nil;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
	
	for( NSString *file in files ) {
		if( file != @"." && file != @".." ) {
			
			NSString *path = [[self cacheDirectoryPath] stringByAppendingPathComponent:file];
			NSDate *created = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL] fileCreationDate];
			NSTimeInterval timeSince = fabs([created timeIntervalSinceNow]);
			
			if(timeSince > time){
				if(_diskKeys) [_diskKeys removeObjectForKey:file];
				[[NSFileManager defaultManager] removeItemAtPath:[[self cacheDirectoryPath] stringByAppendingPathComponent:file] error:&error];
			}
		}
	}
	
	[[UIApplication sharedApplication] endBackgroundTask:bgTask];
	
}
- (void) printAllCaching{
	
	NSError* error = nil;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
	
	TKLog(@"%@",files);
	
	
	
}




#pragma mark Disk Cache Methods
- (NSString *) _filePathWithKey:(NSString *)key{
    return [[self cacheDirectoryPath] stringByAppendingPathComponent:key];
}
- (BOOL) _imageExistsOnDiskWithKey:(NSString *)key{
	
	
	if(_diskKeys) return [_diskKeys objectForKey:key]==nil ? NO : YES;
	
	
	
    return [[NSFileManager defaultManager] fileExistsAtPath:[self _filePathWithKey:key]];
}
- (UIImage*) _imageFromDiskWithKey:(NSString*)key{
	NSData *data = [NSData dataWithContentsOfFile:[self _filePathWithKey:key]];
	return [[UIImage alloc] initWithData:data];
}
- (void) _readImageFromDiskWithKey:(NSString*)key tag:(NSUInteger)tag{
	
	dispatch_async(cache_queue,^{
		
		
		UIImage *cacheImage = [self adjustImageRecieved:[self _imageFromDiskWithKey:key]];
		
		if(cacheImage==nil) return;
		[self setObject:cacheImage forKey:key];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",cacheImage,@"image",[NSNumber numberWithUnsignedInt:tag],@"tag",nil];
		
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:dict];
		});
		
		
		
	});
	
}
- (UIImage*) cachedImageForKey:(NSString*)key{
	return [self _imageFromDiskWithKey:key];
}
- (BOOL) imageExistsWithKey:(NSString *)key{
	
	if([self objectForKey:key]) return YES;
	
	
	return [self _imageExistsOnDiskWithKey:key];
	
}

#pragma mark Path Methods
- (void) _setupFolderDirectory{
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [self cacheDirectoryPath];
	
	BOOL isDirectory = NO;
	BOOL folderExists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
	
	if (!folderExists){
		NSError *error = nil;
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	
	
}
- (void) setCacheDirectoryName:(NSString *)str{
	
	_cacheDirectoryPath=nil;
	_cacheDirectoryName = [str copy];
	
	[self _setupFolderDirectory];
	
	
	NSError* error = nil;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryPath] error:&error];
	
	
	if(error) return;
	
	NSMutableArray *ar = [NSMutableArray arrayWithCapacity:files.count];
	for(NSObject *obj in files)
		[ar addObject:[NSNull null]];
	
	_diskKeys = [[NSMutableDictionary alloc] initWithObjects:ar forKeys:files];
	
	
}
- (NSString *) cacheDirectoryPath{
	
	if(_cacheDirectoryPath==nil){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *str = [documentsDirectory stringByAppendingPathComponent:_cacheDirectoryName];
		_cacheDirectoryPath = [str copy];
	}
	return _cacheDirectoryPath;
}


@end
