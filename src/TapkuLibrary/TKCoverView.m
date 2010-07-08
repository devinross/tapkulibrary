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
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"


@interface TKCoverView (private)

@property (retain,nonatomic,readonly) UIImageView *imageView;
@property (retain,nonatomic,readonly) UIImageView *gradient;
@property (retain,nonatomic,readonly) UIImageView *reflected;

@end


@implementation TKCoverView
@synthesize image,baseline;


- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		[self addSubview:self.reflected];
		[self addSubview:self.imageView];
		[self addSubview:self.gradient];
		
		self.layer.anchorPoint = CGPointMake(0.5, 0.5);
		
    }
    return self;
}



- (void) drawRect:(CGRect)rect {
	
	//CGRect r = CGRectMake(0, 0, rect.size.width , rect.size.width * image.size.height / image.size.width);
	//[image drawInRect:r];
	/*
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	float h = rect.size.width * image.size.height / image.size.width;
	float y = h < baseline ? baseline - h : 0;
	CGRect r = CGRectMake(0, y, rect.size.width , h);
	
	CGContextTranslateCTM(context, 0.0, h);
	CGContextScaleCTM(context, 1.0, -1.0);
	r.origin.y = y * -1;
	CGContextDrawImage(context,r,image.CGImage);

	

	r.origin.y = h + y;
	CGContextTranslateCTM(context, 0.0, h);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context,r,image.CGImage);
	
	r.size.height =  h > rect.size.height - r.size.height ? rect.size.height - r.size.height : h;
	CGContextDrawImage(context,r,[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/coverflow/coverflowgradient.png")].CGImage);
	*/

}

- (void) setImage:(UIImage *)img{
	[image release];
	image = [img retain];
	
	float w = image.size.width;
	float h = image.size.height;
	float factor = self.frame.size.width / (h>w?h:w);
	h = factor * h;
	w = factor * w;
	float y = baseline - h > 0 ? baseline - h : 0;
	
	self.imageView.frame = CGRectMake(0, y, w, h);
	self.imageView.image = image;
	
	
	
	self.gradient.frame = CGRectMake(0, y + h, w, h);
	
	self.reflected.frame = CGRectMake(0, y + h, w, h);
	self.reflected.image = image;
	//[self setNeedsDisplay];
}
- (void) setBaseline:(float)f{
	baseline = f;
	[self setNeedsDisplay];
}


- (UIImageView*) imageView{
	if(imageView==nil){
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
	}
	return imageView;
}

- (UIImageView*) reflected{
	if(reflected==nil){
		reflected =  [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.width)];
		reflected.transform = CGAffineTransformScale(reflected.transform, 1, -1);
	}
	return reflected;
}

- (UIImageView*) gradient{
	if(gradient==nil){
		gradient =  [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.width)];
		gradient.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/coverflow/coverflowgradient.png")];
	}
	return gradient;
}


- (void) dealloc {
	[image release];
    [super dealloc];
}


@end
