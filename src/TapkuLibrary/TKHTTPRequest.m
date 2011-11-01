//
//  TKHTTPRequest.m
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

#import "TKHTTPRequest.h"
#import "TKNetworkQueue.h"



static NSThread *networkThread = nil;
static BOOL shouldUpdateNetworkActivityIndicator = YES;
static unsigned int runningRequestCount = 0;
NSString* const TKNetworkRequestErrorDomain = @"TKHTTPRequestErrorDomain";


@interface TKHTTPRequest ()
- (void) releaseBlocksOnMainThread;
+ (void) releaseBlocks:(NSArray *)blocks;
- (void) _requestComplete;
- (void) _requestFinished;
+ (NSThread *) threadForRequest:(TKHTTPRequest *)request;


@property (assign, readwrite) TKOperationState state;

@property (copy, readwrite) NSError *error;

@end

@interface TKHTTPRequest (private)
+ (BOOL) removeFileAtPath:(NSString *)path error:(NSError **)err;
@end


@implementation TKHTTPRequest (private)
- (BOOL) removeTemporaryFile{
	NSError *err = nil;
	if (_temporaryFileDownloadPath) {
		if (![[self class] removeFileAtPath:_temporaryFileDownloadPath error:&err]) {
			//[self failWithError:err];
		}
	}
	return (!err);
}
- (BOOL) removeDesitinationFile{
	NSError *err = nil;
	if (_downloadDestinationPath) {
		if (![[self class] removeFileAtPath:_downloadDestinationPath error:&err]) {
			//[self failWithError:err];
		}
	}
	return (!err);
}
+ (BOOL) removeFileAtPath:(NSString *)path error:(NSError **)err{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if ([fileManager fileExistsAtPath:path]) {
		NSError *removeError = nil;
		[fileManager removeItemAtPath:path error:&removeError];
		if (removeError) {
			if (err) {
				*err = [NSError errorWithDomain:TKNetworkRequestErrorDomain code:TKFileManagementError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Failed to delete file at path '%@'",path],NSLocalizedDescriptionKey,removeError,NSUnderlyingErrorKey,nil]];
			}
			return NO;
		}
	}
	return YES;
}
@end



@implementation TKHTTPRequest
@synthesize didStartSelector, didFinishSelector, didFailSelector,delegate,progressDelegate;
@synthesize state = _state, error=_error;

@synthesize showNetworkActivity=_showNetworkActivity;
@synthesize downloadDestinationPath=_downloadDestinationPath;
@synthesize statusCode=_statusCode,responseHeaders=_responseHeaders;
@synthesize URL=_URL,tag=_tag;

#pragma mark -

+ (TKHTTPRequest*) requestWithURL:(NSURL*)URL{
	return [[self alloc] initWithURL:URL];
}
- (id) initWithURL:(NSURL*)URL{
	if(!(self=[super init])) return nil;
	
	_URL = URL;
	_showNetworkActivity = YES;
	
	return self;
}
- (void) dealloc{
	
	if(_connection){
		[_connection cancel];
	}	
	
	
	
#if NS_BLOCKS_AVAILABLE
	[self releaseBlocksOnMainThread];
#endif
	
}



#pragma mark -
- (void) start{
	[self performSelector:@selector(_startOnNetworkThread) onThread:[[self class] threadForRequest:self] withObject:nil waitUntilDone:NO];
}
- (void) _startOnNetworkThread{
	
	if( [self isFinished] || [self isCancelled] ) { 
		[self _requestComplete]; 
		return; 
	}
	
	self.state = TKOperationStateExecuting;
	
	
	_connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_URL] delegate:self];
	[_connection start];
	
	_receivedDataBytes = 0;
	_totalExpectedImageSize = 0;
	
	
	if(_showNetworkActivity){
		runningRequestCount++;
		[[self class] showNetworkActivityIndicator];
	}
	
	[self performSelectorOnMainThread:@selector(_requestStarted) withObject:nil waitUntilDone:[NSThread isMainThread]];
}
- (void) _requestStarted{
	if(delegate && [delegate respondsToSelector:didStartSelector]) [delegate performSelector:didStartSelector withObject:self];
	
#if NS_BLOCKS_AVAILABLE
	if(startedBlock) startedBlock();
#endif
}

- (void) failWithError:(NSError *)theError{
	
	self.state = TKOperationStateFinished;
	self.error = theError;
	
}

- (void) cancel{
	[self performSelector:@selector(_cancelOnRequestThread) onThread:[[self class] threadForRequest:self] withObject:nil waitUntilDone:NO];    
}
- (void) _cancelOnRequestThread{
	
	
	
	self.state = TKOperationStateFinished;
	
	if(_connection){
		[_connection cancel];
		_connection=nil;
		
		
		if(_showNetworkActivity){
			runningRequestCount--;
			if (shouldUpdateNetworkActivityIndicator && runningRequestCount == 0) 
				[[self class] performSelectorOnMainThread:@selector(hideNetworkActivityIndicatorAfterDelay) withObject:nil waitUntilDone:[NSThread isMainThread]];
			
		}
		
	}
}

- (void) _requestProgressedTo:(NSNumber*)percentage{
	
	if([self.progressDelegate respondsToSelector:@selector(request:didProgressToPercentage:)])
		[self.progressDelegate request:self didProgressToPercentage:[percentage doubleValue]];
}
- (void) _requestComplete{

	
	if(_connection){
		[_connection cancel];
		_connection = nil;
	}
	
	
	self.state = TKOperationStateFinished;
	

	if(_showNetworkActivity){
		runningRequestCount--;
		if (shouldUpdateNetworkActivityIndicator && runningRequestCount == 0) 
			[[self class] performSelectorOnMainThread:@selector(hideNetworkActivityIndicatorAfterDelay) withObject:nil waitUntilDone:[NSThread isMainThread]];
	}
	

	
	if(!_error && _temporaryFileDownloadPath){
		
		
		NSError *moveError = nil;

		[_fileHandler closeFile];
		
		
		if (![[self class] removeFileAtPath:_downloadDestinationPath error:&moveError]) 
			_error = moveError;

		if (!moveError) {
			
			[[NSFileManager defaultManager] moveItemAtPath:_temporaryFileDownloadPath toPath:_downloadDestinationPath error:&moveError];
			
			if (moveError){
				
				NSDictionary *str = [NSString stringWithFormat:@"Failed to move file from '%@' to '%@'",_temporaryFileDownloadPath,_downloadDestinationPath];
				
				_error = [NSError errorWithDomain:TKNetworkRequestErrorDomain 
											 code:TKFileManagementError 
										 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:str,NSLocalizedDescriptionKey,moveError,NSUnderlyingErrorKey,nil]];

			}
				
				
				

		}
		
	}
	
	
	[self performSelectorOnMainThread:@selector(_requestFinished) withObject:nil waitUntilDone:[NSThread isMainThread]];


	
}
- (void) _requestFinished{

	if(self.delegate && [self.delegate respondsToSelector:didFinishSelector]) [self.delegate performSelector:didFinishSelector withObject:self];

#if NS_BLOCKS_AVAILABLE
	if(completionBlock) completionBlock();
#endif
	
}
- (void) _requestFailed{
	if(self.delegate && [self.delegate respondsToSelector:didFailSelector]) [self.delegate performSelector:didFailSelector withObject:self];
#if NS_BLOCKS_AVAILABLE
	if(failureBlock) failureBlock();
#endif
}


- (void) startAsynchronous{
	[[TKNetworkQueue sharedNetworkQueue] addOperation:self];
}


#pragma mark -
#pragma mark Delegate Methods for NSURLConnection
- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)e{
	
	
	
	if(_connection){
		[_connection cancel];
		_connection = nil;
	}
	
	if(_showNetworkActivity){
		runningRequestCount--;
		if (shouldUpdateNetworkActivityIndicator && runningRequestCount == 0) 
			[[self class] performSelectorOnMainThread:@selector(hideNetworkActivityIndicatorAfterDelay) withObject:nil waitUntilDone:[NSThread isMainThread]];
	}
	
	if(_temporaryFileDownloadPath) [self removeTemporaryFile];

	_data=nil;
	[self failWithError:e];
	
	[self performSelectorOnMainThread:@selector(_requestFailed) withObject:nil waitUntilDone:[NSThread isMainThread]];

	
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)d{
	
	
	_receivedDataBytes += (double) [d length];

	
	if(_downloadDestinationPath){
		
		
		if(!_fileHandler){
			
			if(!_temporaryFileDownloadPath){
				NSString *tmp = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
				_temporaryFileDownloadPath = [tmp copy];
			}
			
			
			[self removeTemporaryFile];
			[[NSFileManager defaultManager] createFileAtPath:_temporaryFileDownloadPath contents:nil attributes:nil];
			_fileHandler = [NSFileHandle fileHandleForWritingAtPath:_temporaryFileDownloadPath];
			
			if(_fileHandler==nil) {
				
				NSDictionary *str = [NSString stringWithFormat:@"Failed to create file from '%@'",_temporaryFileDownloadPath];
				
				_error = [NSError errorWithDomain:TKNetworkRequestErrorDomain 
											  code:TKFileManagementError 
										  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:str,NSLocalizedDescriptionKey,nil]];
				
				
				[self _requestComplete];
				
				
			}
				
		}
		
		
		[_fileHandler writeData:d];

		
	}else{
		[_data appendData:d];
	}
	
	
	
	if(self.progressDelegate)
		[self performSelectorOnMainThread:@selector(_requestProgressedTo:) withObject:[NSNumber numberWithDouble:_receivedDataBytes/_totalExpectedImageSize] waitUntilDone:[NSThread isMainThread]];

	
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	_statusCode = [httpResponse statusCode];
	_responseHeaders = [httpResponse allHeaderFields];
	
	

	
	if( _statusCode == 200 ) {
		_totalExpectedImageSize = (double)response.expectedContentLength;
		NSUInteger contentSize = [httpResponse expectedContentLength] > 0 ? [httpResponse expectedContentLength] : 0;
		_data = [[NSMutableData alloc] initWithCapacity:contentSize];
	} else {
		NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), _statusCode];
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
		_error = [[NSError alloc] initWithDomain:TKNetworkRequestErrorDomain code:_statusCode userInfo:userInfo];
		[self _requestComplete];
	}
	
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[self _requestComplete];
}





#pragma mark -
#pragma mark Blocks
#if NS_BLOCKS_AVAILABLE
- (void) setStartedBlock:(TKBasicBlock)aStartedBlock{
	startedBlock = [aStartedBlock copy];
}
- (void) setCompletionBlock:(TKBasicBlock)aCompletionBlock{
	completionBlock = [aCompletionBlock copy];
}
- (void) setFailedBlock:(TKBasicBlock)aFailedBlock{
	failureBlock = [aFailedBlock copy];
}
- (void) releaseBlocksOnMainThread{
	NSMutableArray *blocks = [NSMutableArray array];
	if (completionBlock) {
		[blocks addObject:completionBlock];
		completionBlock = nil;
	}
	if (failureBlock) {
		[blocks addObject:failureBlock];
		failureBlock = nil;
	}
	if (startedBlock) {
		[blocks addObject:startedBlock];
		startedBlock = nil;
	}
	
	[[self class] performSelectorOnMainThread:@selector(releaseBlocks:) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}
+ (void) releaseBlocks:(NSArray *)blocks{
	// Always called on main thread
	
	// Blocks will be released when this method exits
}
#endif



#pragma mark -
#pragma mark Properties
- (BOOL) isConcurrent{
	return YES;
}
- (BOOL) isExecuting{
	return self.state == TKOperationStateExecuting;
}
- (BOOL) isFinished{
	return self.state == TKOperationStateFinished;
}
- (NSData *) responseData{	
	return _data;
}




#pragma mark -
#pragma mark Network Activity
+ (BOOL) isNetworkInUse{
	return runningRequestCount > 0;
}
+ (void) setShouldUpdateNetworkActivityIndicator:(BOOL)shouldUpdate{
	shouldUpdateNetworkActivityIndicator = shouldUpdate;
}
+ (void) showNetworkActivityIndicator{
#if TARGET_OS_IPHONE
	if (shouldUpdateNetworkActivityIndicator) 
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}
+ (void) hideNetworkActivityIndicator{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
#endif
}
+ (void) hideNetworkActivityIndicatorAfterDelay{
	[self performSelector:@selector(hideNetworkActivityIndicatorIfNeeeded) withObject:nil afterDelay:0.5];
}
+ (void) hideNetworkActivityIndicatorIfNeeeded{
	if (runningRequestCount == 0) {
		[self hideNetworkActivityIndicator];
	}
}

#pragma mark -
#pragma mark Threading
+ (NSThread *) threadForRequest:(TKHTTPRequest *)request{
	if (!networkThread) {
		networkThread = [[NSThread alloc] initWithTarget:self selector:@selector(runRequests) object:nil];
		[networkThread start];
	}
	return networkThread;
}
+ (void) runRequests{
	// Should keep the runloop from exiting
	CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
	CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	
    BOOL runAlways = YES; // Introduced to cheat Static Analyzer
	while (runAlways) {
		@autoreleasepool {
			CFRunLoopRun();
		}
	}
	
	// Should never be called, but anyway
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);
}

@end
