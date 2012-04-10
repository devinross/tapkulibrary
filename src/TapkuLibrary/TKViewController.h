//
//  TKViewController.h
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

#import <UIKit/UIKit.h>

@class TKHTTPRequest;

/** This class provides basic lazy loading views and easy network request management for a `UIViewController`. */
@interface TKViewController : UIViewController {
	NSMutableArray *_activeRequests;
	UIView *_loadingView;
}


///----------------------------
/// @name Properties
///----------------------------

/** Returns a loading view with an `UIActivityIndicatorView` center on the view */
@property (strong,nonatomic) UIView *loadingView;


///----------------------------
/// @name Network Request Management
///----------------------------
/** Associate active network requests with a specific view controller for easy management.
 @param request The network request which you want to have the view controller manage.
*/
- (void) addActiveRequest:(TKHTTPRequest*)request;

/** Returns the current number of request managed by the view controller.
 @see addActiveRequest:
*/
- (NSInteger) activeRequestCount;

/** Remove an active request.
 @param request The request that will be removed.
 @see addActiveRequest:
*/
- (void) removeActiveRequest:(TKHTTPRequest*)request;

/** Cancel all active network requests managed by the view controller.
 @see addActiveRequest:
*/
- (void) cancelActiveRequests;



@end