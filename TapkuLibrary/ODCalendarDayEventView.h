//
//  ODCalendarDayEventView.h
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 20/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingView.h"

@interface ODCalendarDayEventView : TapDetectingView {
	NSNumber *_id;
	NSDate *_startDate;
	NSDate *_endDate;
	NSString *_title;
}

@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *title;

- (void)setupCustomInitialisation;

+ (id)eventViewWithFrame:(CGRect)frame id:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title;

@end
