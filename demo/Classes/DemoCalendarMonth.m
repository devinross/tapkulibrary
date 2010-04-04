//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "DemoCalendarMonth.h"

@implementation DemoCalendarMonth

- (void) viewDidLoad{
	[super viewDidLoad];
	//[self.monthView selectDate:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*68]];
	NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10000000];
	[self.monthView selectDate:date];
	
}

- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
	TKDateInformation info = [date dateInformation];
	return info.day%2==0;
}


@end
