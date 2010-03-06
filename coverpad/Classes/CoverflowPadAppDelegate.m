//
//  CoverflowPadAppDelegate.m
//  CoverflowPad
//
//  Created by Devin Ross on 1/27/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "CoverflowPadAppDelegate.h"
#import "CoverflowPadViewController.h"

@implementation CoverflowPadAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
