//
//  TKHTTPRequest.h
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

@import Foundation;
#import "NSObject+TKCategory.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^TKBasicBlock)(void);
typedef void (^TKResponseBlock)(NSData *data, NSInteger statusCode, NSError *error);
typedef void (^TKJSONResponseBlock)(id object, NSInteger statusCode, NSError *error);
#endif


typedef enum _TKNetworkErrorType {
    TKConnectionFailureErrorType = 1,
    TKRequestTimedOutErrorType = 2,
    TKAuthenticationErrorType = 3,
    TKRequestCancelledErrorType = 4,
    TKUnableToCreateRequestErrorType = 5,
    TKInternalErrorWhileBuildingRequestType  = 6,
    TKInternalErrorWhileApplyingCredentialsType  = 7,
	TKFileManagementError = 8,
	TKTooMuchRedirectionErrorType = 9,
	TKUnhandledExceptionError = 10,
} TKNetworkErrorType;


@class TKHTTPRequest;

/** The progress delegate can adopt the `TKHTTPRequestProgressDelegate` protocol. The progress delegate is not retained. */
@protocol TKHTTPRequestProgressDelegate <NSObject>
@optional
/** The progress of received bytes for the response of the `TKHTTPRequest`.
 @param request The URL request.
 @param received The total bytes received from the request.
 @param total The total expected btyes that will be received from the request.
 */
- (void) request:(TKHTTPRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total;
@end


/** An `TKHTTPRequest` object provides support to perform the loading of a URL request. */
@interface TKHTTPRequest : NSOperation

///-------------------------
/// @name Create a request object
///-------------------------
 
/** Returns a newly created request with a URL. 
 @param URL The URL for the new request.
 @return The newly created request object.
 */
+ (instancetype) requestWithURL:(NSURL*)URL;

/** Returns a newly created request with a URL and response handler. Immediately starts async request.
 @param URL The URL for the new request.
 @param responseHandler The response handler for the request.
 @return The newly created request object.
 */
+ (instancetype) requestWithURL:(NSURL *)URL responseHandler:(TKResponseBlock)responseHandler;

/** Returns a newly created request with a URL.
 @param URL The URL for the new request.
 @param responseHandler The JSON response handler for the request.
 @return The newly created request object.
 */
+ (instancetype) requestWithURL:(NSURL *)URL JSONResponseHandler:(TKJSONResponseBlock)responseHandler;

/** Returns a newly initialized request with a URL. 
 @param URL The URL for the new request.
 @return The newly created request object.
 */
- (instancetype) initWithURL:(NSURL*)URL;

/** Returns a newly created request with a `NSURLRequest` object. 
 @param request The `NSURLRequest` for the new request.
 @return The newly created request object.
 */
+ (instancetype) requestWithURLRequest:(NSURLRequest*)request;

/** Returns a newly initialized request with a `NSURLRequest` object. 
 @param request The `NSURLRequest` for the new request.
 @return The newly created request object.
 */
- (instancetype) initWithURLRequest:(NSURLRequest*)request;

///-------------------------
/// @name Properties
///-------------------------
/** The request's URL. */
@property (nonatomic,strong) NSURL *URL;

/** The request's URL Request object. */
@property (nonatomic,strong) NSURLRequest *URLRequest;

/** An integer that you can use to identify request objects in your application. */
@property (nonatomic,assign) NSUInteger tag;

/** The request will show the network indicator in the status bar when set to YES. Default is YES. */
@property (nonatomic,assign) BOOL showNetworkActivity; 

/** The progress delegate must adopt the `TKHTTPRequestProgressDelegate` protocol. The data source is not retained. */
@property (nonatomic,assign) id <TKHTTPRequestProgressDelegate> progressDelegate;


///-------------------------
/// @name Callback Delegate
///-------------------------
/** The delegate to receive start, finish and fail callback selectors. */
@property (nonatomic,assign) id delegate;

/** The selector called upon the start of the request. */
@property (nonatomic,assign) SEL didStartSelector;

/** The selector called upon the finishing of the request. */
@property (nonatomic,assign) SEL didFinishSelector;

/** The selector called upon the failure of the request. */
@property (nonatomic,assign) SEL didFailSelector;


///-------------------------
/// @name File Download Path
///-------------------------
/** The final destination for the response data file. Default is nil. */
@property (nonatomic,copy) NSString *downloadDestinationPath;
/** The destination for the response data to be written to during the request connection. Default is nil. */
@property (nonatomic,copy) NSString *temporaryFileDownloadPath;


///-------------------------
/// @name Response Properties
///-------------------------

/** The error object if the requests ends in failure. */
@property (nonatomic,copy) NSError *error;

/** The status code of the request. */
@property (nonatomic,assign) NSInteger statusCode;

/** The response headers of the request. */
@property (nonatomic,strong) NSDictionary *responseHeaders;

/** The response data of the request. */
@property (readonly,nonatomic) NSData *responseData;




///-------------------------
/// @name Callback Blocks
///-------------------------
#if NS_BLOCKS_AVAILABLE

/** The block called upon the start of the request. */
@property (nonatomic,copy) TKBasicBlock startedBlock;

/** The block called up the finishing of the request. */
@property (nonatomic,copy) TKBasicBlock finishedBlock;

/** The block called up the finishing of the request and processing of the JSON response data. */
@property (nonatomic,copy) TKJSONCompletionBlock JSONFinishedBlock;

/** The block called up the failure of the request. */
@property (nonatomic,copy) TKBasicBlock failedBlock;


/** The block called up the completion or failure of the request. */
@property (nonatomic,copy) TKResponseBlock responseBlock;

/** The block called up the completion or failure of the request. */
@property (nonatomic,copy) TKJSONResponseBlock JSONResponseBlock;
#endif


///-------------------------
/// @name Start request
///-------------------------
/** Causes the request to begin loading data, if it has not already. */
- (void) startAsynchronous;



///-------------------------
/// @name Network indicator
///-------------------------

#pragma mark network activity
/** Returns YES if there are any active requests, otherwise NO. 
 @return YES if there are any active requests, otherwise NO.
*/
+ (BOOL) isNetworkInUse;

/** Sets the rule that future requests will change the Network Indicator in the status bar
 @param shouldUpdate YES if the network indicator should change upon new requests, otherwise NO.
 */
+ (void) setShouldUpdateNetworkActivityIndicator:(BOOL)shouldUpdate;



@end
