//
//  TKPageControl.h
//  Created by Devin Ross on 12/22/14.
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

/** `TKPageControl` is a reimplementation of UIPageControl with a little flair. */
@interface TKPageControl : UIControl

/**
 This method allows you to set the background color during a certain state.
 @param currentPage The current page to be selected.
 @param animated Animate the selection of the current page.
 */
- (void) setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

/**
 This method allows you to set the background color during a certain state.
 @param color The background color of the button.
 @param state The state to which the color will appear.
 */
- (void) setImage:(UIImage*)image forPage:(NSInteger)page;


///----------------------------
/// @name Properties
///----------------------------
/** The number of pages in the page control. */
@property (nonatomic,assign) NSInteger numberOfPages;

/** The current selected page. */
@property (nonatomic,assign) NSInteger currentPage;

/** The color of the page indicators that aren't active. */
@property (nonatomic,retain) UIColor *pageIndicatorTintColor;

/** The color of the current page indicator. */
@property (nonatomic,retain) UIColor *currentPageIndicatorTintColor;

/** The circle radius of the page indicator. */
@property (nonatomic,assign) CGFloat dotRadius;

/** The space in between page indicators. */
@property (nonatomic,assign) CGFloat spaceBetweenDots;

@end