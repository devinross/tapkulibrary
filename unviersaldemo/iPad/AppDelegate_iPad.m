//
//  AppDelegate_iPad.m
//  unviersaldemo
//
//  Created by Devin Ross on 7/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_iPad.h"

#import "LeftTableViewController.h"
#import "DetailViewController.h"
@implementation AppDelegate_iPad
@synthesize window,splitViewController,left,detail;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	CGRect frame = [UIScreen mainScreen].bounds;
	window = [[UIWindow alloc] initWithFrame:frame];
	window.backgroundColor = [UIColor blackColor];
    [window makeKeyAndVisible];
	
	
	splitViewController = [[UISplitViewController alloc] init];
	
	detail = [[DetailViewController alloc] init];
	splitViewController.delegate = detail;
	
	left = [[LeftTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	left.detailViewController = detail;
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:left];

	splitViewController.viewControllers = [NSArray arrayWithObjects:nav1,detail,nil];
	[self.window addSubview:splitViewController.view];

	
	[nav1 release];
	
	/*
	
	splitViewController = [[UISplitViewController alloc] init];
	left = [[LeftTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detail = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
	self.splitViewController.viewControllers = [NSArray arrayWithObjects:left,detail,nil];

	[splitViewController.view addSubview:left.view];
	

	splitViewController.delegate = detail;
	[window addSubview:splitViewController.view];
	
	left.detailViewController = detail;
	
	*/
	
	
	NSLog(@"HELLO");

	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
