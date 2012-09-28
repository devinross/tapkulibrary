//
//  TKCalendarMonthView.h
//  Created by Devin Ross on 6/10/10.
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
#import <UIKit/UIKit.h>


@class TKCalendarMonthTiles;
@protocol TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource;

/** `TKCalendarMonthView` imitates the month grid in the Calendar app on iPhone. */
@interface TKCalendarMonthView : UIView {

	TKCalendarMonthTiles *currentTile,*oldTile;
	//UIButton *leftArrow, *rightArrow;
	//UIImageView *topBackground, *shadow;
	//UILabel *monthYear;
	BOOL sunday;

}


/** Initialize a Calendar Month Grid.
 @param sunday Flag to setup the grid with Monday or Sunday as the leftmost day.
 @return A `TKCalendarMonthView` object or nil.
 */
- (id) initWithSundayAsFirst:(BOOL)sunday; // or Monday

/** The delegate must adopt the `TKCalendarMonthViewDelegate` protocol. The delegate is not retained. */
@property (nonatomic,assign) id <TKCalendarMonthViewDelegate> delegate;

/** The data soruce must adopt the `TKCalendarMonthViewDataSource` protocol. The data source is not retained. */
@property (nonatomic,assign) id <TKCalendarMonthViewDataSource> dataSource;

/** The current date highlighted on the month grid.
 @return An `NSDate` object set to the month, year and day of the current selection.
 */
- (NSDate*) dateSelected;


/** The current month date being displayed. 
 @return An `NSDate` object set to the month and year of the current month grid.
 */
- (NSDate*) monthDate;

/** Selects a specific date in the month grid. 
 @param date The date that will be highlighed.
 */
- (void) selectDate:(NSDate*)date;

/** Reloads the current month grid. */
- (void) reload;

@end

/** The delegate of a `TKCalendarMonthView` object must adopt the `TKCalendarMonthViewDelegate` protocol. */ 
@protocol TKCalendarMonthViewDelegate <NSObject>
@optional

/** The highlighed date changed.
 @param monthView The calendar month view.
 @param date The highlighted date.
 */ 
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date;


/** The calendar should change the current month to grid shown.
 @param monthView The calendar month view.
 @param month The month date.
 @param animated Animation flag
 @return YES if the month should change. NO otherwise
 */ 
- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView monthShouldChange:(NSDate*)month animated:(BOOL)animated;

/** The calendar will change the current month to grid shown.
 @param monthView The calendar month view.
 @param month The month date.
 @param animated Animation flag
 */ 
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthWillChange:(NSDate*)month animated:(BOOL)animated;

/** The calendar did change the current month to grid shown.
 @param monthView The calendar month view.
 @param month The month date.
 @param animated Animation flag
 */ 
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated;
@end


/** The data source of a `TKCalendarMonthView` object must adopt the `TKCalendarMonthViewDataSource` protocol. */ 
@protocol TKCalendarMonthViewDataSource <NSObject>

/** A data source that will correspond to marks for the calendar month grid for a particular month.
 
 @param monthView The calendar month grid.
 @param startDate The first date shown by the calendar month grid.
 @param lastDate The last date shown by the calendar month grid.
 @return Returns an array of NSNumber objects corresponding the number of days specified in the start and last day parameters. Each NSNumber variable will give a BOOL value that will be used to display a dot under the day.
 
 */
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate;
@end