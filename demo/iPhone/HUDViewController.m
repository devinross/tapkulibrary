//
//  HUDViewController.m
//  Created by Devin Ross on 7/4/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
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

#import "HUDViewController.h"


@implementation HUDViewController
@synthesize progressBar=_progressBar,alertView=_alertView,progressCircle=_progressCircle;
@synthesize progressBarAlternative=_progressBarAlternative;

- (id) init{
	if(!(self=[super init])) return nil;
	
	self.title = @"HUD";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Tap Me" style:UIBarButtonItemStyleBordered target:self action:@selector(tapme)] autorelease];

	return self;
}
- (void) dealloc {
	[_progressBar release];
	[_alertView release];
	[_progressCircle release];
	[_progressBarAlternative release];
	[super dealloc];
}


- (void) tapme{

	[self.progressCircle setTwirlMode:!self.progressCircle.isTwirling];
	
	if(!self.progressCircle.isTwirling){
		[self.progressCircle setProgress:0 animated:NO];
		[self.progressBar setProgress:0];
		[self.progressBarAlternative setProgress:0 animated:NO];

		
		[self performSelector:@selector(stepTwo) withObject:nil afterDelay:2];
		[self performSelector:@selector(stepThree) withObject:nil afterDelay:4];

		
		self.alertView.progressBar.progress = 0;
		[self.alertView show];


	}


}
- (void) stepTwo{
	
	[self.progressCircle setProgress:1 animated:YES];
	[self.progressBar setProgress:1 animated:YES];
	[self.progressBarAlternative setProgress:1 animated:YES];

	[self.alertView.progressBar setProgress:1 animated:YES];

}
- (void) stepThree{
	
	[self.alertView hide];
	
}


- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
	
	[self.view addSubview:self.progressBar];
	[self.view addSubview:self.progressCircle];
	[self.view addSubview:self.progressBarAlternative];
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];	
	[self stepTwo];
}






- (TKProgressBarView *) progressBar{
	if(_progressBar==nil){
		_progressBar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleShort];
		_progressBar.center = CGPointMake(self.view.bounds.size.width/2, 220);
	}

	return _progressBar;
}
- (TKProgressBarView *) progressBarAlternative{
	if(_progressBarAlternative==nil){
		_progressBarAlternative = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
		_progressBarAlternative.center = CGPointMake(self.view.bounds.size.width/2, 320);
	}
	
	return _progressBarAlternative;
}
- (TKProgressAlertView *) alertView{
	if(_alertView==nil){
		_alertView = [[TKProgressAlertView alloc] initWithProgressTitle:@"Loading important stuff!"];
	}
	return _alertView;
}
- (TKProgressCircleView *) progressCircle{
	if(_progressCircle==nil){
		_progressCircle = [[TKProgressCircleView alloc] init];
		_progressCircle.center = CGPointMake(self.view.bounds.size.width/2, 120);

	}
	return _progressCircle;
}


@end
