//
//  TKAppDelegate.m
//  Created by Devin Ross on 1/31/11.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

#import "TKAppDelegate.h"
#import "TKWindow.h"

@implementation TKAppDelegate




- (void) application:(UIApplication *)application commonInitializationLaunching:(NSDictionary *)launchOptions{

}
- (void) _application:(UIApplication *)application commonInitializationLaunching:(NSDictionary *)launchOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		
		if(self.window==nil){
			self.window = [[TKWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			self.window.backgroundColor = [UIColor blackColor];
			[self.window makeKeyAndVisible];
		}
		[self application:application commonInitializationLaunching:launchOptions];

    });
}


- (BOOL) application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	[self _application:application commonInitializationLaunching:launchOptions];
    return YES;
}
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self _application:application commonInitializationLaunching:launchOptions];
	[self applicationDidStartup:application];
    return YES;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
	[self applicationDidStartup:application];
}
- (void) applicationDidStartup:(UIApplication *)application{
	// Default Implementaion Does Nothing
}




- (void) applicationDidEnterBackground:(UIApplication *)application {
	
}
- (void) applicationWillTerminate:(UIApplication *)application {
	
}

- (void) applicationWillResignActive:(UIApplication *)application {
	
}
- (void) applicationDidBecomeActive:(UIApplication *)application {
	
}

#pragma mark Memory management
- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	
}





@end
