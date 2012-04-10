//
//  UIColor+TKCategory.h
//  Created by Devin Ross on 5/14/11.
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

/** Additional functionality for `UIColor`.  */
@interface UIColor (TKCategory)

/** Creates and returns a color object using the specific hex value. 
 @param hex The hex value that will decide the color.
 @return The `UIColor` object.
*/
+ (UIColor *) colorWithHex:(unsigned int)hex;

/** Creates and returns a color object using the specific hex value. 
 @param hex The hex value that will decide the color.
 @param alpha The opacity of the color.
 @return The `UIColor` object.
*/
+ (UIColor *) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/** Creates and returns a color object with a random color value. The alpha property is 1.0.
 @return The `UIColor` object.
*/
+ (UIColor *) randomColor;

@end