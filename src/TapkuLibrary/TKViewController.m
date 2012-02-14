//
//  TKViewController.m
//  Created by Devin Ross on 11/1/11.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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

#import "TKViewController.h"
#import "TKHTTPRequest.h"
#import "NSArray+TKCategory.h"

@implementation TKViewController
@synthesize loadingView = _loadingView;

- (void) viewDidUnload{
	self.loadingView = nil;
	[super viewDidUnload];
}
- (void) dealloc{
	[self cancelActiveRequests];
}

#pragma mark - EASILY MANAGE ACTIVE REQUESTS
- (void) addActiveRequest:(TKHTTPRequest*)request{
	
	if(_activeRequests==nil){
		_activeRequests = [[NSMutableArray alloc] init];
	}
	[_activeRequests addObject:request];
	
}
- (void) removeActiveRequest:(TKHTTPRequest*)request{
	
	if([_activeRequests containsObject:request])
		[_activeRequests removeObject:request];
}
- (void) cancelActiveRequests{
	if(_activeRequests){
		for(TKHTTPRequest *request in _activeRequests)
			[request cancel];
	}
}

- (NSInteger) activeRequestCount{
	return _activeRequests.count;
}


#pragma mark - PROPERTIES
- (UIView*) loadingView{
	if(_loadingView==nil){
		_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
		_loadingView.backgroundColor = [UIColor clearColor];
		_loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		act.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
		act.center = _loadingView.center;
		[act startAnimating];
		[_loadingView addSubview:act];
	}
	return _loadingView;
}


@end
