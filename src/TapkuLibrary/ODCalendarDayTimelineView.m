//
//  ODCalendarDayTimelineView.m
//  Created by Anthony Mittaz on 18/10/09.
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

#import "ODCalendarDayTimelineView.h"
#import "NSDate+TKCategory.h"

#define HORIZONTAL_OFFSET 3.0
#define VERTICAL_OFFSET 5.0

#define TIME_WIDTH 20.0
#define PERIOD_WIDTH 26.0

#define FONT_SIZE 14.0

#define HORIZONTAL_LINE_DIFF 10.0

#define TIMELINE_HEIGHT 24*VERTICAL_OFFSET+23*VERTICAL_DIFF

#define EVENT_VERTICAL_DIFF 0.0
#define EVENT_HORIZONTAL_DIFF 2.0


@implementation ODCalendarDayTimelineView

@synthesize delegate=_delegate;
@synthesize events=_events;
@synthesize currentDay=_currentDay;

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
	self.events = nil;
	self.currentDay = nil;
	// Add main scroll view
	[self addSubview:self.scrollView];
	// Add timeline view inside scrollview
	[self.scrollView addSubview:self.timelineView];
	// Get notified when current day is changed
	// Observe when app got online (facebook connect)
	[self addObserver:self forKeyPath: @"currentDay"
					 options:0
					 context:@selector(reloadDay)];
}

#pragma mark -
#pragma mark Execut Method When Notification Fire

//help executing a method when a notification fire
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self performSelector: (SEL)context withObject: change];
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
		_scrollView.alwaysBounceVertical = TRUE;
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
#pragma mark View Event

- (void)didMoveToWindow
{
	if (self.window != nil) {
		[self reloadDay];
	}
}

#pragma mark -
#pragma mark Reload Day

- (void)reloadDay
{
	// If no current day was given
	// Make it today
	if (!self.currentDay) {
		// Dont' want to inform the observer
		_currentDay = [[NSDate date]retain];
	}
	
	// Remove all previous view event
	for (id view in self.scrollView.subviews) {
		if (![NSStringFromClass([view class])isEqualToString:@"ODTimelineView"]) {
			[view removeFromSuperview];
		}
	}
	
	// Ask the delgate about the events that correspond
	// the the currently displayed day view
	if (self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:eventsForDate:)]) {
		self.events = [self.delegate calendarDayTimelineView:self eventsForDate:self.currentDay];
		for (ODCalendarDayEventView *event in self.events) {
			// Making sure delgate sending date that match current day
			if ([event.startDate isSameDay:self.currentDay]) {
				// Get the hour start position
				NSInteger hourStart = [event.startDate dateInformation].hour;
				CGFloat hourStartPosition = roundf((hourStart * VERTICAL_DIFF) + VERTICAL_OFFSET + ((FONT_SIZE + 4.0) / 2.0));
				// Get the minute start position
				// Round minute to each 5
				NSInteger minuteStart = [event.startDate dateInformation].minute;
				minuteStart = round(minuteStart / 5.0) * 5;
				CGFloat minuteStartPosition = roundf((minuteStart < 30)?0:VERTICAL_DIFF / 2.0);
				
				
				
				// Get the hour end position
				NSInteger hourEnd = [event.endDate dateInformation].hour;
				if (![event.startDate isSameDay:event.endDate]) {
					hourEnd = 23;
				}
				CGFloat hourEndPosition = roundf((hourEnd * VERTICAL_DIFF) + VERTICAL_OFFSET + ((FONT_SIZE + 4.0) / 2.0));
				// Get the minute end position
				// Round minute to each 5
				NSInteger minuteEnd = [event.endDate dateInformation].minute;
				if (![event.startDate isSameDay:event.endDate]) {
					minuteEnd = 55;
				}
				minuteEnd = round(minuteEnd / 5.0) * 5;
				CGFloat minuteEndPosition = roundf((minuteEnd < 30)?0:VERTICAL_DIFF / 2.0);
				
				CGFloat eventHeight = 0.0;
				
				if (minuteStartPosition == minuteEndPosition || hourEnd == 23) {
					// Starting and ending date position are the same
					// Take all half hour space
					// Or hour is at the end
					eventHeight = (VERTICAL_DIFF / 2) - (2 * EVENT_VERTICAL_DIFF);
				} else {
					// Take all hour space
					eventHeight = VERTICAL_DIFF - (2 * EVENT_VERTICAL_DIFF);
				}
				
				if (hourStartPosition != hourEndPosition) {
					eventHeight += (hourEndPosition + minuteEndPosition) - hourStartPosition - minuteStartPosition; 
				}
				
				CGRect eventFrame = CGRectMake(HORIZONTAL_OFFSET + TIME_WIDTH + PERIOD_WIDTH + HORIZONTAL_LINE_DIFF + EVENT_HORIZONTAL_DIFF,
											   hourStartPosition + minuteStartPosition + EVENT_VERTICAL_DIFF,
											   self.bounds.size.width  - (HORIZONTAL_OFFSET + TIME_WIDTH + PERIOD_WIDTH + HORIZONTAL_LINE_DIFF) - HORIZONTAL_LINE_DIFF - EVENT_HORIZONTAL_DIFF, 
											   eventHeight);
				
				event.frame = CGRectIntegral(eventFrame);
				event.delegate = self;
				[event setNeedsDisplay];
				[self.scrollView addSubview:event];
				
				
				// Log the extracted date values
				NSLog(@"hourStart: %d minuteStart: %d", hourStart, minuteStart);
			}
		}
	}	
}

#pragma mark -
#pragma mark Tap Detecting View

- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:eventViewWasSelected:)]) {
		[self.delegate calendarDayTimelineView:self eventViewWasSelected:(ODCalendarDayEventView *)view];
	}
}

- (void)tapDetectingView:(TapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint
{
	NSLog(@"Double Tapped Calendar Day View");
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	// Remove observers
	[self removeObserver:self forKeyPath: @"currentDay"];
	
	[_currentDay release];
	[_events release];
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
	UIColor *periodColor = [UIColor grayColor];
	
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
		
		[time drawInRect:CGRectIntegral(timeRect)
			   withFont:timeFont 
		  lineBreakMode:UILineBreakModeWordWrap 
			  alignment:UITextAlignmentRight];
		
		// Draw period
		// Only if it is not noon
		if (i != 24/2) {
			[periodColor set];
			
			NSString *period = [self.periods objectAtIndex:i];
			
			[period drawInRect: CGRectIntegral(CGRectMake(HORIZONTAL_OFFSET + TIME_WIDTH, VERTICAL_OFFSET + i * VERTICAL_DIFF, PERIOD_WIDTH, FONT_SIZE + 4.0)) 
					  withFont: periodFont 
				 lineBreakMode: UILineBreakModeWordWrap 
					 alignment: UITextAlignmentRight];
		}
		
		// Draw straight line
		CGContextRef context = UIGraphicsGetCurrentContext();
		// Save the context state 
		CGContextSaveGState(context);
		// Draw line with a black stroke color
		CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
		// Draw line with a 1.0 stroke width
		CGContextSetLineWidth(context, 0.5);
		// Translate context for clear line
		CGContextTranslateCTM(context, -0.5, -0.5);
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, HORIZONTAL_OFFSET + TIME_WIDTH + PERIOD_WIDTH + HORIZONTAL_LINE_DIFF, VERTICAL_OFFSET + i * VERTICAL_DIFF + roundf((FONT_SIZE + 4.0) / 2.0));
		CGContextAddLineToPoint(context, self.bounds.size.width, VERTICAL_OFFSET + i * VERTICAL_DIFF + roundf((FONT_SIZE + 4.0) / 2.0));
		CGContextStrokePath(context);
		
		if (i != self.times.count-1) {		
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, HORIZONTAL_OFFSET + TIME_WIDTH + PERIOD_WIDTH + HORIZONTAL_LINE_DIFF, VERTICAL_OFFSET + i * VERTICAL_DIFF + roundf((FONT_SIZE + 4.0) / 2.0) + roundf(VERTICAL_DIFF / 2.0));
			CGContextAddLineToPoint(context, self.bounds.size.width, VERTICAL_OFFSET + i * VERTICAL_DIFF + roundf((FONT_SIZE + 4.0) / 2.0) + roundf(VERTICAL_DIFF / 2.0));
			CGFloat dash1[] = {2.0, 1.0};
			CGContextSetLineDash(context, 0.0, dash1, 2);
			CGContextStrokePath(context);
		}
		
		// Restore the context state
		CGContextRestoreGState(context);
		
		
		
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
