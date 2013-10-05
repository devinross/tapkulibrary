//
//  TKAppDelegate.h
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

@import Foundation;
@import UIKit;

@class TKWindow;

/** This class allocates a TKWindow instance and provides a convience method for application launching. */
@interface TKAppDelegate : NSObject <UIApplicationDelegate> 


/** This is a convience method for setup of the initial app state. 
 Apple recommends placing initialization of 
 application:willFinishLaunchingWithOptions (instead of didFinish) 
 for iOS 6 despite its absence in previous versions of iOS.
 Subclassing the method will take care of that recommendation. The 
 UIWindow for the application is allocated and setup just before 
 this method is called. The default implementation does nothing.
 @param application The application instance.
 @param launchOptions The launch options.
 */
- (void) application:(UIApplication *)application commonInitializationLaunching:(NSDictionary *)launchOptions;



/** This is a convience method for placing any functionality that might be called upon initial launch of the application and any subsequent relaunch from a background state. Default implementation does nothing.
 @param application The application instance.
 */
- (void) applicationDidStartup:(UIApplication *)application;


///----------------------------
/// @name Properties
///----------------------------

/** Returns the application main window. */
@property (nonatomic,strong) UIWindow *window;

@end
