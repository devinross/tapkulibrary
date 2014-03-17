//
//  TKCalendarDayView.h
//  Created by Devin Ross on 7/28/09.
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
#import "TKCalendarDayEventView.h"

@protocol TKCalendarDayViewDelegate,TKCalendarDayViewDataSource;
@class TKTimelineView;

#pragma mark - TKCalendarDayView
/** `TKCalendarDayView` imitates the day view in the Calendar app on iPhone. */
@interface TKCalendarDayView : UIView <UIScrollViewDelegate>

- (id) initWithFrame:(CGRect)frame calendar:(NSCalendar*)calendar;

- (id) initWithFrame:(CGRect)frame timeZone:(NSTimeZone*)timeZone;


@property (nonatomic,strong) NSCalendar *calendar;




@property (nonatomic,strong) UIView *daysBackgroundView;

/** The date for the current timeline. */
@property (nonatomic,strong) NSDate *date;

/** The delegate must adopt the `TKCalendarDayViewDelegate` protocol. The data source is not retained. */
@property (nonatomic,assign) id <TKCalendarDayViewDelegate> delegate;

/** The data source must adopt the `TKCalendarDayViewDataSource` protocol. The data source is not retained. */
@property (nonatomic,assign) id <TKCalendarDayViewDataSource> dataSource;

/** The time mark for each hour. Default is NO. */
@property (nonatomic,assign) BOOL is24hClock;

/** The time zone for day view. */
//@property (nonatomic,strong) NSTimeZone *timeZone;

/** Reloads the events. */
- (void) reloadData;

/** Returns an event view that can used by the data source.
 @return A previously used `TKCalendarDayEventView` object.
 */
- (TKCalendarDayEventView*) dequeueReusableEventView;


@end

#pragma mark - TKCalendarDayViewDelegate
/** The delegate of a `TKCalendarDayView` object must adopt the `TKCalendarDayViewDelegate` protocol. */
@protocol TKCalendarDayViewDelegate <NSObject>


@optional
/** The event view that was selected.
 @param calendarDay The calendar day view.
 @param eventView The `TKCalendarDayEventView` that was selected.
 */
- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDay eventViewWasSelected:(TKCalendarDayEventView *)eventView;

/** The date of the timeline that was brought to focus.
 @param calendarDay The calendar day view.
 @param date The `NSDate` object of the day timeline that was brought to focus.
 */
- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDay didMoveToDate:(NSDate*)date;

@end

#pragma mark - TKCalendarDayViewDataSource
/** The data source of a `TKCalendarDayView` object must adopt the `TKCalendarDayViewDataSource` protocol. */
@protocol TKCalendarDayViewDataSource <NSObject>

@required
/** A data source that will request event views for particular dates.
 @param calendarDay The calendar day view.
 @param date The date of the events that should be returned.
 @return Returns an array of `TKCalendarDayEventView` objects.
 */
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDay eventsForDate:(NSDate *)date;

@end
