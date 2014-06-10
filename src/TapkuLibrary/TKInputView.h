//
//  TKInputView.h
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

@import UIKit;
@class TKInputView;
@class TKInputKey;

/** The delegate of a `TKInputView` object must adopt the `TKInputViewDelegate` protocol. */
@protocol TKInputViewDelegate <NSObject>

/** When a key is tapped, this delegate method is invoked.
 @param inputView The input view.
 @param key The input key tapped.
 @return
 */
- (void) inputView:(TKInputView*)inputView didSelectKey:(TKInputKey*)key;

@end

/** 
 `TKInputView` is intended to be a custom keyboard
 that you can present to the user instead of the 
 customary Apple provided keyboards.
 */
@interface TKInputView : UIView <UIInputViewAudioFeedback>


/** Initializes an input view. Invoke this method for subclasses.
 
 @param frame The frame of the `UIView`.
 @param keys The keys included on the view.
 @return An initialized `TKInputView` object or nil if the object couldn’t be created.
 */
- (instancetype) initWithFrame:(CGRect)frame withKeysModels:(NSArray*)keys;

///----------------------------
/// @name Properties
///----------------------------

/** The delegate must adopt the `TKInputViewDelegate` protocol. The delegate is not retained. */
@property (nonatomic,weak) id <TKInputViewDelegate> delegate;

/** The text field using the custom input view. The text field is not retained.  */
@property (nonatomic,weak) UITextField *textField;

/** The backspace key. */
@property (nonatomic,strong) TKInputKey *backspaceKey;

/** The key that will resign the text field.  */
@property (nonatomic,strong) TKInputKey *hideKeyboardKey;

/** The current key that is being touched down.  */
@property (nonatomic,readonly) TKInputKey *selectedKey;

/** The view that contains all the keys. This view becomes useful when dealing with iPad formatting.  */
@property (nonatomic,strong) UIView *containerView;

@end
