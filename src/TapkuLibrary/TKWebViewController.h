//
//  TKWebViewController.h
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


@import UIKit;


/** This class creates a `UIViewController` with a basic `UIWebView` as the focal point view. */
@interface TKWebViewController : UIViewController <UIWebViewDelegate>


/** Initializes a web vew controller that will load the given `NSURL` object.
 @param URL A `NSURL` object that will loaded by the `UIWebView`.
 @return An initialized `TKWebViewController` object or nil if the object couldn’t be created.
 */
- (id) initWithURL:(NSURL*)URL;

/** Initializes a web vew controller that will load the given `URLRequest` object.
 @param URLRequest A `URLRequest` object that will loaded by the `UIWebView`.
 @return An initialized `TKWebViewController` object or nil if the object couldn’t be created.
 */
- (id) initWithURLRequest:(NSURLRequest*)URLRequest;

///----------------------------
/// @name Properties
///----------------------------
/** The URL that will be loaded by the web view. */
@property (nonatomic,strong) NSURL *URL;

/** The URLRequest that will be loaded by the web view. */
@property (nonatomic,strong) NSURLRequest *URLRequest;

/** Returns the `UIWebView`	managed by the controller object. */
@property (nonatomic,strong) UIWebView *webView;


/** Show a `UIActivityViewController` to share the URL of the web view 
 @param sender The sender of the action.
 */
- (void) showActionSheet:(id)sender;

@end
