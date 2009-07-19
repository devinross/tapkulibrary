//
//  DRPlace.m
//  iRPI
//
//  Created by Devin Ross on 4/15/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "TKPlace.h"


@implementation TKPlace
@synthesize title,coordinate, color;

- (id)init{
	[super init];
	return self;
}

- (void)dealloc {
	NSLog(@"Dealloc DRPLACE");
    [super dealloc];
	[title release];
}

@end
