//
//  TKCalendarMonthView.h
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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

@class TKCalendarDayView;
@protocol  TKCalendarMonthViewDelegate;

@interface TKCalendarMonthView : UIView {
	
	id <TKCalendarMonthViewDelegate> delegate;
	
	TKCalendarDayView *selectedDay;
	NSMutableArray *dayTiles;
	NSArray *marks;
	
	NSDate *dateOfFirst;
	

	int weekdayOfFirst;
	int lines;
	
	int todayNumber;
	//int daysInMonth;
	//int lastday;
	
}

@property (assign, nonatomic) id <TKCalendarMonthViewDelegate> delegate;

@property (readonly,nonatomic) int lines;
@property (readonly,nonatomic) int weekdayOfFirst;
@property (readonly,nonatomic) NSDate* dateOfFirst;

- (id) initWithFrame:(CGRect)frame startDate:(NSDate*)theDate today:(NSInteger)todayDay marked:(NSArray*)marksArray;
//- (void) setDate:(NSDate*)firstOfMonth today:(int)dayOfDate marked:(NSArray*)marksArray;
- (void) selectDay:(int)theDayNumber;

@end


@protocol TKCalendarMonthViewDelegate<NSObject>
@required

- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth dateWasSelected:(NSInteger)integer;
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth previousMonthDayWasSelected:(NSInteger)day;
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth nextMonthDayWasSelected:(NSInteger)day;

@end







@interface TKCalendarDayView : UIView {
	NSString *str;
	BOOL selected;
	BOOL active;
	BOOL today;
	BOOL marked;
}
@property (copy,nonatomic) NSString *str;
@property (assign,nonatomic) BOOL selected;
@property (assign,nonatomic) BOOL active;
@property (assign,nonatomic) BOOL today;
@property (assign,nonatomic) BOOL marked;

@end
