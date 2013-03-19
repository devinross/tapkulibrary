//
//  NSDate+CalendarGrid.m
//  TapkuLibrary
//
//  Created by Devin Ross on 8/19/12.
//
//

#import "NSDate+CalendarGrid.h"
#import "NSDate+TKCategory.h"

@implementation NSDate (CalendarGrid)


- (NSDate*) firstOfMonthWithTimeZone:(NSTimeZone*)timeZone{
	
	NSDateComponents *info = [self dateComponentsWithTimeZone:timeZone];
	
	info.day = 1;
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	
	info.timeZone = timeZone;
	
	return [NSDate dateWithDateComponents:info];
}
- (NSDate*) nextMonthWithTimeZone:(NSTimeZone*)timeZone{
	
	
	NSDateComponents *info = [self dateComponentsWithTimeZone:timeZone];
	info.month++;
	if(info.month>12){
		info.month = 1;
		info.year++;
	}
	info.minute = info.second = info.hour = 0;
	
	return [NSDate dateWithDateComponents:info];
	
}
- (NSDate*) previousMonthWithTimeZone:(NSTimeZone*)timeZone{
	
	NSDateComponents *components = [self dateComponentsWithTimeZone:timeZone];

	components.month--;
	if(components.month<1){
		components.month = 12;
		components.year--;
	}
	
	components.second = components.minute = components.hour = 0;

	
	return [NSDate dateWithDateComponents:components];

	
}

- (NSDate*) lastOfMonthDateWithTimeZone:(NSTimeZone*)timeZone{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = timeZone;
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	comp.timeZone = timeZone;
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	NSDate *date = [gregorian dateFromComponents:comp];
    return date;
}

+ (NSDate*) lastofMonthDateWithTimeZone:(NSTimeZone*)timeZone{
    NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}
+ (NSDate*) lastOfCurrentMonthWithTimeZone:(NSTimeZone*)timeZone{
	NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}


@end
