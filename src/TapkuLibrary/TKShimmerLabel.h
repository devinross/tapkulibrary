//
//  TKShimmerLabel.h
//  Created by Devin Ross on 7/20/13.
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

/** The direction of the shimmering on the label. */
typedef NS_ENUM(NSInteger, TKShimmerLabelDirection) {
	TKShimmerLabelDirectionLeftToRight,
	TKShimmerLabelDirectionRightToLeft
} ;

/** `TKShimmerLabel` is a subclassed `UILabel` with a shimmer animation similiar to the unlock screen. */
@interface TKShimmerLabel : UILabel

///----------------------------
/// @name Properties
///----------------------------
/** The gradient layer that masks the text label to create the shimmer effect. */
@property (nonatomic,strong) CAGradientLayer *textHighlightLayer;

/** The direction the shimmer should move. */
@property (nonatomic,assign) TKShimmerLabelDirection direction;


/** The duration of the shimmer animation */
@property (nonatomic,assign) NSTimeInterval shimmerDuration;

@end
