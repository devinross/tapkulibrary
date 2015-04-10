//
//  TKInputKey.h
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

/** An input key display type. */
typedef NS_ENUM(NSInteger, TKInputKeyType) {
	TKInputKeyTypeDefault = 0,
	TKInputKeyTypeDark = 1,
	TKInputKeyTypeHighlighted = 2
} ;

/** `TKInputKey` is an input key to be used by a `TKInputView`. */
@interface TKInputKey : UIView 

/** Initializes an input key.
 
 @param frame The frame of the `UIView`.
 @param symbol A image or string for the key.
 @param normal A image or string for the key.
 @param highlighted A image or string for the key.
 @param runner If yes, the key can be highlighted and selected even if it isn't the initial key touched at the beginning.
 @return An initialized `TKInputKey` object or nil if the object couldn’t be created.
 */
+ (instancetype) keyWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner;


/** Initializes an input key.
 
 @param frame The frame of the `UIView`.
 @param symbol A image or string for the key.
 @param normal A image or string for the key.
 @param highlighted A image or string for the key.
 @param runner If yes, the key can be highlighted and selected even if it isn't the initial key touched at the beginning.
 @return An initialized `TKInputKey` object or nil if the object couldn’t be created.
 */
- (instancetype) initWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner NS_DESIGNATED_INITIALIZER;

///----------------------------
/// @name Properties
///----------------------------

/** The display mode when the key is in a normal state.  */
@property (nonatomic,assign) TKInputKeyType normalType;

/** The display mode when the key is in a highlighted state.  */
@property (nonatomic,assign) TKInputKeyType highlighedType;

/** If yes, the key can be highlighted and selected even if it isn't the initial key touched at the beginning.  */
@property (nonatomic,assign) BOOL runner;

/** The label that displays the text symbol.  */
@property (nonatomic,strong) UILabel *label;

/** The symbol image view.  */
@property (nonatomic,strong) UIImageView *symbol;


/** The backspace key.
 @param highlighted A flag to set the key to highlighted. */
- (void) setHighlighted:(BOOL)highlighted;

@end