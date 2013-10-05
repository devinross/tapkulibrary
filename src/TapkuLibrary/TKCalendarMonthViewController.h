//
//  DaterViewController.h
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

@import UIKit;
#import "TKCalendarMonthView.h"

@class TKCalendarMonthView;
@protocol TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource;


/** The `TKCalendarMonthViewController` class creates a controller object that manages a calendar month grid. */ 
@interface TKCalendarMonthViewController : UIViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource> 

/** Initializes a month view controller to manage a month grid. Sunday will be the left-most day.
 @return A newly create month view controller.
 */
- (id) init;

/** Initializes a month view controller to manage a month grid.
 @param sundayFirst If YES, Sunday will be the left most day in the month grid, otherwise Monday.
 @return A newly create month view controller.
 */
- (id) initWithSunday:(BOOL)sundayFirst;

/** Initializes a month view controller to manage a month grid. Sunday will be the left-most day.
 @param timeZone The time zone for the calendar grid.
 @param sundayFirst If YES, Sunday will be the left most day in the month grid, otherwise Monday.
 @return A newly create month view controller.
 */
- (id) initWithSunday:(BOOL)sundayFirst timeZone:(NSTimeZone*)timeZone;

/** Initializes a month view controller to manage a month grid. Sunday will be the left-most day.
 @param timeZone The time zone for the calendar grid.
 @return A newly create month view controller.
 */
- (id) initWithTimeZone:(NSTimeZone *)timeZone;


/** Returns the month view managed by the controller object. */
@property (nonatomic,strong) TKCalendarMonthView *monthView;


@end

