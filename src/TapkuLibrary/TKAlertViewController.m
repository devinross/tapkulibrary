//
//  TKAlertViewController.m
//  Created by Devin Ross on 10/21/13.
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

#import "TKAlertViewController.h"
#import "TKGlobal.h"
#import "UIDevice+TKCategory.h"

@interface TKAlertViewController ()
@property (nonatomic,strong) UIDynamicAnimator *animator;
@end

@implementation TKAlertViewController

- (id) init{
	if(!(self=[super init])) return nil;
	self.modalPresentationStyle = UIModalPresentationCustom;
	self.transitioningDelegate = self;
	return self;
}

- (NSUInteger) supportedInterfaceOrientations{
	if([UIDevice padIdiom])
		return UIInterfaceOrientationMaskAll;
	return UIInterfaceOrientationMaskPortrait;
}


#pragma mark View Lifecycle
- (void) loadView{
	[super loadView];
	
	CGSize s = CGSizeMake(280, 300);
	CGRect alertRect = CGRectMakeWithSize( (CGRectGetWidth(self.view.frame)- s.width)/2.0f, (CGRectGetHeight(self.view.frame)- s.height)/2.0f, s);
	
	self.alertView = [[UIView alloc] initWithFrame:alertRect];
	self.alertView.backgroundColor = [UIColor whiteColor];
	self.alertView.layer.shadowOffset = CGSizeMake(0, 1);
	self.alertView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.alertView.layer.shadowRadius = 3;
	self.alertView.layer.shadowOpacity = 0.1;
	self.alertView.layer.cornerRadius = 8;
	[self.view addSubview:self.alertView];

	self.alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	if (NSStringFromClass([UIInterpolatingMotionEffect class])) {
		UIInterpolatingMotionEffect *mx;
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		mx.maximumRelativeValue = @(15);
		mx.minimumRelativeValue = @(-15);
		[self.alertView addMotionEffect:mx];
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		mx.maximumRelativeValue = @(15);
		mx.minimumRelativeValue = @(-15);
		[self.alertView addMotionEffect:mx];
	}
}


- (void) show{
	id <UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	[[delegate window].rootViewController presentViewController:self animated:YES completion:nil];
}
- (void) hide{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate
- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if([toVC isKindOfClass:[TKAlertViewController class]])
		return 0.5f;
	return 0.4f + 0.5f;
}

- (void) showAlertView:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	NSInteger x = (CGRectGetWidth(self.alertView.superview.bounds) - CGRectGetWidth(self.alertView.frame)) / 2.0f;
	NSInteger y = (CGRectGetHeight(self.alertView.superview.bounds) - CGRectGetHeight(self.alertView.frame)) / 2.0f;
	self.alertView.frame = CGRectMakeWithSize(x, y, self.alertView.frame.size);
	
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView *containerView = [transitionContext containerView];
	[containerView addSubview:toVC.view];
	
	
	
	toVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
	toVC.view.alpha = 0;
	

	self.alertView.transform = CGScale(0.8, 0.8);
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
		toVC.view.alpha = 1;
		toVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
	}];
	
	
	[UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
		
		CGFloat whole = 1.0f;
		
		[UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
			self.alertView.transform = CGScale(1.08, 1.08);
		}];
		
		whole -= 0.3;
		
		[UIView addKeyframeWithRelativeStartTime:1.0f - whole relativeDuration:whole/2 animations:^{
			self.alertView.transform = CGScale(0.98, 0.98);
		}];
		
		whole /= 2;
		
		[UIView addKeyframeWithRelativeStartTime:1.0f - whole relativeDuration:whole animations:^{
			self.alertView.transform = CGAffineTransformIdentity;
		}];
		
	}completion:^(BOOL finished){
		[transitionContext completeTransition:YES];
	}];
	
	
}
- (void) hideAlertView:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	
	UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
	gravity.magnitude = 3;
	[self.animator addBehavior:gravity];
	
	UIDynamicItemBehavior *behav = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
	behav.allowsRotation = YES;
	behav.friction = 0.5;
    
	CGFloat velocity = (arc4random() % 20) - 10.0f;
	velocity /= 100.0f;
	[behav addAngularVelocity:velocity forItem:self.alertView];
	
	[self.animator addBehavior:behav];
	
	
	[UIView animateWithDuration:0.4 delay:0.5f options:0 animations:^{
		self.view.alpha = 0;
		self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];

	}completion:^(BOOL finished){
		[transitionContext completeTransition:YES];
	}];
	
}
- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if([toVC isKindOfClass:[TKAlertViewController class]])
		[self showAlertView:transitionContext];
	else
		[self hideAlertView:transitionContext];
	
}
- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
	return self;
}
- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed{
	return self;
}


@end