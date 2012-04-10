//
//  UIViewController+TKCategory.h
//  Created by Devin Ross on 12/8/11.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** Additional functionality for `UIViewController`.  */
@interface UIViewController (TKCategory)


/** Process JSON data in the background with a callback selector.
 @param data The JSON data.
 @param callback The selector that will be performed upon the parsing of the json data. The process data will be included as an object with the selector.
 */
- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback;

/** Process JSON data in the background with a callback selector.
 @param data The JSON data.
 @param callback The selector that will be performed upon the parsing of the json data. The process data will be included as an object with the selector.
 @param options An json parsing options to be included will parsing the JSON data.
 */
- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback readingOptions:(NSJSONReadingOptions)options;

/** Process JSON data in the background with a callback selector.
 @param data The JSON data.
 @param callback The selector that will be performed upon the parsing of the json data. The process data will be included as an object with the selector.
 @param backgroundProcessor The selector that will be performed in the background upon the parsing of the json data. The process data will be included as an object with the selector. This selector must return some type of object to be passed to the callback selector.
 @param options An json parsing options to be included will parsing the JSON data.
 */
- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor readingOptions:(NSJSONReadingOptions)options;

/** Process JSON data in the background with a callback selector.
 @param data The JSON data.
 @param callback The selector that will be performed upon the parsing of the json data. The process data will be included as an object with the selector.
 @param backgroundProcessor The selector that will be performed in the background upon the parsing of the json data. The process data will be included as an object with the selector. This selector must return some type of object to be passed to the callback selector.
 @param errroSelector The selector that will be called upon if there is an error parsing the data.
 */
- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector;

/** Process JSON data in the background with a callback selector.
 @param data The JSON data.
 @param callback The selector that will be performed upon the parsing of the json data. The process data will be included as an object with the selector.
 @param backgroundProcessor The selector that will be performed in the background upon the parsing of the json data. The process data will be included as an object with the selector. This selector must return some type of object to be passed to the callback selector.
 @param errroSelector The selector that will be called upon if there is an error parsing the data.
 @param options An json parsing options to be included will parsing the JSON data.
 */
- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector readingOptions:(NSJSONReadingOptions)options;

@end