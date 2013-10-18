//
//  NSDateAdditions.m
//  Created by Devin Ross on 7/28/09.
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
#import "NSDate+TKCategory.h"

#pragma mark - NSDate + TKCategory
@implementation NSDate (TKCategory)

#pragma mark Yesterday
+ (NSDate*) yesterday{
	return [NSDate yesterdayWithTimeZone:[NSTimeZone defaultTimeZone]];
}
+ (NSDate*) yesterdayWithTimeZone:(NSTimeZone*)timeZone{
	NSDateComponents *comp = [[NSDate date] dateComponentsWithTimeZone:timeZone];
	comp.day--;
	return [NSDate dateWithDateComponents:comp];
}


#pragma mark Tomorrow
+ (NSDate*) tomorrow{
	return [NSDate tomorrowWithTimeZone:[NSTimeZone defaultTimeZone]];
}
+ (NSDate*) tomorrowWithTimeZone:(NSTimeZone*)timeZone{
	NSDateComponents *comp = [[NSDate date] dateComponentsWithTimeZone:timeZone];
	comp.day++;
	return [NSDate dateWithDateComponents:comp];
}

#pragma mark Month
+ (NSDate*) month{
    return [[NSDate date] monthDateWithTimeZone:[NSTimeZone defaultTimeZone]];
}
+ (NSDate*) monthWithTimeZone:(NSTimeZone*)timeZone{
    return [[NSDate date] monthDateWithTimeZone:timeZone];
}
- (NSDate*) monthDate{
	return [self monthDateWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (NSDate*) monthDateWithTimeZone:(NSTimeZone*)timeZone{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = timeZone;
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comp setDay:1];
	NSDate *date = [gregorian dateFromComponents:comp];
    return date;
}


#pragma mark Between
- (NSInteger) monthsBetweenDate:(NSDate *)toDate{
	return [self monthsBetweenDate:toDate timeZone:[NSTimeZone defaultTimeZone]];
}
- (NSInteger) monthsBetweenDate:(NSDate *)toDate timeZone:(NSTimeZone*)timeZone{
	if([self compare:toDate]==NSOrderedSame) return 0;
	
	NSDate *first = nil, *last = nil;
	if([self compare:toDate] == NSOrderedAscending){
		first = self;
		last = toDate;
	}else{
		first = toDate;
		last = self;
	}
	
	NSDateComponents *d1 = [first dateComponentsWithTimeZone:timeZone];
	NSDateComponents *d2 = [last dateComponentsWithTimeZone:timeZone];
	
	if(d1.year == d2.year)
		return d2.month - d1.month;
	
	
	NSInteger ret = 12 - d1.month;
	ret += d2.month;
	d1.year += 1;
	ret += 12 * (d2.year-d1.year);
	
	return ret;
}
- (NSInteger) daysBetweenDate:(NSDate*)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return ((abs(time) / (60.0 * 60.0 * 24.0)) + 0.5);
}

#pragma mark Same Day
- (BOOL) isSameDay:(NSDate*)anotherDate{
	return [self isSameDay:anotherDate timeZone:[NSTimeZone defaultTimeZone]];
}
- (BOOL) isSameDay:(NSDate*)anotherDate timeZone:(NSTimeZone*)timeZone{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	calendar.timeZone = timeZone;
	NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

#pragma mark Same Month
- (BOOL) isSameMonth:(NSDate *)anotherDate{
	return [self isSameMonth:anotherDate timeZone:[NSTimeZone defaultTimeZone]];
}
- (BOOL) isSameMonth:(NSDate *)anotherDate timeZone:(NSTimeZone *)timeZone{
	
	NSCalendar* calendar = [NSCalendar currentCalendar];
	calendar.timeZone = timeZone;
	NSDateComponents* components1 = [calendar components:NSYearCalendarUnit fromDate:self];
	NSDateComponents* components2 = [calendar components:NSYearCalendarUnit fromDate:anotherDate];
	return components1.year == components2.year && components1.month == components2.month;
}

#pragma mark Same Year
- (BOOL) isSameYear:(NSDate *)anotherDate{
	return [self isSameYear:anotherDate timeZone:[NSTimeZone defaultTimeZone]];
}
- (BOOL) isSameYear:(NSDate *)anotherDate timeZone:(NSTimeZone *)timeZone{
	
	NSCalendar* calendar = [NSCalendar currentCalendar];
	calendar.timeZone = timeZone;
	NSDateComponents* components1 = [calendar components:NSYearCalendarUnit fromDate:self];
	NSDateComponents* components2 = [calendar components:NSYearCalendarUnit fromDate:anotherDate];
	return components1.year == components2.year;

}

#pragma mark Is Today
- (BOOL) isToday{
	return [self isSameDay:[NSDate date]];
}
- (BOOL) isTodayWithTimeZone:(NSTimeZone*)timeZone{
	return [self isSameDay:[NSDate date] timeZone:timeZone];
}

- (BOOL) isTomorrow{
	return [self isTomorrowWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (BOOL) isTomorrowWithTimeZone:(NSTimeZone*)timeZone{
	NSDateComponents *comp = [[NSDate date] dateComponentsWithTimeZone:timeZone];
	comp.day++;
	NSDate *actualTomorrow = [NSDate dateWithDateComponents:comp];
	return [self isSameDay:actualTomorrow timeZone:timeZone];
}


- (BOOL) isYesterday{
	return [self isYesterdayWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (BOOL) isYesterdayWithTimeZone:(NSTimeZone*)timeZone{
	NSDateComponents *comp = [[NSDate date] dateComponentsWithTimeZone:timeZone];
	comp.day--;
	NSDate *actualTomorrow = [NSDate dateWithDateComponents:comp];
	return [self isSameDay:actualTomorrow timeZone:timeZone];
}

#pragma mark Month & Year String
- (NSString *) monthYearString{
	return [self monthYearStringWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (NSString *) monthYearStringWithTimeZone:(NSTimeZone*)timeZone{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = timeZone;
	dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yMMMM"
															   options:0
																locale:[NSLocale currentLocale]];
	return [dateFormatter stringFromDate:self];
}

- (NSString*) monthString{
	return [self monthStringWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (NSString*) monthStringWithTimeZone:(NSTimeZone*)timeZone{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = timeZone;
	[dateFormatter setDateFormat:@"MMMM"];
	return [dateFormatter stringFromDate:self];
}

- (NSString*) yearString{
	return [self yearStringWithTimeZone:[NSTimeZone defaultTimeZone]];
}
- (NSString*) yearStringWithTimeZone:(NSTimeZone*)timeZone{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = timeZone;
	[dateFormatter setDateFormat:@"yyyy"];
	return [dateFormatter stringFromDate:self];
}


#pragma mark Date Compontents
- (NSDateComponents*) dateComponentsWithTimeZone:(NSTimeZone*)timeZone{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = timeZone;
	return [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSTimeZoneCalendarUnit) fromDate:self];
}
+ (NSDate*) dateWithDateComponents:(NSDateComponents*)components{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = components.timeZone;
	return [gregorian dateFromComponents:components];
}


- (NSDate *) dateByAddingDays:(NSUInteger)days {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString *datePortion = [dateFormatter stringFromDate:aDate];
	
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *timePortion = [dateFormatter stringFromDate:aTime];
	
	[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSString *dateTime = [NSString stringWithFormat:@"%@ %@",datePortion,timePortion];
	return [dateFormatter dateFromString:dateTime];
}



- (NSDate*) firstDateOfWeekWithTimeZone:(NSTimeZone*)timeZone{
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
	weekdayComponents.timeZone = timeZone;

	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	componentsToSubtract.timeZone = timeZone;
	
	[componentsToSubtract setDay: - ([weekdayComponents weekday] - [gregorian firstWeekday])];
	
	NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
	

	NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
	components.timeZone = timeZone;

	beginningOfWeek = [gregorian dateFromComponents: components];
	
	return beginningOfWeek;
}


- (NSDate*) firstDateOfWeek{
	return [self firstDateOfWeekWithTimeZone:[NSTimeZone defaultTimeZone]];
}


+ (NSDate*) firstDateOfWeekWithTimeZone:(NSTimeZone*)timeZone{
	return [[NSDate date] firstDateOfWeekWithTimeZone:timeZone];
}
+ (NSDate*) firstDateOfWeek{
	return [[NSDate date] firstDateOfWeek];
}

@end
