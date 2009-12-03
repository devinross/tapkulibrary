//
//  TapkuLibraryDemoAppDelegate.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 12/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


@implementation AppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

