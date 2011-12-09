//
//  UIViewController+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+TKCategory.h"

@implementation UIViewController (TKCategory)


#pragma mark - PROCESS JSON IN THE BACKGROUND

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback{
	
	[self processJSONDataInBackground:data 
				 withCallbackSelector:callback 
				   backgroundSelector:nil 
						errorSelector:nil 
					   readingOptions:0];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback readingOptions:(NSJSONReadingOptions)options{
	
	[self processJSONDataInBackground:data 
				 withCallbackSelector:callback 
				   backgroundSelector:nil 
						errorSelector:nil 
					   readingOptions:options];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor readingOptions:(NSJSONReadingOptions)options{
	
	[self processJSONDataInBackground:data 
				 withCallbackSelector:callback 
				   backgroundSelector:backgroundProcessor 
						errorSelector:nil 
					   readingOptions:options];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector{
	
	[self processJSONDataInBackground:data 
				 withCallbackSelector:callback 
				   backgroundSelector:backgroundProcessor 
						errorSelector:errroSelector 
					   readingOptions:0];
	
}


- (void) processJSONDataInBackground:(NSData *)data 
				withCallbackSelector:(SEL)callback 
				  backgroundSelector:(SEL)backgroundProcessor 
					   errorSelector:(SEL)errroSelector 
					  readingOptions:(NSJSONReadingOptions)options{
	
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:data forKey:@"data"];
	[dict setObject:[NSNumber numberWithUnsignedInt:options] forKey:@"flags"];
	
	if(callback) [dict setObject:NSStringFromSelector(callback) forKey:@"callback"];
	if(backgroundProcessor) [dict setObject:NSStringFromSelector(backgroundProcessor) forKey:@"backgroundProcessor"];
	if(errroSelector) [dict setObject:NSStringFromSelector(errroSelector) forKey:@"errroSelector"];
	
	
	[self performSelectorInBackground:@selector(_processJSONData:) withObject:dict];
	
	
}


- (void) _processJSONData:(NSDictionary*)dict{
	@autoreleasepool {
		NSError *error = nil;
		
		NSData *data = [dict objectForKey:@"data"];
		NSUInteger options = [[dict objectForKey:@"flags"] unsignedIntValue];
		
		NSString *callback = [dict objectForKey:@"callback"];
		NSString *background = [dict objectForKey:@"backgroundProcessor"];
		NSString *eSelector = [dict objectForKey:@"errroSelector"];
		
		id object = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
		
		
		
		if(error){
			if(eSelector) [self performSelector:NSSelectorFromString(eSelector) withObject:error];
		}else{
			if(background) object = [self performSelector:NSSelectorFromString(background) withObject:object];
			[self performSelectorOnMainThread:NSSelectorFromString(callback) withObject:object waitUntilDone:NO];
		}
		
		
	}
}



@end
