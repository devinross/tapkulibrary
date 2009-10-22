//
//  NSDateAdditions.h
//  Dater
//
//  Created by Devin Ross on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (TKCategory)

+ (NSDate*) firstOfCurrentMonth;
+ (NSDate*) lastOfCurrentMonth;

@property (readonly,nonatomic) NSString *monthString;
@property (readonly,nonatomic) NSString *yearString;
@property (readonly,nonatomic) NSString *monthYearString;
@property (readonly,nonatomic) NSNumber *dayNumber;
@property (readonly,nonatomic) int weekday;
@property (readonly,nonatomic) int weekdayMondayFirst;
@property (readonly,nonatomic) int daysInMonth;
@property (readonly,nonatomic) int month;
@property (readonly,nonatomic) int hour;
@property (readonly,nonatomic) int minute;
@property (readonly,nonatomic) BOOL isToday;
@property (readonly,nonatomic) NSDate* firstOfCurrentMonthForDate;
@property (readonly,nonatomic) NSDate* firstOfNextMonthForDate;


- (BOOL)isSameDay:(NSDate*)anotherDate;

@end
