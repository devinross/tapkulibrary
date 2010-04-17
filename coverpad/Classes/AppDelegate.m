//
//  coverpadAppDelegate.m
//  coverpad
//
//  Created by Devin Ross on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "coverflowViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
	

	[window makeKeyAndVisible];
	
  
	
	viewController = [[coverflowViewController alloc] init];
	[window addSubview:viewController.view];
   

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
