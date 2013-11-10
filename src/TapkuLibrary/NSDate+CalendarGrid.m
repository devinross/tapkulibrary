//
//  NSDate+CalendarGrid.m
//  Created by Devin Ross on 8/19/12.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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
