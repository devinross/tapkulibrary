//
//  ODCalendarDayViewController.m
//  Created by Devin Ross on 7/28/09.
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

#import "TKCalendarDayViewController.h"
#import "TKCalendarDayEventView.h"


@implementation TKCalendarDayViewController
@synthesize calendarDayTimelineView;

- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void) viewDidUnload {
	self.calendarDayTimelineView = nil;
}
- (void) dealloc {
	self.calendarDayTimelineView = nil;
}




- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addSubview:self.calendarDayTimelineView];
}


- (NSArray *)calendarDayTimelineView:(TKCalendarDayTimelineView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
	TKCalendarDayEventView *eventViewFirst = [TKCalendarDayEventView eventViewWithFrame:CGRectZero
																		 id:nil 
																  startDate:[[NSDate date]addTimeInterval:60 * 60 * 2] 
																	endDate:[[NSDate date]addTimeInterval:60 * 60 * 24]
																	  title:@"First"
																   location:@"Test Location"];
	
	TKCalendarDayEventView *eventViewSecond = [TKCalendarDayEventView eventViewWithFrame:CGRectZero
																				  id:nil
															 			   startDate:[NSDate date] 
																			 endDate:[NSDate date]
																			   title:@"Second ultra mega hypra long text to test again with more"
																		    location:nil];
	
	return [NSArray arrayWithObjects:eventViewFirst, eventViewSecond, nil];
}
- (void)calendarDayTimelineView:(TKCalendarDayTimelineView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
	NSLog(@"CalendarDayTimelineView: EventViewWasSelected");
}


- (TKCalendarDayTimelineView *) calendarDayTimelineView{
	if (!_calendarDayTimelineView) {
		_calendarDayTimelineView = [[TKCalendarDayTimelineView alloc]initWithFrame:self.view.bounds];
		_calendarDayTimelineView.delegate = self;
	}
	return _calendarDayTimelineView;
}



@end
