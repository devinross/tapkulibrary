//
//  NSDateAdditions.h
//  Dater
//
//  Created by Devin Ross on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (TKCategory)

struct TKDateInformation {
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;

};
typedef struct TKDateInformation TKDateInformation;


- (TKDateInformation) dateInformation;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info;


@property (readonly,nonatomic) NSString *month;
@property (readonly,nonatomic) NSString *year;

@property (readonly,nonatomic) int daysInMonth; // ie. 31, 30 29


@property (readonly,nonatomic) int weekdayWithMondayFirst;



/*
 
 + (NSDate*) firstOfCurrentMonth;
 + (NSDate*) lastOfCurrentMonth;
 
//@property (readonly,nonatomic) NSString *hourString;
//@property (readonly,nonatomic) NSString *monthString;
//@property (readonly,nonatomic) NSString *yearString;
//@property (readonly,nonatomic) NSString *monthYearString;
//@property (readonly,nonatomic) NSNumber *dayNumber;
//@property (readonly,nonatomic) int weekday;


//@property (readonly,nonatomic) int month;
//@property (readonly,nonatomic) int hour;
//@property (readonly,nonatomic) int minute;



@property (readonly,nonatomic) NSDate* firstOfCurrentMonthForDate;
@property (readonly,nonatomic) NSDate* firstOfNextMonthForDate;
@property (readonly,nonatomic) NSDate* timelessDate;
@property (readonly,nonatomic) NSDate* monthlessDate;
*/

- (int)differenceInDaysTo:(NSDate *)toDate;
- (int)differenceInMonthsTo:(NSDate *)toDate;

@property (readonly,nonatomic) BOOL isToday;
- (BOOL)isSameDay:(NSDate*)anotherDate;

@end
