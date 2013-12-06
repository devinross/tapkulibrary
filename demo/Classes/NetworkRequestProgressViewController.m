//
//  NetworkRequestViewController.m
//  Created by Devin Ross on 9/24/11.
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

#import "NetworkRequestProgressViewController.h"

@implementation NetworkRequestProgressViewController

- (id) init{
	if(!(self=[super init])) return nil;
	return self;
}

- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];


	
	CGFloat y = self.view.bounds.size.height/2.0;
	CGFloat x = self.view.bounds.size.width/2.0;
	
	self.circle = [[TKProgressCircleView alloc] init];
	self.circle.center = CGPointMake(x,y);
	self.circle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self.circle roundOffFrame];
	[self.view addSubview:self.circle];
	
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(start)];

	
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
		self.navigationItem.rightBarButtonItem = item;
	}else{
		self.toolbarItems = @[item];
	}

}

- (void) start{
	
	__weak TKHTTPRequest *req = [TKHTTPRequest requestWithURL:[NSURL URLWithString:@"http://devinsheaven.com/tapkulibrary.zip"]];
	
	req.delegate = self;
	req.didFinishSelector = @selector(networkRequestDidFinish:);
	req.progressDelegate = self;

	
	[req setStartedBlock:^{ NSLog(@"Started... %@",req); }];
	[req setFailedBlock:^{ NSLog(@"Failed... %@ %@",req,req.error); }];
	[req startAsynchronous];
	
}

- (void) request:(TKHTTPRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total{
	
	CGFloat percentage = (CGFloat)received / (CGFloat)total;
	NSLog(@"Received... %@ of %@ (%@%%)",@(received),@(total),@(percentage*100));
	[self.circle setProgress:percentage animated:YES];
}
- (void) networkRequestDidFinish:(TKHTTPRequest*)request{
	NSData *data = [request responseData];

	NSLog(@"Finished... %@ (length %lu)",request,(unsigned long)data.length);

}



@end
