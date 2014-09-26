//
//  TKNumberInputView.h
//  Created by Devin Ross on 3/21/14.
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

#import "TKInputView.h"
@class TKInputKey;

/** `TKNumberInputView` is subclass `TKInputView` with a number pad. */
@interface TKNumberInputView : TKInputView

/** Initializes an number pad input view.
 
 @param frame The frame of the `UIView`.
 @param keys The keys included on the view.
 @param padFrame The frame of the number pad.
 @return An initialized `TKInputView` object or nil if the object couldn’t be created.
 */
- (instancetype) initWithFrame:(CGRect)frame withKeysModels:(NSArray*)keys keypadFrame:(CGRect)padFrame;

///----------------------------
/// @name Properties
///----------------------------

/** One key. */
@property (nonatomic,strong) TKInputKey *oneKey;

/** Two key. */
@property (nonatomic,strong) TKInputKey *twoKey;

/** Three key. */
@property (nonatomic,strong) TKInputKey *threeKey;

/** Four key. */
@property (nonatomic,strong) TKInputKey *fourKey;

/** Five key. */
@property (nonatomic,strong) TKInputKey *fiveKey;

/** Six key. */
@property (nonatomic,strong) TKInputKey *sixKey;

/** Seven key. */
@property (nonatomic,strong) TKInputKey *sevenKey;

/** Eight key. */
@property (nonatomic,strong) TKInputKey *eightKey;

/** Nine key. */
@property (nonatomic,strong) TKInputKey *nineKey;

/** Zero key. */
@property (nonatomic,strong) TKInputKey *zeroKey;

/** Zero key. 
 @return An array of all the number keys.
 */
@property (nonatomic, readonly, copy) NSArray *keypadKeys;

@end
