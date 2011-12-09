//
//  UIViewController+TKCategory.h
//  TapkuLibrary
//
//  Created by Devin Ross on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (TKCategory)

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback;

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback readingOptions:(NSJSONReadingOptions)options;

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor readingOptions:(NSJSONReadingOptions)options;

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector;

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector readingOptions:(NSJSONReadingOptions)options;




@end
