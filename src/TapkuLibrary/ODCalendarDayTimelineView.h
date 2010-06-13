//
//  ODCalendarDayTimelineView.h
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 18/10/09.
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
#import "ODCalendarDayEventView.h"

@protocol ODCalendarDayTimelineViewDelegate;

@class ODTimelineView;

@interface ODCalendarDayTimelineView : UIView <TapDetectingViewDelegate>{
	UIScrollView *_scrollView;
	ODTimelineView *_timelineView;
	
	NSArray *_events;
	NSDate *_currentDay;
	
	id <ODCalendarDayTimelineViewDelegate> _delegate;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) ODTimelineView *timelineView;

@property (nonatomic, retain) NSArray *events;
@property (nonatomic, copy) NSDate *currentDay;

@property (nonatomic, retain) id <ODCalendarDayTimelineViewDelegate> delegate;

// Initialisation
- (void)setupCustomInitialisation;

// Reload Day
- (void)reloadDay;

@end

@protocol ODCalendarDayTimelineViewDelegate<NSObject>
@required

- (NSArray *)calendarDayTimelineView:(ODCalendarDayTimelineView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate;

@optional
- (void)calendarDayTimelineView:(ODCalendarDayTimelineView*)calendarDayTimeline eventViewWasSelected:(ODCalendarDayEventView *)eventView;

@end

@interface ODTimelineView : UIView {
	NSArray *_times;
	NSArray *_periods;
}

@property (nonatomic, readonly) NSArray *times;
@property (nonatomic, readonly) NSArray *periods;

// Initialisation
- (void)setupCustomInitialisation;

@end

