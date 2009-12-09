//
//  TKCalendarView.h
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



@class TKMonthGridView,TKCalendarDayView;
@protocol TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource;


@interface TKCalendarMonthView : UIView {
	
	id <TKCalendarMonthViewDelegate> delegate;
	id <TKCalendarMonthViewDataSource> dataSource;
	
	NSDate *currentMonth;
	NSDate *selectedMonth;
	NSMutableArray *deck;
	
	
	UIButton *left;
	NSString *monthYear;
	UIButton *right;
	
	UIImageView *shadow;
	UIScrollView *scrollView;
	
	
}
@property (readonly,nonatomic) NSString *monthYear;
@property (readonly,nonatomic) NSDate *monthDate;

@property (assign,nonatomic) id <TKCalendarMonthViewDataSource> dataSource;
@property (assign,nonatomic) id <TKCalendarMonthViewDelegate> delegate;

- (id) init;
- (void) reload;
- (void) selectDate:(NSDate *)date;


@end


@protocol TKCalendarMonthViewDataSource<NSObject>
@required
- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date;
@end


@protocol TKCalendarMonthViewDelegate<NSObject>
@optional
- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date;
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthWillAppear:(NSDate*)month;
@end











