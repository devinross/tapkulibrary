//
//  ODCalendarDayViewController.m
//  Created by Anthony Mittaz on 19/10/09.
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

#import "ODCalendarDayViewController.h"
#import "ODCalendarDayEventView.h"


@implementation ODCalendarDayViewController

#pragma mark -
#pragma mark Setup

- (ODCalendarDayTimelineView *)calendarDayTimelineView
{
	if (!_calendarDayTimelineView) {
		_calendarDayTimelineView = [[ODCalendarDayTimelineView alloc]initWithFrame:self.view.bounds];
		_calendarDayTimelineView.delegate = self;
	}
	return _calendarDayTimelineView;
}

#pragma mark -
#pragma mark View Events

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addSubview:self.calendarDayTimelineView];
}

#pragma mark -
#pragma mark Calendar Day Timeline View delegate

- (NSArray *)calendarDayTimelineView:(ODCalendarDayTimelineView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate
{
	ODCalendarDayEventView *eventViewFirst = [ODCalendarDayEventView eventViewWithFrame:CGRectZero
																		 id:nil 
																  startDate:[[NSDate date]addTimeInterval:60 * 60 * 2] 
																	endDate:[[NSDate date]addTimeInterval:60 * 60 * 24]
																	  title:@"First"
																   location:@"Test Location"];
	
	ODCalendarDayEventView *eventViewSecond = [ODCalendarDayEventView eventViewWithFrame:CGRectZero
																				  id:nil
															 			   startDate:[NSDate date] 
																			 endDate:[NSDate date]
																			   title:@"Second ultra mega hypra long text to test again with more"
																		    location:nil];
	
	return [NSArray arrayWithObjects:eventViewFirst, eventViewSecond, nil];
}

- (void)calendarDayTimelineView:(ODCalendarDayTimelineView*)calendarDayTimeline eventViewWasSelected:(ODCalendarDayEventView *)eventView
{
	NSLog(@"CalendarDayTimelineView: EventViewWasSelected");
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 
 //return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[_calendarDayTimelineView release];
	
    [super dealloc];
}


@end
