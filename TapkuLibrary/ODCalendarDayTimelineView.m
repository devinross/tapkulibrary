//
//  ODCalendarDayTimelineView.m
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 18/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ODCalendarDayTimelineView.h"

#define TIMELINE_HEIGHT 600.0


@implementation ODCalendarDayTimelineView

@synthesize delegate=_delegate;

#pragma mark -
#pragma mark Initialisation

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when xibless (interface buildder)
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Custom initialization
		[self setupCustomInitialisation];
    }
    return self;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when using xib (interface buildder)
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		// Custom initialization
		[self setupCustomInitialisation];
	}
	return self;
}

- (void)setupCustomInitialisation
{
	// Initialization code
	// Nothing yet
}

#pragma mark -
#pragma mark Setup

- (UIScrollView *)scrollView
{
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.contentSize = CGSizeMake(self.bounds.size.width,TIMELINE_HEIGHT);
		[self addSubview:_scrollView];
		_scrollView.scrollEnabled = TRUE;
		_scrollView.backgroundColor =[UIColor whiteColor];
	}
	return _scrollView;
}

- (ODTimelineView *)timelineView
{
	if (!_timelineView) {
		_timelineView = [[ODTimelineView alloc]initWithFrame:CGRectMake(self.bounds.origin.x, 
																		self.bounds.origin.y,
																		self.bounds.size.width,
																		TIMELINE_HEIGHT)];
		[self.scrollView addSubview:_timelineView];
		
	}
	return _timelineView;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[_timelineView release];
	[_scrollView release];
	
    [super dealloc];
}


@end

@implementation ODTimelineView

#pragma mark -
#pragma mark Initialisation

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when xibless (interface buildder)
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Custom initialization
		[self setupCustomInitialisation];
    }
    return self;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
// Only when using xib (interface buildder)
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
		// Custom initialization
		[self setupCustomInitialisation];
	}
	return self;
}

- (void)setupCustomInitialisation
{
	// Initialization code
	// Nothing yet
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Here Draw timeline from 12 am to noon to 12 pm
}


- (void)dealloc {
	
    [super dealloc];
}


@end
