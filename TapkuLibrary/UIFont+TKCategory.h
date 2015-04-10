//
//  UIFont+TKCategory.h
//  Created by Devin Ross on 10/5/13.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

@import UIKit;

@interface UIFont (TKCategory)

#pragma mark Helvetica Neue
+ (UIFont*) helveticaNeueWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueBoldItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueLightWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueUltraLightItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueCondensedBoldWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueMediumItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueMediumWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueThinItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueLightItalicWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueUltraLightWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueBoldWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueCondensedBlackWithSize:(CGFloat)size;
+ (UIFont*) helveticaNeueThinWithSize:(CGFloat)size;

#pragma mark Avenir
+ (UIFont*) avenirHeavyWithSize:(CGFloat)size;
+ (UIFont*) avenirObliqueWithSize:(CGFloat)size;
+ (UIFont*) avenirBlackWithSize:(CGFloat)size;
+ (UIFont*) avenirBookWithSize:(CGFloat)size;
+ (UIFont*) avenirBlackObliqueWithSize:(CGFloat)size;
+ (UIFont*) avenirHeavyObliqueWithSize:(CGFloat)size;
+ (UIFont*) avenirLightWithSize:(CGFloat)size;
+ (UIFont*) avenirMediumObliqueWithSize:(CGFloat)size;
+ (UIFont*) avenirMediumWithSize:(CGFloat)size;
+ (UIFont*) avenirLightObliqueWithSize:(CGFloat)size;
+ (UIFont*) avenirRomanWithSize:(CGFloat)size;
+ (UIFont*) avenirBookObliqueWithSize:(CGFloat)size;

@end
