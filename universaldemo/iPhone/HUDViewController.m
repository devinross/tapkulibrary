//
//  HUDViewController.m
//  Created by Devin Ross on 7/4/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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


- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"HUD";
	self.view.backgroundColor = [UIColor grayColor];

	[self.view addSubview:self.loading];
	[self.view addSubview:self.progressbar];


	time = 0; 
	timer = [[NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(timer) userInfo:nil repeats:YES] retain];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	
	
	
	UIBarButtonItem *show = [[UIBarButtonItem alloc] initWithTitle:@"Tap Me" style:UIBarButtonItemStylePlain target:self action:@selector(tapme)];
	[self.navigationItem setRightBarButtonItem:show];
	[show release];
	
}

- (void) timer{
	
	if([self.progressbar  superview]){
		
		self.progressbar.progress = time / 100.0;
		
		time++;
		if(time > 130) time = -30;
		return;
	}
	
	time++;
	self.alertView.progressBar.progress = time / 200.0;
	if(time > 240){
		[self.view addSubview:self.progressbar];
		[self.view addSubview:self.loading];
		[self.alertView hide];
		time = 0;
	} 
	
	

	
}
- (void) tapme{
	[self.progressbar removeFromSuperview];

	[self.loading removeFromSuperview];
	[self.alertView show];
	time = 0;
}

- (TKLoadingView *) loading{
	if(loading==nil){
		loading  = [[TKLoadingView alloc] initWithTitle:@"Loading..."];
		[loading startAnimating];
		loading.center = CGPointMake(self.view.bounds.size.width/2, 160);
	}
	return loading;
}
- (TKProgressBarView *) progressbar{
	if(progressbar==nil){
		progressbar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleShort];
		progressbar.center = CGPointMake(self.view.bounds.size.width/2, 320);
		[progressbar setProgress:0.01];
	}

	return progressbar;
}

- (TKProgressAlertView *) alertView{
	if(alertView==nil){
		alertView = [[TKProgressAlertView alloc] initWithProgressTitle:@"Loading important stuff!"];
	}
	return alertView;
}



- (void)dealloc {
	[loading release];
	[progressbar release];
	[timer invalidate];
	[timer release];
	[super dealloc];
}


@end
