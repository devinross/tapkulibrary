//
//  TKImageCenter.m
//  Created by Devin Ross on 4/12/10.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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


#import "TKImageCenter.h"

@implementation TKImageCenter

static TKImageCenter *sharedInstance = nil;

+ (TKImageCenter*) sharedImageCenter{
    @synchronized(self) {
        if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}
+ (id) allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil; //on subsequent allocation attempts return nil
}
- (id) copyWithZone:(NSZone *)zone{
    return self;
}
- (id) retain{
    return self;
}
- (unsigned) retainCount{
    return UINT_MAX;  //denotes an object that cannot be released
}
- (void) release{
    //do nothing
}
- (id) autorelease{
    return self;
}

- (id) init{
	if(![super init]) return nil;
	
	queue = [[NSMutableArray alloc] init];
	images = [[NSMutableDictionary alloc] init];
	
	return self;
}



- (UIImage*) imageAtURL:(NSString*)imageURL cache:(BOOL)cache{
	
	UIImage *img = [images objectForKey:imageURL];
	if(img != nil) return img;
	
	
	if(!cache) return nil;
	
	
	[queue addObject:imageURL];
	if(cache && thread==nil){
		thread = [[NSThread alloc] initWithTarget:self selector:@selector(getImages) object:nil];
		[thread start];
	}
	
	
	
	return nil;
}

- (void) getImages{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	while([queue count]>0){
		NSString *url = [queue objectAtIndex:0];
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
		if(img != nil){
			[images setObject:img forKey:url];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newImage" object:self];
		}
		
		for(int cnt=0;cnt < [queue count]; cnt++){
			if([[queue objectAtIndex:cnt] isEqualToString:url]){
				[queue removeObjectAtIndex:cnt];
				cnt--;
			}
		}
	}
	
	[self performSelectorOnMainThread:@selector(getImagesDidFinish) withObject:nil waitUntilDone:NO];
	[pool release];
}
- (void) getImagesDidFinish{
	
	[thread cancel];
	[thread release];
	thread = nil;
}

- (void) clearImages{
	[thread cancel];
	[thread release];
	thread = nil;
	[images removeAllObjects];
	[queue removeAllObjects];
}

- (void) dealloc{
	
	[queue release];
	[images release];
	[thread cancel];
	[thread release];
	[super dealloc];
}
	 
@end
