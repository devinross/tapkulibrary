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
#import "NSArray+TKCategory.h"



@interface ImageLoadOperation : NSOperation {
    NSString *imageURL;
	TKImageCenter *imageCenter;
}

@property(copy) NSString *imageURL;
@property(assign) TKImageCenter *imageCenter;

- (id)initWithImageURLString:(NSString*)imageURL;

@end
@implementation ImageLoadOperation
@synthesize imageURL,imageCenter;

- (id) initWithImageURLString:(NSString*)url{
    if (!(self=[super init])) return nil;
    self.imageURL = url;
    return self;
}

- (void) dealloc {
    self.imageURL = nil;
    [super dealloc];
}

- (void) main {
	
	UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
	if(img!=nil){
		
		
		img = [imageCenter adjustImageRecieved:img];
		
		if(img!=nil){
			[imageCenter performSelectorOnMainThread:@selector(sendNewImageNotification:) 
										  withObject:[NSArray arrayWithObjects:img,self.imageURL,nil] 
									   waitUntilDone:YES];
		}
		

		
	}
	
}

@end


@implementation TKImageCenter
@synthesize queue,images;

+ (TKImageCenter*) sharedImageCenter{
	static TKImageCenter *sharedInstance = nil;
	if (!sharedInstance) {
		sharedInstance = [[TKImageCenter alloc] init];
	}
	return sharedInstance;
}
- (id) init{
	if(!(self=[super init])) return nil;
	queue = [[NSOperationQueue alloc] init];
	images = [[NSMutableDictionary alloc] init];
	return self;
}


- (UIImage*) imageAtURL:(NSString*)imageURL queueIfNeeded:(BOOL)addToQueue{
	
	UIImage *img = [images objectForKey:imageURL];
	if(img != nil) return img;
	
	ImageLoadOperation *op = [[ImageLoadOperation alloc] initWithImageURLString:imageURL];
	op.imageCenter = self;
	[queue addOperation:op];
	[op release];
	
	return nil;
	
}


- (UIImage*) adjustImageRecieved:(UIImage*)image{
	return image;
}

- (void) sendNewImageNotification:(NSArray*)ar{
	[images setObject:[ar firstObject] forKey:[ar lastObject]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newImage" object:self];
}






- (void) clearImages{
	[queue cancelAllOperations];
	[images removeAllObjects];
}
- (void) dealloc{
	[queue release];
	[images release];
	[super dealloc];
}
	 
@end
