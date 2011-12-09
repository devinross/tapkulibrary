//
//  TKHTTPRequest.h
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

#import <Foundation/Foundation.h>



#if NS_BLOCKS_AVAILABLE
typedef void (^TKBasicBlock)(void);
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

@protocol TKHTTPRequestProgressDelegate <NSObject>
@optional
- (void) request:(TKHTTPRequest*)request didReceiveTotalBytes:(NSInteger)received ofExpectedBytes:(NSInteger)total;
@end


@interface TKHTTPRequest : NSOperation {


	NSInteger _totalExpectedImageSize,_receivedDataBytes;
	
	
	#if NS_BLOCKS_AVAILABLE
	TKBasicBlock startedBlock;
	TKBasicBlock completionBlock;
	TKBasicBlock failureBlock;
	#endif
	
	
}

+ (TKHTTPRequest*) requestWithURL:(NSURL*)URL;
- (id) initWithURL:(NSURL*)URL;

+ (TKHTTPRequest*) requestWithURLRequest:(NSURLRequest*)request;
- (id) initWithURLRequest:(NSURLRequest*)request;

@property (strong,nonatomic) NSURL *URL;
@property (strong,nonatomic) NSURLRequest *URLRequest;
@property (assign,nonatomic) NSUInteger tag;
@property (assign,nonatomic) BOOL showNetworkActivity; // for indiviual requests, default: TRUE

@property (unsafe_unretained,nonatomic) id <TKHTTPRequestProgressDelegate> progressDelegate;

@property (unsafe_unretained,nonatomic) id delegate;
@property (assign,nonatomic) SEL didStartSelector;
@property (assign,nonatomic) SEL didFinishSelector;
@property (assign,nonatomic) SEL didFailSelector;

@property (copy,nonatomic) NSString *downloadDestinationPath;
@property (copy,nonatomic) NSString *temporaryFileDownloadPath;


@property (copy,nonatomic) NSError *error;
@property (assign,nonatomic) NSInteger statusCode;
@property (strong,nonatomic) NSDictionary *responseHeaders;
@property (readonly,nonatomic) NSData *responseData;

- (void) startAsynchronous;


#if NS_BLOCKS_AVAILABLE
- (void) setStartedBlock:(TKBasicBlock)aStartedBlock;
- (void) setCompletionBlock:(TKBasicBlock)aCompletionBlock;
- (void) setFailedBlock:(TKBasicBlock)aFailedBlock;
#endif







#pragma mark network activity
+ (BOOL) isNetworkInUse;
+ (void) setShouldUpdateNetworkActivityIndicator:(BOOL)shouldUpdate;
+ (void) showNetworkActivityIndicator; // Shows the network activity spinner thing on iOS. You may wish to override this to do something else in Mac projects
+ (void) hideNetworkActivityIndicator; // Hides the network activity spinner thing on iOS




@end
