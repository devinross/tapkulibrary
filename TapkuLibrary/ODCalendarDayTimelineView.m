//
//  ODCalendarDayTimelineView.m
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 18/10/09.
/*
 
 sync at me dot com || http://github.com/sync/tapkulibrary/
 
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

#import "ODCalendarDayTimelineView.h"

#define HORIZONTAL_OFFSET 3.0
#define VERTICAL_OFFSET 5.0
#define VERTICAL_DIFF 50.0

#define TIME_WIDTH 20.0
#define PERIOD_WIDTH 30.0

#define FONT_SIZE 14.0

#define TIMELINE_HEIGHT 24*VERTICAL_OFFSET+23*VERTICAL_DIFF


@implementation ODCalendarDayTimelineView

@synthesize delegate=_delegate;

#pragma mark -
#pragma mark Initialisation

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
	// Add main scroll view
	[self addSubview:self.scrollView];
	// Add timeline view inside scrollview
	[self.scrollView addSubview:self.timelineView];
}

#pragma mark -
#pragma mark Setup

- (UIScrollView *)scrollView
{
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.contentSize = CGSizeMake(self.bounds.size.width,TIMELINE_HEIGHT);
		_scrollView.scrollEnabled = TRUE;
		_scrollView.backgroundColor =[UIColor whiteColor];
	}
	return _scrollView;
}

- (ODTimelineView *)timelineView
{
	if (!_timelineView) {
		_timelineView = [[ODTimelineView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, 
																		self.bounds.origin.y,
																		self.bounds.size.width,
																		TIMELINE_HEIGHT)];
		_timelineView.backgroundColor = [UIColor whiteColor];
		
		
	}
	return _timelineView;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[_timelineView release];
	[_scrollView release];
	
    [super dealloc];
}


@end

@implementation ODTimelineView

@synthesize times=_times;
@synthesize periods=_periods;

#pragma mark -
#pragma mark Initialisation

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
	
}

#pragma mark -
#pragma mark Setup

// Setup array consisting of string
// representing time aka 12 (12 am), 1 (1 am) ... 25 x

- (NSArray *)times
{
	if (!_times) {
		_times = [[NSArray alloc]initWithObjects:
				  @"12",
				  @"1",
				  @"2",
				  @"3",
				  @"4",
				  @"5",
				  @"6",
				  @"7",
				  @"8",
				  @"9",
				  @"10",
				  @"11",
				  @"Noon",
				  @"1",
				  @"2",
				  @"3",
				  @"4",
				  @"5",
				  @"6",
				  @"7",
				  @"8",
				  @"9",
				  @"10",
				  @"11",
				  @"12",
				  nil];

	}
	return _times;
}

// Setup array consisting of string
// representing time periods aka AM or PM
// Matching the array of times 25 x

- (NSArray *)periods
{
	if (!_periods) {
		_periods = [[NSArray alloc]initWithObjects:
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"AM",
				  @"",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"PM",
				  @"AM",
				  nil];
	}
	return _periods;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Here Draw timeline from 12 am to noon to 12 am next day
	
	// Just making sure that times and periods are correctly initialized
	// Should have exactly the same number of objects
	if (self.times.count != self.periods.count) {
		return;
	}
	
	// Times appearance
	UIFont *timeFont = [UIFont boldSystemFontOfSize:FONT_SIZE];
	UIColor *timeColor = [UIColor blackColor];
	
	// Periods appearance
	UIFont *periodFont = [UIFont systemFontOfSize:FONT_SIZE];
	UIColor *periodColor = [UIColor darkGrayColor];
	
	// Draw each times string
	for (NSInteger i=0; i<self.times.count; i++) {
		// Draw time
		[timeColor set];
		
		NSString *time = [self.times objectAtIndex:i];
		
		CGRect timeRect = CGRectMake(HORIZONTAL_OFFSET, VERTICAL_OFFSET + i * VERTICAL_DIFF, TIME_WIDTH, FONT_SIZE + 4.0);
		
		// Find noon
		if (i == 24/2) {
			timeRect = CGRectMake(HORIZONTAL_OFFSET, VERTICAL_OFFSET + i * VERTICAL_DIFF, TIME_WIDTH + PERIOD_WIDTH, FONT_SIZE + 4.0);
		}
		
		[time drawInRect:timeRect
			   withFont:timeFont 
		  lineBreakMode:UILineBreakModeWordWrap 
			  alignment:UITextAlignmentRight];
		
		// Draw period
		// Only if it is not noon
		if (i != 24/2) {
			[periodColor set];
			
			NSString *period = [self.periods objectAtIndex:i];
			
			[period drawInRect: CGRectMake(HORIZONTAL_OFFSET + TIME_WIDTH, VERTICAL_OFFSET + i * VERTICAL_DIFF, PERIOD_WIDTH, FONT_SIZE + 4.0) 
					  withFont: periodFont 
				 lineBreakMode: UILineBreakModeWordWrap 
					 alignment: UITextAlignmentRight];
		}
		
	}
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[_times release];
	[_periods release];
	
    [super dealloc];
}


@end
