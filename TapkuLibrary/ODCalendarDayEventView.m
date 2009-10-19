//
//  ODCalendarDayEventView.m
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 20/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ODCalendarDayEventView.h"


@implementation ODCalendarDayEventView

@synthesize id=_id;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize title=_title;

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
	self.id = nil;
	self.startDate = nil;
	self.endDate = nil;
	self.title = nil;
	
	twoFingerTapIsPossible = FALSE;
	
	self.backgroundColor = [UIColor purpleColor];
	self.alpha = 0.7;
	CALayer *layer = [self layer];
	layer.masksToBounds = YES;
	[layer setCornerRadius:5.0];
	// You can even add a border
	[layer setBorderWidth:0.5];
	[layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

+ (id)eventViewWithFrame:(CGRect)frame id:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title
{
	ODCalendarDayEventView *event = [[[ODCalendarDayEventView alloc]initWithFrame:frame]autorelease];
	event.id = id;
	event.startDate = startDate;
	event.endDate = endDate;
	event.title = title;
	
	return event;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
	[_id release];
	[_startDate release];
	[_endDate release];
	[_title release];
	
    [super dealloc];
}








@end
