//
//  SlideToUnlockViewController.m
//  Demo
//
//  Created by Devin Ross on 5/21/13.
//
//

#import "SlideToUnlockViewController.h"


@implementation SlideToUnlockViewController


- (NSUInteger) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskPortrait;
}

- (void) loadView{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	UIImageView *image = [UIImageView imageViewWithImageNamed:@"wallpaper"];
	[self.view addSubview:image];
	
	
	if([self respondsToSelector:@selector(edgesForExtendedLayout)])
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	
	
	
	
	self.unlockView = [[TKSlideToUnlockView alloc] init];
	[self.view addSubview:self.unlockView];
	
	[self.unlockView addTarget:self action:@selector(didUnlockView:) forControlEvents:UIControlEventValueChanged];
	
	
	CGRect unlock = self.unlockView.frame;
	
	unlock.origin.y = 330;
	
	self.unlockView.frame = unlock;
	
	self.unlockView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

}
- (void) viewDidLoad{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Slide to Unlock", @"");
	
	
	if(NSStringFromClass([UIInterpolatingMotionEffect class])){
		
		UIInterpolatingMotionEffect *mx;
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		mx.maximumRelativeValue = @(10);
		mx.minimumRelativeValue = @(-10);
		[self.unlockView addMotionEffect:mx];
		
		mx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		mx.maximumRelativeValue = @(10);
		mx.minimumRelativeValue = @(-10);
		[self.unlockView addMotionEffect:mx];
		
		
	}

	

}
- (void) viewWillAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	

	[self.unlockView setNeedsLayout];
}

- (void) didUnlockView:(id)sender{
	[self performSelector:@selector(reset) withObject:nil afterDelay:1.0f];
}
- (void) reset{
	[self.unlockView resetSlider:NO];

}

@end
