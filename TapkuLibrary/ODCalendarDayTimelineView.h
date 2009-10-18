//
//  ODCalendarDayTimelineView.h
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 18/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ODCalendarDayTimelineViewDelegate;

@class ODTimelineView;

@interface ODCalendarDayTimelineView : UIView {
	UIScrollView *_scrollView;
	ODTimelineView *_timelineView;
	
	id <ODCalendarDayTimelineViewDelegate> _delegate;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) ODTimelineView *timelineView;

@property (nonatomic, retain) id <ODCalendarDayTimelineViewDelegate> delegate;

// Initialisation
- (void)setupCustomInitialisation;

@end

@protocol ODCalendarDayTimelineViewDelegate<NSObject>
@required

- (void)calendarDayTimelineView:(ODCalendarDayTimelineView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate;

@end

@interface ODTimelineView : UIView {
	
}

// Initialisation
- (void)setupCustomInitialisation;

@end

