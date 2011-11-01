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


typedef enum TKOperationState {
    TKOperationStateInited, 
    TKOperationStateExecuting, 
    TKOperationStateFinished
} TKOperationState;



@class TKHTTPRequest;

@protocol TKHTTPRequestProgressDelegate <NSObject>
@optional
- (void) request:(TKHTTPRequest*)request didProgressToPercentage:(double)percentage;
@end


@interface TKHTTPRequest : NSOperation {

	NSURL *_URL;
	NSURLConnection *_connection;
	NSMutableData *_data;
	
	
	NSError *_error;
	TKOperationState _state;
	
	BOOL _showNetworkActivity;
	

	
	double _totalExpectedImageSize,_receivedDataBytes;
	
	
	// Used for writing data to a file when downloadDestinationPath is set
	NSFileHandle *_fileHandler;
	NSString *_downloadDestinationPath;
	NSString *_temporaryFileDownloadPath;

	
	SEL didStartSelector;
	SEL didFinishSelector;
	SEL didFailSelector;
	
	
	
	#if NS_BLOCKS_AVAILABLE
	TKBasicBlock startedBlock;
	TKBasicBlock completionBlock;
	TKBasicBlock failureBlock;
	#endif
	
	id __unsafe_unretained delegate;
	id <TKHTTPRequestProgressDelegate> __unsafe_unretained progressDelegate;
	NSInteger _statusCode;
	NSDictionary *__unsafe_unretained _responseHeaders;
	
	NSUInteger _tag;
	
}

+ (TKHTTPRequest*) requestWithURL:(NSURL*)URL;
- (id) initWithURL:(NSURL*)URL;

@property (assign) BOOL showNetworkActivity; // for indiviual requests, default: TRUE
@property (assign,nonatomic) NSUInteger tag;
@property (strong,setter=setURL:) NSURL *URL;

@property (unsafe_unretained) id <TKHTTPRequestProgressDelegate> progressDelegate;

@property (unsafe_unretained,nonatomic) id delegate;
@property (assign) SEL didStartSelector;
@property (assign) SEL didFinishSelector;
@property (assign) SEL didFailSelector;

@property (strong,nonatomic) NSString *downloadDestinationPath;


@property (copy,readonly) NSError *error;
@property (readonly) NSInteger statusCode;
@property (readonly) NSDictionary *responseHeaders;
@property (strong,readonly) NSData *responseData;

- (void) startAsynchronous;


#if NS_BLOCKS_AVAILABLE
- (void) setStartedBlock:(TKBasicBlock)aStartedBlock;
- (void) setCompletionBlock:(TKBasicBlock)aCompletionBlock;
- (void) setFailedBlock:(TKBasicBlock)aFailedBlock;
#endif







#pragma mark network activity
+ (BOOL) isNetworkInUse;
+ (void) setShouldUpdateNetworkActivityIndicator:(BOOL)shouldUpdate;
// Shows the network activity spinner thing on iOS. You may wish to override this to do something else in Mac projects
+ (void) showNetworkActivityIndicator;
// Hides the network activity spinner thing on iOS
+ (void) hideNetworkActivityIndicator;



@end
