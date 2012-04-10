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

/** Additional functionality for `NSDate`. */
@interface NSDate (TKCategory)

+ (NSDate *) yesterday;


/** Creates and returns a new date set to the current month.
 @return A `NSDate` object set to the current month.
 */
+ (NSDate *) month;

/** Creates and returns a new date set to the first day of the month from the date object.
 @return A `NSDate` object set to the same month as the date object. The day will be the first of the month.
 */
- (NSDate *) monthDate;



- (BOOL) isSameDay:(NSDate*)anotherDate;
- (int) monthsBetweenDate:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)date;

/** Returns a Boolean value that indicates whether the date object is that same date information as the current day. 
 @return YES if the date object represents the current date, otherwise NO.
 */
- (BOOL) isToday;


- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;

- (NSString *) monthString;
- (NSString *) yearString;


- (TKDateInformation) dateInformation;
- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(TKDateInformation)info;


@end
