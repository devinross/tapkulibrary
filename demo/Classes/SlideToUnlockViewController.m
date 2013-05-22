//
//  SlideToUnlockViewController.m
//  Demo
//
//  Created by Devin Ross on 5/21/13.
//
//

#import "SlideToUnlockViewController.h"


@implementation SlideToUnlockViewController


- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.unlockView = [[TKSlideToUnlockView alloc] initWithFrame:self.view.bounds];
	CGFloat y = self.view.bounds.size.height - self.unlockView.frame.size.height;
	self.unlockView.frame = CGRectMakeWithSize(0, y, self.unlockView.frame.size);
	self.unlockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[self.view addSubview:self.unlockView];
	
	[self.unlockView addTarget:self action:@selector(didUnlockView:) forControlEvents:UIControlEventValueChanged];
	
	
	self.unlockView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
	self.unlockView.trackView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
	self.unlockView.textLabel.textColor = [UIColor darkGrayColor];
	self.unlockView.textLabel.text = NSLocalizedString(@"slide to book",@"");
}
- (void) viewDidLoad{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Slide to Unlock", @"");
}

- (void) didUnlockView:(id)sender{
	[self performSelector:@selector(reset) withObject:nil afterDelay:1.0f];
}
- (void) reset{
	[self.unlockView resetSlider:NO];

}

@end
