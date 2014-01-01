//
//  TKKeyboardTableViewController.m
//  Created by Devin Ross on 10/1/13.
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

#import "TKKeyboardTableViewController.h"
#import "UIDevice+TKCategory.h"

@interface TKKeyboardTableViewController ()
@property (nonatomic,assign) BOOL scrollLock;
@property (nonatomic,assign) CGRect keyboardRect;
@end

@implementation TKKeyboardTableViewController

- (id) init{
	if(!(self=[super init])) return nil;
	self.scrollToTextField = YES;
	self.hideKeyboardOnScroll = [UIDevice phoneIdiom];
	return self;
}
- (id) initWithStyle:(UITableViewStyle)style{
	if(!(self=[super initWithStyle:style])) return nil;
	self.scrollToTextField = YES;
	self.hideKeyboardOnScroll = [UIDevice phoneIdiom];
	return self;
}
- (void) dealloc{
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark View Lifecycle
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark Move ScrollView
- (void) keyboardWillAppear:(NSNotification*)sender{
	if(!self.isViewLoaded || self.view.superview == nil) return;
	
	self.scrollLock = YES;
	
	self.keyboardRect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

	[self _updateInsetWithKeyboard];
	
}
- (void) keyboardWillDisappear:(NSNotification*)sender{
	self.keyboardRect = CGRectZero;
	
	if(!self.isViewLoaded || self.view.superview == nil) return;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, self.bottomLayoutGuide.length, 0);
	[UIView commitAnimations];
	
	self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
- (void) textViewDidBeginEditing:(UITextView *)textView{
	if(!self.scrollToTextField) return;
	self.scrollLock = YES;
	[self performSelector:@selector(scrollToView:) withObject:textView afterDelay:0.1];
}
- (void) textFieldDidBeginEditing:(UITextField *)textField{
	if(!self.scrollToTextField) return;
	self.scrollLock = YES;
	[self performSelector:@selector(scrollToView:) withObject:textField afterDelay:0.1];
}
- (void) _updateInsetWithKeyboard{
	UIWindow *window = [UIApplication sharedApplication].windows[0];
	UIView *mainSubviewOfWindow = window.rootViewController.view;
	CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:self.keyboardRect fromView:window];
	CGRect rect = [self.view convertRect:keyboardFrameConverted fromView:mainSubviewOfWindow];
	rect = CGRectIntersection(rect, self.view.bounds);
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.05];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.tableView.contentInset = self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, CGRectGetHeight(rect), 0);
	[UIView commitAnimations];
}

#pragma mark Rotations
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[self _updateInsetWithKeyboard];
}



#pragma mark UIScrollView Delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	if(self.hideKeyboardOnScroll && !self.scrollLock)
		[self resignResponders];
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	self.scrollLock = NO;
}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	self.scrollLock = NO;
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!decelerate) self.scrollLock = NO;
}
- (void) _unlock{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.scrollLock = NO;
	});
}

#pragma mark Public Functions
- (void) scrollToView:(UIView*)view{
	CGRect rect = [view convertRect:view.bounds toView:self.tableView];
	rect = CGRectInset(rect, 0, -30);
	[self.tableView scrollRectToVisible:rect animated:YES];
	[self performSelector:@selector(_unlock) withObject:nil afterDelay:0.35];
}
- (void) resignResponders{

}

@end
