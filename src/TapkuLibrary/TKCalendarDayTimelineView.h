//
//  ODCalendarDayTimelineView.h
//  Created by Devin Ross on 7/28/09.
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

#import <UIKit/UIKit.h>
#import "TKCalendarDayEventView.h"

@protocol TKCalendarDayTimelineViewDelegate;

@class TKTimelineView;

@interface TKCalendarDayTimelineView : UIView <TapDetectingViewDelegate>{
	UIScrollView *_scrollView;
	TKTimelineView *_timelineView;
	
	NSArray *_events;
	NSDate *_currentDay;
	
	id <TKCalendarDayTimelineViewDelegate> _delegate;
	UIColor *timelineColor;
	UIColor *hourColor;
	BOOL is24hClock;
	//montagem da barra superior de seleção de dias 
	UIButton *leftArrow, *rightArrow;
	UIImageView *topBackground, *shadow;
	UILabel *monthYear;	
}

@property (unsafe_unretained, nonatomic, readonly) UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic, readonly) TKTimelineView *timelineView;

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, copy) NSDate *currentDay;

@property (nonatomic, strong) id <TKCalendarDayTimelineViewDelegate> delegate;

@property (nonatomic, strong) UIColor *timelineColor;
@property (nonatomic, strong) UIColor *hourColor;
@property (nonatomic) BOOL is24hClock;

// Initialisation
- (void)setupCustomInitialisation;

// Reload Day
- (void)reloadDay;

@end

@protocol TKCalendarDayTimelineViewDelegate<NSObject>
@required

- (NSArray *) calendarDayTimelineView:(TKCalendarDayTimelineView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate;

@optional
- (void) calendarDayTimelineView:(TKCalendarDayTimelineView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView;
- (void) calendarDayTimelineView:(TKCalendarDayTimelineView*)calendarDayTimeline eventDateWasSelected:(NSDate*)eventDate;

@end

@interface TKTimelineView : TapDetectingView {
	NSArray *_times;
	NSArray *_periods;
	BOOL is24hClock;
	UIColor *hourColor;	
}

@property (nonatomic, readonly) NSArray *times;
@property (nonatomic, readonly) NSArray *periods;
@property (nonatomic, strong) UIColor *hourColor;
@property (nonatomic) BOOL is24hClock;

// Initialisation
- (void)setupCustomInitialisation;

@end
