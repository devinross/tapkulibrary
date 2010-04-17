//
//  coverpadAppDelegate.h
//  coverpad
//
//  Created by Devin Ross on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class coverflowViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    coverflowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) coverflowViewController *viewController;

@end

