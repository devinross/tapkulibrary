//
//  TKMultiSwitch.h
//  Created by Devin Ross on 6/27/14.
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

typedef enum {
	TKMultiSwitchStyleHollow,
	TKMultiSwitchStyleFilled
} TKMultiSwitchStyle;

/** `TKMultiSwitch` a slide control with multiple options. Sort of like a `UISwitch` mixed with a `UISegmentControl`. */
@interface TKMultiSwitch : UIControl

/**
 Initialize a `TKMultiSwitch` instance.
 @param items The items in the switch view.
 @return A `TKMultiSwitch` object.
 */
- (id) initWithItems:(NSArray*)items;

/** The index of the selected item. */
@property (nonatomic,assign) NSInteger indexOfSelectedItem;

/** The select padding. */
@property (nonatomic,assign) CGFloat selectionInset;

/** The font used. */
@property (nonatomic,strong) UIFont *font;

/** Choose between a hollow or filled selection indicator. */
@property (nonatomic,assign) TKMultiSwitchStyle style;

/** If the style is a filled selection, then this will be used for the current select label. */
@property (nonatomic,strong) UIColor *selectedTextColor;

/** If the style is a filled selection, then this will be used for the current unselected labels. */
@property (nonatomic,strong) UIColor *textColor;


/**
 Select an item manually.
 @param index The index of the item.
 @param animated Animate the selection of the item.
 */
- (void) selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end