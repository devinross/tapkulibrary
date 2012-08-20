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


- (NSDate*) firstOfMonth{
	TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.day = 1;
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}
- (NSDate*) nextMonth{
	
	
	TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.month++;
	if(info.month>12){
		info.month = 1;
		info.year++;
	}
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
}
- (NSDate*) previousMonth{
	
	
	TKDateInformation info = [self dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.month--;
	if(info.month<1){
		info.month = 12;
		info.year--;
	}
	
	info.minute = 0;
	info.second = 0;
	info.hour = 0;
	return [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
}

- (NSDate*) lastOfMonthDate {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	NSDate *date = [gregorian dateFromComponents:comp];
    return date;
}

+ (NSDate*) lastofMonthDate{
    NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}
+ (NSDate*) lastOfCurrentMonth{
	NSDate *day = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	[comp setDay:0];
	[comp setMonth:comp.month+1];
	return [gregorian dateFromComponents:comp];
}


@end
