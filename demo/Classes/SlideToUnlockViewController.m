//
//  SlideToUnlockViewController.m
//  Created by Devin Ross on 5/21/13.
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
