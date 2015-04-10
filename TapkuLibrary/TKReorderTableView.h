//
//  TKReorderTableView.h
//  Created by Devin Ross on 6/25/13.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Portions Copyright (c) 2013 Ben Vogelzang.
 https://github.com/bvogelzang/BVReorderTableView
 
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
@import QuartzCore;


/** The delegate of a `TKReorderTableView` object must adopt the `TKReorderTableViewDelegate` protocol. */
@protocol TKReorderTableViewDelegate <UITableViewDelegate>
@required

/** 
 This method is called when starting the re-ording process. You should likely replace the data object corresponding to this index path from the data model with a dummy object until the reordering is complete.
 @param tableView The table view that will be reordered.
 @param indexPath The index path of the table view cell that will be moved.
 */
- (void) tableView:(UITableView*)tableView willReorderRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 This method is called when the selected row is dragged to a new position. You simply update your data source to reflect that the rows have switched places. This can be called multiple times during the reordering process.
 @param tableView The table view that will be reordered.
 @param fromIndexPath The original index path of the cell being moved.
 @param toIndexPath The new index path of the cell being moved.
 */
- (void) tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

/**
 This method is called when the selected row is released to its new position.
 @param tableView The table view that will be reordered.
 @param indexPath The original index path of the cell being moved.
 */
- (void) tableView:(UITableView*)tableView didFinishReorderingAtIndexPath:(NSIndexPath *)indexPath;

@end

/** `TKReorderTableView` is a subclassed `UITableView` that handles custom dragging using long press. */
@interface TKReorderTableView : UITableView

/** The delegate must adopt the `TKReorderTableViewDelegate` protocol. The delegate is not retained. */
@property (nonatomic, assign) id <TKReorderTableViewDelegate> delegate;

/** Flag that turns on and off the ability to reorder cells. */
@property (nonatomic, assign) BOOL canReorder;

@end
