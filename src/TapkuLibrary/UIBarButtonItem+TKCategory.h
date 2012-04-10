//
//  UIBarButtonItem+TKCategory.h
//  Created by Devin Ross on 3/23/11.
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

/** Additional functionality for `UIBarButtonItem`.  */
@interface UIBarButtonItem (TKCategory)



/** Creates and returns a bar button item object using witha button with the specified properties. 
 @param image The normal state image.
 @param highlighedImage The highlighted state image.
 @param target The object that receives the action message.
 @param selector The action to send to target when this item is selected.
 @return The `UIBarButtonItem` object.
 */
+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*)image highlightedImage:(UIImage*)highlighedImage target:(id)target selector:(SEL)selector;

@end
