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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(start)] autorelease];
	return self;
}
- (void) dealloc {
	[_circle release];
    [super dealloc];
}

- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];

	CGRect r = CGRectInset(self.view.bounds, 6, 6);
	r.size.height -= 80;
	_textView = [[UITextView alloc] initWithFrame:r];
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
	_textView.editable = NO;
	[self.view addSubview:_textView];
	
	
	_circle = [[TKProgressCircleView alloc] init];
	_circle.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/5*4);
	[_circle roundOffFrame];
	[self.view addSubview:_circle];

}

- (void) start{
	
	TKHTTPRequest *req = [TKHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.dribbble.com/shots/everyone?per_page=30"]];
	req.delegate = self;
	req.didFinishSelector = @selector(networkRequestDidFinish:);
	req.progressDelegate = self;
	
	
	
	[req setStartedBlock:^{ NSLog(@"Started... %@",req); }];
	[req setFailedBlock:^{ NSLog(@"Failed... %@ %@",req,req.error); }];
	
	[req startAsynchronous];
	
}

- (void) request:(TKHTTPRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total{
	[_circle setProgress:received/total animated:YES];
}
- (void) networkRequestDidFinish:(TKHTTPRequest*)request{
	
	NSLog(@"Finished... %@",request);
	NSData *data = [request responseData];
	
	if(data)
		[self processJSONDataInBackground:data 
					 withCallbackSelector:@selector(processedData:) 
					   backgroundSelector:@selector(putJsonIntoObjects:) 
							errorSelector:@selector(parseError:) 
						   readingOptions:NSJSONReadingMutableContainers];
	
	
	
}

- (void) parseError:(NSError*)error{	
	NSLog(@"ERROR: %@",error);
}
- (void) processedData:(NSDictionary*)dict{
	
	
	if(_textView.text==nil || _textView.text.length < 1)
		[_textView setText:[dict description]];
	
}
- (id) putJsonIntoObjects:(NSDictionary*)dictionary{
	return dictionary;	// we'll just pass back the json dictionary for now
}

@end
