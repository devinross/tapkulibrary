//
//  NSDate+CalendarGrid.h
//  TapkuLibrary
//
//  Created by Devin Ross on 8/19/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarGrid)

- (NSDate*) firstOfMonth;
- (NSDate*) nextMonth;
- (NSDate*) previousMonth;

- (NSDate*) lastOfMonthDate;
+ (NSDate*) lastofMonthDate;
+ (NSDate*) lastOfCurrentMonth;

@end
