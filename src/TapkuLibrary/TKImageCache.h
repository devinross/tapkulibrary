//
//  TKImageCache.h
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

#import <Foundation/Foundation.h>
#import <TapkuLibrary/TapkuLibrary.h>


@interface TKImageCache : NSCache {
	NSString *_cacheDirectoryName;
	NSString *_cacheDirectoryPath;
	NSMutableDictionary *_diskKeys;
	NSMutableDictionary *_requestKeys;
	TKNetworkQueue *_imagesQueue;
	dispatch_queue_t cache_queue;
	NSString *_notificationName;
	NSTimeInterval _timeTillRefreshCache;
}


- (id) init;
- (id) initWithCacheDirectoryName:(NSString*)cacheDirectoryName;

@property (strong,nonatomic) TKNetworkQueue *imagesQueue;
@property (copy,nonatomic) NSString *cacheDirectoryName;
@property (copy,nonatomic) NSString *notificationName;
@property (assign,nonatomic) NSTimeInterval timeTillRefreshCache;

- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded;
- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded tag:(NSUInteger)tag;

- (UIImage*) cachedImageForKey:(NSString*)key;
- (BOOL) imageExistsWithKey:(NSString *)key;

- (void) cancelOperations;
- (void) clearCachedImages;
- (void) removeCachedImagesFromDiskOlderThanTime:(NSTimeInterval)time;
	


// for subclassing
- (NSString *) cacheDirectoryPath;
- (UIImage*) adjustImageRecieved:(UIImage*)image;

@end

