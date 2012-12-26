//
//  NetworkRequestViewController.m
//  Created by Devin Ross on 9/24/11.
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

#import "NetworkRequestViewController.h"

@implementation NetworkRequestViewController

- (id) init{
	if(!(self=[super init])) return nil;
	return self;
}

- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

	CGRect r = CGRectInset(self.view.bounds, 10, 10);
	r.size.height -= 80;
	self.textView = [[UITextView alloc] initWithFrame:r];
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.textView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
	self.textView.editable = NO;
	[self.view addSubview:self.textView];
	
	CGFloat y = r.size.height + r.origin.y;
	CGFloat h = self.view.bounds.size.height - y;
	
	self.circle = [[TKProgressCircleView alloc] init];
	self.circle.center = CGPointMake(self.view.bounds.size.width/2, y + h / 2 );
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
	
	__weak TKHTTPRequest *req = [TKHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.dribbble.com/shots/everyone?per_page=30"]];
	req.delegate = self;
	req.didFinishSelector = @selector(networkRequestDidFinish:);
	req.progressDelegate = self;
	
	[req setStartedBlock:^{ NSLog(@"Started... %@",req); }];
	[req setFailedBlock:^{ NSLog(@"Failed... %@ %@",req,req.error); }];
	[req startAsynchronous];
	
}

- (void) request:(TKHTTPRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total{
	[self.circle setProgress:received/total animated:YES];
}
- (void) networkRequestDidFinish:(TKHTTPRequest*)request{
	
	NSLog(@"Finished... %@",request);
	NSData *data = [request responseData];
	
	if(data)
		[self processJSONDataInBackground:data 
					 withCallbackSelector:@selector(processedData:) 
					   backgroundSelector:@selector(putJsonIntoObjects:) 
							errorSelector:@selector(parseError:) 
						   readingOptions:0];
	
	
	
}

- (void) parseError:(NSError*)error{	
	NSLog(@"ERROR: %@",error);
}
- (void) processedData:(NSDictionary*)dict{
	
	if(self.textView.text==nil || self.textView.text.length < 1)
		[self.textView setText:[dict description]];
	
}
- (id) putJsonIntoObjects:(NSDictionary*)dictionary{
	return dictionary;	// we'll just pass back the json dictionary for now
}

@end
