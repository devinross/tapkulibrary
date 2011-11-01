//
//  ODCalendarDayEventView.m
//  Created by Devin Ross on 7/28/09.
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
#import "TKCalendarDayEventView.h"


#define HORIZONTAL_OFFSET 4.0
#define VERTICAL_OFFSET 5.0

#define FONT_SIZE 12.0

@implementation TKCalendarDayEventView

@synthesize id=_id;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize title=_title;
@synthesize location=_location;
@synthesize balloonColorTop, balloonColorBottom, textColor; 

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when xibless (interface buildder)
- (id)initWithFrame:(CGRect)frame {
    if(!(self=[super initWithFrame:frame])) return nil;
    [self setupCustomInitialisation];
    return self;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when using xib (interface buildder)
- (id)initWithCoder:(NSCoder *)decoder {
    if(!(self=[super initWithCoder:decoder])) return nil;
    [self setupCustomInitialisation];
	return self;
}

- (void)setupCustomInitialisation
{
	// Initialization code
	self.id = nil;
	self.startDate = nil;
	self.endDate = nil;
	self.title = nil;
	self.location = nil;
	
	twoFingerTapIsPossible = FALSE;
	self.balloonColorTop = [UIColor purpleColor];
	self.balloonColorBottom = nil;
	self.textColor = [UIColor whiteColor];
	self.alpha = 0.8;
	CALayer *layer = [self layer];
	layer.masksToBounds = YES;
	[layer setCornerRadius:5.0];
	// You can even add a border
	[layer setBorderWidth:0.5];
	[layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

+ (id)eventViewWithFrame:(CGRect)frame id:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title location:(NSString *)location;
{
	TKCalendarDayEventView *event = [[TKCalendarDayEventView alloc]initWithFrame:frame];
	event.id = id;
	event.startDate = startDate;
	event.endDate = endDate;
	event.title = title;
	event.location = location;
	
	return event;
}

- (void)drawRect:(CGRect)rect {
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Save the context state 
	CGContextSaveGState(context);	
	
	//if the developer really want a standard fill color
	if (balloonColorTop == balloonColorBottom) {
		self.backgroundColor = balloonColorTop;
	}
	//if we have 2 different colors, we draw a gradient
	else {		
		UIColor *lowerColor = nil;
		//if there is no bottom color set, we get a darker version of the top one
		if (!balloonColorBottom) {
			const CGFloat *components = CGColorGetComponents([balloonColorTop CGColor]);
			lowerColor = [UIColor colorWithRed:components[0]-0.25f green:components[1]-0.25f blue:components[2]-0.25f alpha:components[3]];
		}
		else {
			lowerColor = balloonColorBottom;
		}
		//create a colorspace and linear gradient from the colors
		CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)[balloonColorTop CGColor], (id)[lowerColor CGColor], nil];		
		CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, colors, NULL);
		//draw the gradient
		CGContextDrawLinearGradient(context, myGradient, CGPointMake(0.0f,0.0f), CGPointMake(0.0f,self.bounds.size.height), 0);
		CFRelease(myGradient);
		CFRelease(myColorspace);		
	}
	
	// Set shadow
	CGContextSetShadowWithColor(context,  CGSizeMake(0.0, 1.0), 0.7, [[UIColor blackColor]CGColor]);
	
	// Set text color
	[textColor set];
	
	CGFloat availableHeight = self.bounds.size.height - VERTICAL_OFFSET - VERTICAL_OFFSET;
	
	CGRect titleRect = CGRectMake(self.bounds.origin.x + HORIZONTAL_OFFSET, 
								  self.bounds.origin.y + VERTICAL_OFFSET, 
								  self.bounds.size.width - 2 * HORIZONTAL_OFFSET, 
								  availableHeight);
	CGSize titleSize = CGSizeZero;
	
	CGRect locationRect = CGRectMake(self.bounds.origin.x + HORIZONTAL_OFFSET, 
								  self.bounds.origin.y + VERTICAL_OFFSET, 
								  self.bounds.size.width - 2 * HORIZONTAL_OFFSET, 
								  availableHeight);
	
    // Drawing code
	// Draw both title and location
	if (self.title) {
		titleSize = [self.title drawInRect:CGRectIntegral(titleRect) 
								  withFont:[UIFont boldSystemFontOfSize:FONT_SIZE] 
							 lineBreakMode:(availableHeight < VERTICAL_DIFF ? UILineBreakModeTailTruncation : UILineBreakModeWordWrap)
								 alignment:UITextAlignmentLeft];
	}
	if (titleSize.height + FONT_SIZE < availableHeight) {
		if (self.location) {
			locationRect.origin.y += titleSize.height;
			locationRect.size.height -= titleSize.height;
			UILineBreakMode breaking = (locationRect.size.height < FONT_SIZE + VERTICAL_OFFSET ? UILineBreakModeTailTruncation : UILineBreakModeWordWrap);
			[self.location drawInRect:CGRectIntegral(locationRect) 
						  withFont:[UIFont systemFontOfSize:FONT_SIZE] 
					 lineBreakMode:breaking
						 alignment:UITextAlignmentLeft];
			
		}
	}		
	// Restore the context state
	CGContextRestoreGState(context);
}









@end
