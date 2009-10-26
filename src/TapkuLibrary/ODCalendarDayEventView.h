//
//  ODCalendarDayEventView.h
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 20/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "TapDetectingView.h"

#define VERTICAL_DIFF 50.0

@interface ODCalendarDayEventView : TapDetectingView {
	NSNumber *_id;
	NSDate *_startDate;
	NSDate *_endDate;
	NSString *_title;
	NSString *_location;
}

@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location;

- (void)setupCustomInitialisation;

+ (id)eventViewWithFrame:(CGRect)frame id:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title location:(NSString *)location;

@end
