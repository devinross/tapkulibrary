//
//  ODCalendarDayEvent.m
//  TapkuLibrary
//
//  Created by Anthony Mittaz on 20/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ODCalendarDayEvent.h"


@implementation ODCalendarDayEvent

@synthesize id=_id;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize title=_title;

- (id)init
{
	self = [super init];
	if (self != nil) {
		self.id = nil;
		self.startDate = nil;
		self.endDate = nil;
		self.title = nil;
	}
	return self;
}

+ (id)eventWithId:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title
{
	ODCalendarDayEvent *event = [[[ODCalendarDayEvent alloc]init]autorelease];
	event.id = id;
	event.startDate = startDate;
	event.endDate = endDate;
	event.title = title;
	
	return event;
}

- (void)dealloc {
	[_id release];
	[_startDate release];
	[_endDate release];
	[_title release];
	
    [super dealloc];
}


@end
