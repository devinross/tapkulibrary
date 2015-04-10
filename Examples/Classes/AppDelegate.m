//
//  AppDelegate_iPhone.m
//  Created by Devin Ross on 7/7/10.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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

#import "AppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"

#pragma mark - AppDelegate
@implementation AppDelegate


#pragma mark Application lifecycle
- (void) application:(UIApplication *)application commonInitializationLaunching:(NSDictionary *)launchOptions{
	[super application:application commonInitializationLaunching:launchOptions];

	self.root = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.root];
	self.navigationController.view.backgroundColor = [UIColor whiteColor];
	self.window.backgroundColor = [UIColor whiteColor];
	
	
	if([[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPad){
		
		self.splitViewController = [[UISplitViewController alloc] init];
		
		self.detail = [[DetailViewController alloc] init];
		self.splitViewController.delegate = self.detail;
		self.root.detailViewController = self.detail;
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.detail];


		
		self.splitViewController.viewControllers = @[self.navigationController,nav];
		self.window.rootViewController = self.splitViewController;
	}else{
		self.window.rootViewController = self.navigationController;
	}
	

}
- (void) applicationWillEnterForeground:(UIApplication *)application {
	[super applicationWillEnterForeground:application];
	// don't forget to call the super to call applicationDidStartup:
}
- (void) applicationDidStartup:(UIApplication *)application{
	// called by didFinishLaunching.. & willEnterForeground
	
}

+ (AppDelegate*) instance{
	return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

@end
