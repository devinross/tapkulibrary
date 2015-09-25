//
//  CalendarDayViewController.m
//  Created by Devin Ross on 3/16/13.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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

#import "CalendarDayViewController.h"

@implementation CalendarDayViewController

- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}



- (void) viewDidLoad{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Day View", @"");

	
	self.data = @[
  @[@"Meeting with five random dudes", @"Five Guys", @5, @0, @5, @30],
  @[@"Unlimited bread rolls got me sprung", @"Olive Garden", @7, @0, @12, @0],
  @[@"Appointment", @"Dennys", @15, @0, @18, @0],
  @[@"Hamburger Bliss", @"Wendys", @15, @0, @18, @0],
  @[@"Fishy Fishy Fishfelayyyyyyyy", @"McDonalds", @5, @30, @6, @0],
  @[@"Turkey Time...... oh wait", @"Chick-fela", @14, @0, @19, @0],
  @[@"Greet the king at the castle", @"Burger King", @19, @30, @30, @0]];
	
}
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.hairlineDividerView.hidden = YES;
	self.dayView.daysBackgroundView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hairlineDividerView.hidden = NO;

}

#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
	
	if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
	if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];

	NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:calendarDayTimeline.calendar.timeZone];
	info.second = 0;
	NSMutableArray *ret = [NSMutableArray array];
	
	for(NSArray *ar in self.data){
		
		TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
		if(event == nil) event = [TKCalendarDayEventView eventView];
	
		event.identifier = nil;
		event.titleLabel.text = ar[0];
		event.locationLabel.text = ar[1];
		
		info.hour = [ar[2] intValue];
		info.minute = [ar[3] intValue];
		event.startDate = [NSDate dateWithDateComponents:info];
		
		info.hour = [ar[4] intValue];
		info.minute = [ar[5] intValue];
		event.endDate = [NSDate dateWithDateComponents:info];

		[ret addObject:event];
		
	}
	return ret;
	

}
- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
	TKLog(@"%@",eventView.titleLabel.text);
}


@end
