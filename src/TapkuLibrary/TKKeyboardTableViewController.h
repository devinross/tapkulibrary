//
//  TKKeyboardTableViewController.h
//  Created by Devin Ross on 10/1/13.
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

#import "TKTableViewController.h"

/**
 This class provides additional functionality to `TKTableViewController` text entry. 
 It will adjust its bounds when keyboards appear and hide keyboards when the user scrolls the table.
 When you subclass, make sure to set this view controller to the delegate of your `UITextField` and `UITextView` objects.
 */
@interface TKKeyboardTableViewController : TKTableViewController <UITextFieldDelegate,UITextViewDelegate>

///----------------------------
/// @name Properties
///----------------------------

/** This flag is set to YES, it will call resignResponders when the user scrolls a table view. On iPad defaults to NO, Phone defaults to YES. */
@property (nonatomic,assign) BOOL hideKeyboardOnScroll;

/** This flag is set to YES, it will scroll the UITextField or UITextView into the bounds when it becomes the first responder. Defaults to YES. */
@property (nonatomic,assign) BOOL scrollToTextField;


///----------------------------
/// @name Methods
///----------------------------

/** Scrolls the tableview to keep the view within the table view bounds.
 @param view The view that the table views bounds adjusts to.
 */
- (void) scrollToView:(UIView*)view;

/** When subclassing, call resignFirstResponder on all your `UITextField` and `UITextView` objects */
- (void) resignResponders;

@end
