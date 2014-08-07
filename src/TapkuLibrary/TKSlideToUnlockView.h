//
//  TKSlideToUnlockView.h
//  Created by Devin Ross on 5/21/13.
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
@import AudioToolbox;
@class TKShimmerLabel;

/** The mode that the slider to unlock view is in. */
typedef enum {
	TKSlideToUnlockViewModeNormal = 0,
	TKSlideToUnlockViewModeDisabled = 1
} TKSlideToUnlockViewMode;

/** `TKSlideToUnlockView` is a control that allows users to slide to unlock like you would the lock screen. */
@interface TKSlideToUnlockView : UIControl <UIScrollViewDelegate>

///----------------------------
/// @name Properties
///----------------------------
/** The shimmering text label that directs the user to act. */
@property (nonatomic,strong) TKShimmerLabel *textLabel;

/** The scroll view that the user slides */
@property (nonatomic,strong) UIScrollView *scrollView;

/** The view behind the scroll view */
@property (nonatomic,strong) UIImageView *backgroundView;

/** The arrow */
@property (nonatomic,strong) UIImageView *arrowView;

/** A read-only property to tell whether to tell the state of the view */
@property (nonatomic,readonly) BOOL isUnlocked;

/** The mode flag to enable of disable the view from acting. If disabled the device will vibrate. */
@property (nonatomic,assign) TKSlideToUnlockViewMode mode;

/** Reset the slider view to the original position.
 @param animated If yes, the view will animate to a reset position.
 */
- (void) resetSlider:(BOOL)animated;

@end
