//
//  UIViewController+TKCategory.h
//  TapkuLibrary
//
//  Created by Devin Ross on 8/23/13.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (TKCategory)

- (void) presentNavigationControllerWithRoot:(UIViewController *)rootViewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end
