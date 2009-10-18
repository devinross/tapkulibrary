//
//  TKCalendarView.h
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
#import "TKCalendarMonthView.h"

@protocol TKCalendarViewDelegate;

@interface TKCalendarView : UIView <TKCalendarMonthViewDelegate> {
	
	id <TKCalendarViewDelegate> delegate;
	NSDate *currentMonth;
	NSMutableArray *deck;
	
	UIButton *left;
	UIButton *right;
	
	UIImageView *shadow;
	UIScrollView *scrollView;
	
	NSString *monthString;
	

	
}
@property (copy,nonatomic) NSString *monthString;
@property (assign,nonatomic) id <TKCalendarViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame delegate:(id)delegate;
- (void) reloadData;

@end


@protocol TKCalendarViewDelegate<NSObject>
@required

- (void) calendarView:(TKCalendarView*)calendar dateWasSelected:(NSInteger)integer ofMonth:(NSDate*)monthDate;
- (NSArray*) calendarView:(TKCalendarView*)calendar itemsForDaysInMonth:(NSDate*)monthDate;
- (void) calendarView:(TKCalendarView*)calendar willShowMonth:(NSDate*)monthDate;

@end