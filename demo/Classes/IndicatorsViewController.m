//
//  HUDViewController.m
//  Created by Devin Ross on 7/4/09.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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

#import "IndicatorsViewController.h"

@implementation IndicatorsViewController

- (id) init{
	if(!(self=[super init])) return nil;
	self.title = @"HUD";
	return self;
}

#pragma mark View Lifecycle
- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
	
	[self.view addSubview:self.progressBar];
	[self.view addSubview:self.progressCircle];
	[self.view addSubview:self.progressBarAlternative];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Tap Me" style:UIBarButtonItemStyleBordered target:self action:@selector(tapme)];
	self.navigationItem.rightBarButtonItem = item;
	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];	
	[self stepTwo:nil];
}

#pragma mark Actions
- (void) tapme{
	
	[self.progressCircle setTwirlMode:!self.progressCircle.isTwirling];
	
	if(!self.progressCircle.isTwirling){
		[self.progressCircle setProgress:0 animated:NO];
		[self.progressBar setProgress:0];
		[self.progressBarAlternative setProgress:0 animated:NO];
		

		TKProgressAlertView *alert = [[TKProgressAlertView alloc] initWithProgressTitle:@"Loading important stuff!"];
		alert.progressBar.progress = 0;
		[alert show];
		
		[self performSelector:@selector(stepTwo:) withObject:alert afterDelay:2];
		[self performSelector:@selector(stepThree:) withObject:alert afterDelay:4];
		
	}
	
	
}
- (void) stepTwo:(TKProgressAlertView*)alert{
	
	[self.progressCircle setProgress:1 animated:YES];
	[self.progressBar setProgress:1 animated:YES];
	[self.progressBarAlternative setProgress:1 animated:YES];
	
	[alert.progressBar setProgress:1 animated:YES];
	
}
- (void) stepThree:(TKProgressAlertView*)alert{
	
	[alert hide];
	
}

#pragma mark Properties
- (TKProgressBarView *) progressBar{
	if(_progressBar) return _progressBar;
	
	_progressBar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleShort];
	_progressBar.center = CGPointMake(self.view.bounds.size.width/2, 220);
	return _progressBar;
}
- (TKProgressBarView *) progressBarAlternative{
	if(_progressBarAlternative) return _progressBarAlternative;
	
	_progressBarAlternative = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
	_progressBarAlternative.center = CGPointMake(self.view.bounds.size.width/2, 320);
	return _progressBarAlternative;
}
- (TKProgressCircleView *) progressCircle{
	if(_progressCircle) return _progressCircle;

	_progressCircle = [[TKProgressCircleView alloc] init];
	_progressCircle.center = CGPointMake(self.view.bounds.size.width/2, 120);
	return _progressCircle;
}

@end