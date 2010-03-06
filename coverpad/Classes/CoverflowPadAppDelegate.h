//
//  CoverflowPadAppDelegate.h
//  CoverflowPad
//
//  Created by Devin Ross on 1/27/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoverflowPadViewController;

@interface CoverflowPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CoverflowPadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CoverflowPadViewController *viewController;

@end

