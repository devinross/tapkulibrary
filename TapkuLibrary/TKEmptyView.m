//
//  TKEmptyView.m
//  Created by Devin Ross on 7/24/09.
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

#import "TKEmptyView.h"
#import "QuartzDrawing.h"

@implementation TKEmptyView
@synthesize title, subtitle, mask;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor whiteColor];
		


		shadow = [[TKDropShadowImage alloc] initWithFrame: CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height/2 -150 + 2, 200, 200)];
		[self addSubview:shadow];
		gradient = [[TKGradientImage alloc] initWithFrame: CGRectMake(self.frame.size.width/2-100, self.frame.size.height/2-150, 200, 200)];
		[self addSubview:gradient];

		
		title = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		title.font = [UIFont boldSystemFontOfSize:18];
		title.adjustsFontSizeToFitWidth = YES;
		CGRect r= title.frame;
		r.size.height = 22;
		r.origin.y = self.frame.size.height/2 + 80;
		title.frame=r;
		title.textColor = [UIColor grayColor];
		title.textAlignment = UITextAlignmentCenter;
		[self addSubview:title];
		
		subtitle = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		subtitle.font = [UIFont boldSystemFontOfSize:12];
		subtitle.adjustsFontSizeToFitWidth = YES;
		r= subtitle.frame;
		r.size.height = 20;
		r.origin.y = self.frame.size.height/2 + 110;
		subtitle.frame=r;
		subtitle.textColor = [UIColor grayColor];
		subtitle.textAlignment = UITextAlignmentCenter;
		[self addSubview:subtitle];
		
		
    }
    return self;
}
- (void) setMask:(UIImage*)m{
	[mask release];
	mask = [m retain];
	gradient.mask = m;
	shadow.mask = m;
}
- (void)dealloc {
	
	[title release];
	[subtitle release];
	[shadow release];
	[gradient release];
	[mask release];
	
    [super dealloc];
}


@end


@implementation TKDropShadowImage
@synthesize mask;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void) setMask:(UIImage*)m{
	[mask release];
	mask = [m retain];
	[self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextClipToMask(context, CGRectMake(0, 0, 200, 200), [mask CGImage]);
	CGContextSetRGBFillColor(context, 139/255.0, 152/255.0, 173/255.0, 1.0);
	CGContextFillRect(context, CGRectMake(0, 0.0, 200.0, 200.0));
	
}
- (void)dealloc {
	[mask release]; 
	[super dealloc];
}
@end

@implementation TKGradientImage
@synthesize mask;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void) setMask:(UIImage*)m{
	[mask release];
	mask = [m retain];
	[self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextClipToMask(context, CGRectMake(0, 0, 200, 200), [mask CGImage]);
	
	CGFloat colors[] = {
		171/255.0, 180/255.0, 196/255.0, 1.00,
		//175/255.0, 184/255.0, 198/255.0, 1.00,
		213/255.0, 217/255.0, 225/255.0, 1.00
		
	};
	
	[QuartzDrawing drawLinearGradientWithFrame:CGRectMake(0, 0, 200, 200) colors:colors];
	
}
- (void)dealloc {
	[mask release]; 
	[super dealloc];
}
@end