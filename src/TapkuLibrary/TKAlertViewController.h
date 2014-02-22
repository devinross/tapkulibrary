//
//  TKAlertViewController.h
//  Created by Devin Ross on 10/21/13.
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

/**
 This class is a cool little alert view like view controller to subclass. 
 You can add you message to the alertView and you call the show and hide methods just like `UIAlertView`.
 */
@interface TKAlertViewController : UIViewController <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>


///----------------------------
/// @name Properties
///----------------------------
/** The main view to display content on. */
@property (nonatomic,strong) UIView *alertView;

///----------------------------
/// @name Displaying and hiding alert
///----------------------------

/** Show the alert */
- (void) show;

/** Hide the alert */
- (void) hide;

/** 
 Overwrite this function to implement your own presentation animation. 
 @transitionContext The transition context.
 */
- (void) showAlertView:(id<UIViewControllerContextTransitioning>)transitionContext;

/** 
 Overwrite this function to implement your own dismissal animation. 
 @transitionContext The transition context.
 */
- (void) hideAlertView:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
