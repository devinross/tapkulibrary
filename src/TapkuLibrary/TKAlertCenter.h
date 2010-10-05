//
//  TKAlertCenter.h
//  PhiloTV
//
//  Created by Devin Ross on 9/29/10.
//  Copyright 2010 Philo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapkuLibrary/TapkuLibrary.h>
@class TKAlertView;


@interface TKAlertCenter : NSObject {

	NSMutableArray *alerts;
	BOOL active;
	TKAlertView *alertView;
	
}

+ (TKAlertCenter*) defaultCenter;

- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image;

@end





