//
//  ShakeWindow.m
//  AlbumCovers
//
//  Created by Devin Ross on 6/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKShakeWindow.h"


@implementation TKShakeWindow



- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"motionBegan" object:self];
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"motionCancelled" object:self];
}
- (void)motionEnded:withEvent:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"motionEnded" object:self];
}

@end
