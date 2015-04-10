//
//  TKWebViewController.m
//  Created by Devin Ross on 5/24/13.
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


#import "TKWebViewController.h"
#import "UIBarButtonItem+TKCategory.h"
#import "UIDevice+TKCategory.h"

@interface TKWebViewController ()
@property (nonatomic,strong) UIBarButtonItem *loadingActivityBarButtonItem;
@end

@implementation TKWebViewController

- (instancetype) initWithURL:(NSURL*)URL{
	if(!(self=[super init])) return nil;
	self.URL = URL;
	return self;
}
- (instancetype) initWithURLRequest:(NSURLRequest*)URLRequest{
	if(!(self=[super init])) return nil;
	self.URLRequest = URLRequest;
	return self;
}

#pragma mark View Lifecycle
- (void) loadView{
	[super loadView];
	self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	self.webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.webView];
}
- (void) viewDidLoad{
	[super viewDidLoad];
	if(self.URL)
		[self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
	else if(self.URLRequest)
		[self.webView loadRequest:self.URLRequest];
}

#pragma mark Button Actions
- (void) showActionSheet:(UIBarButtonItem*)sender{
	NSURL *currentURL = self.webView.request.URL;
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[currentURL] applicationActivities:nil];
	activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact];
	
	
	if([UIDevice padIdiom]){
		
		UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
		[popup presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		
	}else{
		
		[self presentViewController:activityVC animated:YES completion:nil];

	}
	
}

#pragma mark UIWebviewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView{
	if(self.navigationItem.rightBarButtonItem == _actionBarButtonItem)
		self.navigationItem.rightBarButtonItem = self.loadingActivityBarButtonItem;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
	if(self.navigationItem.rightBarButtonItem == _loadingActivityBarButtonItem)
		self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if(self.navigationItem.rightBarButtonItem == _loadingActivityBarButtonItem)
		self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	if(self.navigationController && (navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeLinkClicked)){
		TKWebViewController *vc = [[[self class] alloc] initWithURLRequest:request];
		[self.navigationController pushViewController:vc animated:YES];
		return NO;
	}
	
	return YES;
}


- (void) dismiss:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Properties
- (UIBarButtonItem*) actionBarButtonItem{
	if(_actionBarButtonItem) return _actionBarButtonItem;
	_actionBarButtonItem =  [UIBarButtonItem actionItemWithTarget:self action:@selector(showActionSheet:)];
	return _actionBarButtonItem;
}
- (UIBarButtonItem*) loadingActivityBarButtonItem{
	if(_loadingActivityBarButtonItem) return _loadingActivityBarButtonItem;
	
	UIActivityIndicatorViewStyle style;
	if(self.navigationController.navigationBar.barTintColor){
		UIColor *clr = self.navigationController.navigationBar.barTintColor;
		const CGFloat *componentColors = CGColorGetComponents(clr.CGColor);
		CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
		style = colorBrightness < 0.6 ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray ;
	}else{
		style = UIActivityIndicatorViewStyleGray;
	}
	
	_loadingActivityBarButtonItem = [UIBarButtonItem activityItemWithIndicatorStyle:style];
	return _loadingActivityBarButtonItem;
}

@end