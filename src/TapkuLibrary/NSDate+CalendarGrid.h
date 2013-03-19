//
//  NSDate+CalendarGrid.h
//  TapkuLibrary
//
//  Created by Devin Ross on 8/19/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarGrid)

- (NSDate*) firstOfMonthWithTimeZone:(NSTimeZone*)timeZone;
- (NSDate*) nextMonthWithTimeZone:(NSTimeZone*)timeZone;
- (NSDate*) previousMonthWithTimeZone:(NSTimeZone*)timeZone;

- (NSDate*) lastOfMonthDateWithTimeZone:(NSTimeZone*)timeZone;
+ (NSDate*) lastofMonthDateWithTimeZone:(NSTimeZone*)timeZone;
+ (NSDate*) lastOfCurrentMonthWithTimeZone:(NSTimeZone*)timeZone;

@end
