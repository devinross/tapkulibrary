//
//  UIViewController+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 8/23/13.
//
//

#import "UIViewController+TKCategory.h"

@implementation UIViewController (TKCategory)

- (void) presentNavigationControllerWithRoot:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
	
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
	
	[self presentViewController:nav animated:flag completion:completion];
	
}



@end
