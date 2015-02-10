//
//  TKCardModalViewController.m
//  Created by Devin Ross on 10/13/14.
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


#import "TKCardModalViewController.h"
#import "UIDevice+TKCategory.h"
#import "TKGlobal.h"
#import "UIGestureRecognizer+TKCategory.h"

@interface TKCardModalViewController () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior* attachmentBehavior;
@property (nonatomic,strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign) CGFloat magnitude;
@property (nonatomic,assign) CGPoint cardRestingPosition;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

@end

static const CGFloat _resistance = 0.0f;						// linear resistance applied to the image’s dynamic item behavior
static const CGFloat _density = 1.0f;							// relative mass density applied to the image's dynamic item behavior
static const CGFloat _velocityFactor = 1.0f;					// affects how quickly the view is pushed out of the view
static const CGFloat _angularVelocityFactor = 1.0f;				// adjusts the amount of spin applied to the view during a push force, increases towards the view bounds
static const CGFloat _minimumVelocityRequiredForPush = 50.0f;	// defines how much velocity is required for the push behavior to be applied

@implementation TKCardModalViewController

- (instancetype) init{
	if(!(self=[super init])) return nil;
	self.modalPresentationStyle = UIModalPresentationCustom;
	self.transitioningDelegate = self;
	self.tapToDismissEnabled = YES;
	self.throwToDismissEnabled = YES;
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
	self.view.backgroundColor = [UIColor clearColor];
	
	self.visibleFrame = self.view.bounds;
	
	self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	self.backgroundView.alpha = 0;
	[self.view addSubview:self.backgroundView];
	
	
	
	CGSize s = CGSizeMake(280, 200);
	NSInteger minX = (CGFrameGetWidth(self.view)- s.width)/2.0f;
	NSInteger minY = (CGFrameGetHeight(self.view)- s.height)/2.0f;
	CGRect alertRect = CGRectMakeWithSize(minX,minY, s);
	
	
	self.contentView = [[UIView alloc] initWithFrame:alertRect];
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
	self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.contentView.layer.shadowRadius = 3;
	self.contentView.layer.shadowOpacity = 0.1;
	self.contentView.layer.cornerRadius = 8;
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self.view addSubview:self.contentView];
	
	
	
	self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	self.panGesture.enabled = self.throwToDismissEnabled;
	[self.contentView addGestureRecognizer:self.panGesture];
	
	self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	self.tapGesture.enabled = self.tapToDismissEnabled;
	self.tapGesture.delegate = self;
	[self.view addGestureRecognizer:self.tapGesture];
	
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	
	
}
- (void) viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	if (NSStringFromClass([UIInterpolatingMotionEffect class])) {
		UIInterpolatingMotionEffect *mx;
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		mx.maximumRelativeValue = @(15);
		mx.minimumRelativeValue = @(-15);
		[self.contentView addMotionEffect:mx];
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		mx.maximumRelativeValue = @(15);
		mx.minimumRelativeValue = @(-15);
		[self.contentView addMotionEffect:mx];
	}
}

#pragma makr Keyboard Notifications
- (void) keyboardWillShow:(NSNotification*)notification{
	
	NSValue *keyRectVal = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
	CGRect keyFrame = [keyRectVal CGRectValue];
	
	CGRect bounds = self.view.bounds;
	bounds.origin.y = 20;
	bounds.size.height -= keyFrame.size.height;
	bounds.size.height -= 20;
	self.visibleFrame = bounds;
	
	[UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.4 options:0 animations:^{
		NSInteger y = (CGRectGetHeight(bounds)-CGFrameGetHeight(self.contentView))/2;
		CGRect rr = self.contentView.frame;
		rr.origin.y = y;
		self.contentView.frame = rr;
	}completion:nil];
}
- (void) keyboardWillHide:(NSNotification*)notification{
	
	self.visibleFrame = self.view.bounds;
	[UIView animateWithDuration:0.9 delay:0.3 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:0 animations:^{
		NSInteger y = (CGFrameGetHeight(self.view)-CGFrameGetHeight(self.contentView))/2;
		CGRect rr = self.contentView.frame;
		rr.origin.y = y;
		self.contentView.frame = rr;
	}completion:nil];
}


#pragma mark Gestures Actions
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	CGPoint p = [touch locationInView:self.contentView.superview];
	if(gestureRecognizer == self.tapGesture && CGRectContainsPoint(self.contentView.frame, p))
		return NO;
	return YES;
}
- (void) tapped:(UITapGestureRecognizer*)sender{
	
	if(self.onlyAllowTapOffCardToDismiss){
		CGPoint p = [sender locationInView:self.contentView.superview];
		if(!CGRectContainsPoint(self.contentView.frame, p)) [self hide];
	}else
		[self hide];
	
	
}
- (void) pan:(UIPanGestureRecognizer*)gesture{
	if(!self.throwToDismissEnabled) return;
	
	UIView *view = gesture.view;
	UIView *cnt = view.superview;
	
	CGPoint p = [gesture locationInView:view.superview];
	CGPoint velocity = [gesture velocityInView:cnt];
	CGFloat magnitude = sqrt(pow(velocity.x,2) + pow(velocity.y, 2));
	UIOffset offset = UIOffsetMake(p.x - view.center.x, p.y - view.center.y);
	CGPoint o = CGPointMake(CGRectGetMidX(cnt.bounds), CGRectGetMidY(cnt.bounds));
	CGFloat angle = atan2(p.y-o.y, p.x-o.x);
	
	if(gesture.began){
		
		self.cardRestingPosition = self.contentView.center;
		
		[self.animator removeAllBehaviors];
		
		self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
		self.itemBehavior.elasticity = 0.0f;
		self.itemBehavior.friction = 0.2f;
		self.itemBehavior.allowsRotation = YES;
		self.itemBehavior.density = _density;
		self.itemBehavior.resistance = _resistance;
		[self.animator addBehavior:self.itemBehavior];
		
		self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:view offsetFromCenter:offset attachedToAnchor:p];
		[self.animator addBehavior:self.attachmentBehavior];
		
	}
	
	self.attachmentBehavior.anchorPoint = p;
	
	if(gesture.changed){
		self.angle = angle;
		self.magnitude = magnitude;
	}
	
	
	if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
		
		[self.animator removeAllBehaviors];
		CGPoint location = [gesture locationInView:cnt];
		CGPoint boxLocation = [gesture locationInView:view];
		
		// need to scale velocity values to tame down physics on the iPad
		CGFloat deviceVelocityScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.2f : 1.0f;
		CGFloat deviceAngularScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.7f : 1.0f;
		// factor to increase delay before `dismissAfterPush` is called on iPad to account for more area to cover to disappear
		//CGFloat deviceDismissDelay = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.8f : 1.0f;
		CGPoint velocity = [gesture velocityInView:self.view];
		CGFloat velocityAdjust = 10.0f * deviceVelocityScale;
		
		if (fabs(velocity.x / velocityAdjust) > _minimumVelocityRequiredForPush || fabs(velocity.y / velocityAdjust) > _minimumVelocityRequiredForPush) {
			
			
			self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
			self.pushBehavior.angle = 0.0f;
			self.pushBehavior.magnitude = 0.0f;
			
			
			UIOffset offsetFromCenter = UIOffsetMake(boxLocation.x - CGRectGetMidX(view.bounds), boxLocation.y - CGRectGetMidY(view.bounds));
			CGFloat radius = sqrtf(powf(offsetFromCenter.horizontal, 2.0f) + powf(offsetFromCenter.vertical, 2.0f));
			CGFloat pushVelocity = sqrtf(powf(velocity.x, 2.0f) + powf(velocity.y, 2.0f));
			
			// calculate angles needed for angular velocity formula
			CGFloat velocityAngle = atan2f(velocity.y, velocity.x);
			CGFloat locationAngle = atan2f(offsetFromCenter.vertical, offsetFromCenter.horizontal);
			if (locationAngle > 0) {
				locationAngle -= M_PI * 2;
			}
			
			// angle (θ) is the angle between the push vector (V) and vector component parallel to radius, so it should always be positive
			CGFloat angle = fabs(fabs(velocityAngle) - fabs(locationAngle));
			// angular velocity formula: w = (abs(V) * sin(θ)) / abs(r)
			CGFloat angularVelocity = fabs((fabs(pushVelocity) * sinf(angle)) / fabs(radius));
			
			// rotation direction is dependent upon which corner was pushed relative to the center of the view
			// when velocity.y is positive, pushes to the right of center rotate clockwise, left is counterclockwise
			CGFloat direction = (location.x < view.center.x) ? -1.0f : 1.0f;
			// when y component of velocity is negative, reverse direction
			if (velocity.y < 0) { direction *= -1; }
			
			// amount of angular velocity should be relative to how close to the edge of the view the force originated
			// angular velocity is reduced the closer to the center the force is applied
			// for angular velocity: positive = clockwise, negative = counterclockwise
			CGFloat xRatioFromCenter = fabs(offsetFromCenter.horizontal) / (CGRectGetWidth(view.frame) / 2.0f);
			CGFloat yRatioFromCetner = fabs(offsetFromCenter.vertical) / (CGRectGetHeight(view.frame) / 2.0f);
			
			// apply device scale to angular velocity
			angularVelocity *= deviceAngularScale;
			// adjust angular velocity based on distance from center, force applied farther towards the edges gets more spin
			angularVelocity *= ((xRatioFromCenter + yRatioFromCetner) / 2.0f);
			
			
			
			
			[self.itemBehavior addAngularVelocity:angularVelocity * _angularVelocityFactor * direction forItem:view];
			[self.animator addBehavior:self.pushBehavior];
			self.pushBehavior.pushDirection = CGVectorMake((velocity.x / velocityAdjust) * _velocityFactor, (velocity.y / velocityAdjust) * _velocityFactor);
			self.pushBehavior.active = YES;
			[self.animator addBehavior:self.pushBehavior];
			
			
			CGFloat dimension = MAX(CGFrameGetHeight(self.contentView),CGFrameGetWidth(self.contentView)) * 1.2;
			dimension = -MAX(dimension,420);
			
			UICollisionBehavior *collide = [[UICollisionBehavior alloc] initWithItems:@[view]];
			collide.translatesReferenceBoundsIntoBoundary = YES;
			[collide setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(dimension, dimension, dimension, dimension)];
			collide.collisionDelegate = self;
			[self.animator addBehavior:collide];
			
			// delay for dismissing is based on push velocity also
			return;
		}
		
		
		//CGPoint pp = [self.view convertPoint:self.cardRestingPosition toView:cnt];
		UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:view snapToPoint:self.cardRestingPosition];
		snapBehavior.damping = 0.85;
		[self.animator addBehavior:snapBehavior];
		
	}
	
}

#pragma mark Actions
- (void) show{
	id <UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	[[delegate window].rootViewController presentViewController:self animated:YES completion:nil];
}
- (void) hide{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIViewControllerTransitioningDelegate
- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if([toVC isKindOfClass:[self class]])
		return 0.8f;
	return 0.4f + 0.5f;
}
- (void) showAlertView:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	UIView *containerView = [transitionContext containerView];
	[containerView addSubview:toVC.view];
	
	toVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
	
	CGFloat originalX = self.contentView.center.x;
	CGFloat originalMinX = CGFrameGetMinX(self.contentView);
	
	self.contentView.center = CGPointMake(originalX, -300);
	self.contentView.transform = CGRotate(-10 * M_PI / 180.0f);
	
	[UIView animateWithDuration:0.4 animations:^{
		self.backgroundView.alpha = 1;
	}];
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
		self.contentView.transform = CGAffineTransformIdentity;
		NSInteger y = (CGRectGetHeight(self.visibleFrame) - CGFrameGetHeight(self.contentView)) / 2;
		self.contentView.frame = CGRectMake(originalMinX, y, CGFrameGetWidth(self.contentView), CGFrameGetHeight(self.contentView));
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:YES];
	}];
	
}
- (void) hideAlertView:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	if(self.contentView.superview){
		
		if(!self.animator)
			self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
		
		
		[self.animator removeAllBehaviors];
		
		UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.contentView]];
		gravity.magnitude = 3;
		[self.animator addBehavior:gravity];
		
		UIDynamicItemBehavior *behav = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
		behav.allowsRotation = YES;
		behav.friction = 0.5;
		
		CGFloat velocity = (arc4random() % 20) - 10.0f;
		velocity /= 100.0f;
		[behav addAngularVelocity:velocity forItem:self.contentView];
		[self.animator addBehavior:behav];
		
	}
	
	[UIView animateWithDuration:0.4 delay:0.4 options:0 animations:^{
		self.backgroundView.transform = CGAffineTransformIdentity;
		self.backgroundView.alpha = 0;
	} completion:^(BOOL finished){
		[self.view removeFromSuperview];
		[transitionContext completeTransition:YES];
	}];
	
}
- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
	
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if([toVC isKindOfClass:[self class]])
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
- (void) collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
	[self.animator removeAllBehaviors];
	[self.contentView removeFromSuperview];
	[self hide];
}

#pragma mark Properties
- (void) setTapToDismissEnabled:(BOOL)tapToDismissEnabled{
	_tapToDismissEnabled = tapToDismissEnabled;
	self.tapGesture.enabled = tapToDismissEnabled;
}
- (void) setThrowToDismissEnabled:(BOOL)throwToDismissEnabled{
	_throwToDismissEnabled = throwToDismissEnabled;
	self.panGesture.enabled = throwToDismissEnabled;
}

@end