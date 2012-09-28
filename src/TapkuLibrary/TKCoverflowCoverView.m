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

#import "TKCoverflowCoverView.h"
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"

@implementation TKCoverflowCoverView

- (id) initWithFrame:(CGRect)frame showReflection:(BOOL)reflection{
	if(!(self=[super initWithFrame:frame])) return nil;
	
	
	self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
	
	self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
	
	if(reflection){
		
		CGRect reflectRect = CGRectMakeWithSize(0, self.frame.size.height, self.bounds.size);
		
		self.reflected =  [[UIImageView alloc] initWithFrame:reflectRect];
		self.reflected.transform = CGAffineTransformScale(self.reflected.transform, 1, -1);
		[self addSubview:self.reflected];
		
		self.gradientLayer = [CAGradientLayer layer];
		self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor,nil];
		self.gradientLayer.startPoint = CGPointMake(0,0);
		self.gradientLayer.endPoint = CGPointMake(0,0.3);
		self.gradientLayer.frame = reflectRect;
		[self.layer addSublayer:self.gradientLayer];
	}
    
	return self;
}
- (id) initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame showReflection:YES];
}

- (void) setImage:(UIImage *)img{
	
	if(img==nil){
		[CATransaction begin];
		[CATransaction setAnimationDuration:0.0f];
		self.imageView.frame = self.bounds;
		
		if(self.gradientLayer){
			self.reflected.image = nil;
			self.gradientLayer.frame = self.reflected.frame = CGRectMakeWithSize(0,self.frame.size.height,self.bounds.size);
		}
		self.imageView.image = nil;
		[CATransaction commit];
		return;
	}
	
	
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.0f];
	
	UIImage *image = img;
	CGFloat w = image.size.width;
	CGFloat h = image.size.height;
	CGFloat factor = self.bounds.size.width / (h>w?h:w);
	h = factor * h;
	w = factor * w;
	CGFloat y = _baseline - h > 0 ? _baseline - h : 0;
	
	self.imageView.frame = CGRectMake(0, y, w, h);
	self.imageView.image = image;
	
	if(self.gradientLayer){
		self.reflected.frame = self.gradientLayer.frame = CGRectMake(0, y + h, w, h);
		self.reflected.image = image;
	}
	
	[CATransaction commit];
	
	
}
- (UIImage*) image{
	return self.imageView.image;
}


@end