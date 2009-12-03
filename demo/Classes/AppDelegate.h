//
//  TapkuLibraryDemoAppDelegate.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 12/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

