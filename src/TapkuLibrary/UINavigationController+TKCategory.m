//
//  UINavigationController+TKCategory.m
//  Created by Devin Ross on 11/24/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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

#import "UINavigationController+TKCategory.h"
#import "TKViewController.h"
#import "TKBarButtonItem.h"

@implementation UINavigationController (TKCategory)

- (void) TKpushViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	if(self.navigationBar.barStyle == UIBarStyleDefault && [self.viewControllers count] > 0 && viewController.navigationItem.leftBarButtonItem == nil && [self.topViewController isKindOfClass:NSClassFromString(@"TKViewController")]){
		TKViewController *vc = (TKViewController*)self.topViewController;
		if(vc.tkBackButton){
			[vc.tkBackButton setStyle:TKBarButtonItemStyleBack];
			[vc.tkBackButton setTarget:self.topViewController.navigationController action:@selector(popViewControllerAnimated:)];
			viewController.navigationItem.leftBarButtonItem = vc.tkBackButton;
		}
	}
	
	[self TKpushViewController:viewController animated:animated];
}

@end
