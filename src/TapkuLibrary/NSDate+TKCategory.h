//
//  NSDateAdditions.h
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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


- (NSString*) dateDescription;

@end
