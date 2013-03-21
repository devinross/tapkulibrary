//
//  AlertsViewController.m
//  Created by Devin Ross on 10/6/10.
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

#import "AlertsViewController.h"

#pragma mark - AlertsViewController
@implementation AlertsViewController

- (id) init{
	if(!(self=[super init])) return nil;
	self.title = NSLocalizedString(@"Alerts",@"Alerts");
	return self;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark View Lifecycle
- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Tap Me" style:UIBarButtonItemStyleBordered target:self action:@selector(beer)];
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
		self.navigationItem.rightBarButtonItem = item;
	}else{
		self.toolbarItems = @[item];
	}
	
	
	self.tapMeItem = item;
	item.enabled = NO;
	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	
	[self performSelector:@selector(showKeyboardAlerts) withObject:nil afterDelay:5.0];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Hi!"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"This is the alert system"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Use images too!" image:[UIImage imageNamed:@"beer"]];

}

- (void) showKeyboardAlerts{
	
	self.hiddenTextField = [[UITextField alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.hiddenTextField];
	
	[self.hiddenTextField becomeFirstResponder];
	
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Hi!"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"This is the alert system"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Use images too!" image:[UIImage imageNamed:@"beer"]];
	[self performSelector:@selector(completedKeyboard) withObject:nil afterDelay:5.0];

}

- (void) completedKeyboard{
	
	[self.hiddenTextField resignFirstResponder];
	self.tapMeItem.enabled = YES;
}


- (void) beer{
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Beer!" image:[UIImage imageNamed:@"beer"]];
}


@end