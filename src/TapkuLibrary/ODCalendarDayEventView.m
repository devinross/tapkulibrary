//
//  ODCalendarDayEventView.m
//  Created by Anthony Mittaz on 20/10/09.
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
#import "ODCalendarDayEventView.h"


#define HORIZONTAL_OFFSET 4.0
#define VERTICAL_OFFSET 5.0

#define FONT_SIZE 12.0


@implementation ODCalendarDayEventView

@synthesize id=_id;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize title=_title;
@synthesize location=_location;

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when xibless (interface buildder)
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Custom initialization
		[self setupCustomInitialisation];
    }
    return self;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when using xib (interface buildder)
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		// Custom initialization
		[self setupCustomInitialisation];
	}
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
	
	self.backgroundColor = [UIColor purpleColor];
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
	ODCalendarDayEventView *event = [[[ODCalendarDayEventView alloc]initWithFrame:frame]autorelease];
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
	
	// Set shadow
	CGContextSetShadowWithColor(context,  CGSizeMake(0.0, 1.0), 0.7, [[UIColor blackColor]CGColor]);
	
	// Set text color
	[[UIColor whiteColor]set];
	
	CGRect titleRect = CGRectMake(self.bounds.origin.x + HORIZONTAL_OFFSET, 
								  self.bounds.origin.y + VERTICAL_OFFSET, 
								  self.bounds.size.width - 2 * HORIZONTAL_OFFSET, 
								  FONT_SIZE + 4.0);
	
	CGRect locationRect = CGRectMake(self.bounds.origin.x + HORIZONTAL_OFFSET, 
								  self.bounds.origin.y + VERTICAL_OFFSET + FONT_SIZE + 4.0, 
								  self.bounds.size.width - 2 * HORIZONTAL_OFFSET, 
								  FONT_SIZE + 4.0);
	
    // Drawing code
	if (self.bounds.size.height > VERTICAL_DIFF) {
		// Draw both title and location
		if (self.title) {
			[self.title drawInRect:CGRectIntegral(titleRect) 
					 withFont:[UIFont boldSystemFontOfSize:FONT_SIZE] 
				lineBreakMode:UILineBreakModeTailTruncation 
					alignment:UITextAlignmentLeft];
		}
		if (self.location) {
			[self.location drawInRect:CGRectIntegral(locationRect) 
						  withFont:[UIFont systemFontOfSize:FONT_SIZE] 
					 lineBreakMode:UILineBreakModeTailTruncation 
						 alignment:UITextAlignmentLeft];
			
		}
	} else {
		// Draw only title
		if (self.title) {
			[self.title drawInRect:CGRectIntegral(titleRect) 
						  withFont:[UIFont boldSystemFontOfSize:FONT_SIZE] 
					 lineBreakMode:UILineBreakModeTailTruncation 
						 alignment:UITextAlignmentLeft];
		}
	}
	
	// Restore the context state
	CGContextRestoreGState(context);
}

- (void)dealloc {
	[_id release];
	[_startDate release];
	[_endDate release];
	[_title release];
	[_location release];
	
    [super dealloc];
}








@end
