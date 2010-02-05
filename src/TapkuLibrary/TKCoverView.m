//
//  TKCoverView.m
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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

#import "TKCoverView.h"

@implementation TKCoverView
@synthesize image,baseline;


- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		//self.image = [UIImage imageNamed:@"albumcover.jpg"];
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	//CGRect r = CGRectMake(0, 0, rect.size.width , rect.size.width * image.size.height / image.size.width);
	//[image drawInRect:r];
	
	

	//CGRect r = CGRectMake(0, 0, rect.size.width , rect.size.width * image.size.height / image.size.width);

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	float h = rect.size.width * image.size.height / image.size.width;
	
	float y = 0;
	if(h < baseline)
		y = baseline - h;
	
	CGRect r = CGRectMake(0, y, rect.size.width , h);
	
	CGRect rectangle = rect;
	rectangle.origin.y += y + 1;
	rectangle.size.height -= y;
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextFillRect(context, rectangle);
	self.backgroundColor = [UIColor blackColor];
	[image drawInRect:r];
	

	r.origin.y = h + y;
	CGContextDrawImage(context,r,image.CGImage);
	r.size.height =  h > rect.size.height - r.size.height ? rect.size.height - r.size.height : h;
	[[UIImage imageNamed:@"gradient.png"] drawInRect:r];

}

- (void) setImage:(UIImage *)img{
	[image release];
	image = [img retain];
	[self setNeedsDisplay];
}
- (void) setBaseline:(float)f{
	baseline = f;
	[self setNeedsDisplay];
}
- (void) dealloc {
	[image release];
    [super dealloc];
}


@end
