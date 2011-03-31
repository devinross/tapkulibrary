//
//  AppDelegate_iPad.m
//  Created by Devin Ross on 7/7/10.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
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



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
- (void)dealloc {
	[splitViewController release];
	[detail release];
	[left release];
    [window release];
    [super dealloc];
}


@end
