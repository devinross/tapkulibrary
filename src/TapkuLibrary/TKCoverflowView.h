//
//  TKCoverflowView.h
//  Created by Devin Ross on 11/15/12.
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
@import QuartzCore;

@class TKCoverflowCoverView,TKCoverflowView,TKGradientView;

#pragma mark - TKCoverflowViewDataSource
/** The data source of a `TKCoverflowView` object must adopt the `TKCoverflowViewDataSource` protocol. */
@protocol TKCoverflowViewDataSource <NSObject>

/** Returns the number of covers to display in the view.
 @param coverflowView The coverflow view.
 @return The number of covers displayed in the coverflow view.
 */
- (NSInteger) numberOfCoversInCoverflowView:(TKCoverflowView *)coverflowView;

/** Returns a coverflow cover view to place at the cover index.
 @param coverflowView The coverflow view.
 @param index The index for the coverflow cover.
 @return A `TKCoverflowCoverView` view that is either newly created or from the coverflow's reusable queue.
 */
- (TKCoverflowCoverView *) coverflowView:(TKCoverflowView *)coverflowView coverForIndex:(NSInteger)index;

@end

#pragma mark - TKCoverflowViewDelegate
/** The delegate of a `TKCoverflowView` object must adopt the `TKCoverflowViewDelegate` protocol. */
@protocol TKCoverflowViewDelegate <NSObject>
@optional

/** Tells the delegate that a specified cover is now the foremost cover.
 @param coverflowView The coverflow view.
 @param index The index of the foremost cover.
 */
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(NSInteger)index;

/** Tells the delegate that a specified cover was tapped.
 @param coverflowView The coverflow view.
 @param index The index of the double tapped cover.
 @param tapCount The number of times the front cover was tapped.
 */
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasTappedInFront:(NSInteger)index tapCount:(NSInteger)tapCount;

@end



#pragma mark - TKCoverflowView
/**
 `TKCoverflowView` imitates the coverflow you’d find in the iPod/Music app on the iPhone OS. Coverflow displays `TKCoverflowCoverView` objects. This view functions similar to the `UITableView` where covers that are off screen aren’t loaded until need. Thus, similar to the tableview, you can dequeue a cover view and hand it back to Coverflow View using the data source.
 */
@interface TKCoverflowView : UIScrollView <UIScrollViewDelegate>


- (id) initWithFrame:(CGRect)frame deleclerationRate:(CGFloat)decelerationRate;

/** The transform applied to covers left of the center cover. */
@property (nonatomic,assign) CATransform3D leftTransform;

/** The transform applied to covers right of the center cover. */
@property (nonatomic,assign) CATransform3D rightTransform;

/** The spacing between cover views */
@property (nonatomic,assign) CGFloat leftIncrementalDistanceFromCenter;

/** The spacing between cover views */
@property (nonatomic,assign) CGFloat rightIncrementalDistanceFromCenter;


/** The spacing between cover views */
@property (nonatomic,assign) CGFloat spacing;


/** Coversize is used to center the cover view in the view. This doesn’t have to be the exact size of the `TKCoverflowView` objects hand through the data source. The default is (224,224).*/
@property (nonatomic,assign) CGSize coverSize;

/** The data source must adopt the `TKCoverflowViewDataSource` protocol. The data source is not retained. */
@property (nonatomic,assign) id <TKCoverflowViewDataSource> coverflowDataSource;

/** The delegate must adopt the `TKCoverflowViewDelegate` protocol. The delegate is not retained. */
@property (nonatomic,assign) id <TKCoverflowViewDelegate> coverflowDelegate;

/** The currently centered cover. */
@property (nonatomic,assign) NSInteger currentCoverIndex;

- (void) setCurrentCoverAtIndex:(NSInteger)index animated:(BOOL)animated;

/** Returns an usued coverflow view. If there are no reusable views, it will return nil. */
- (TKCoverflowCoverView*) dequeueReusableCoverView;

/** Returns the cover object corresponding to that index.
 @param index Index of the cover object.
 @return The cover object at the index. If the cover is outside the visible range, it will return nil.
 */
- (TKCoverflowCoverView*) coverAtIndex:(NSInteger)index;



/** Returns the range covers on screen.
 @return A range of visible covers.
 */
- (NSRange) visibleRange;

/** Reloads the cover views of the receiver. */
- (void) reloadData;

/** Returns the visible covers on screen.
 @return An array of visible covers.
 */
- (NSArray*) visibleCovers;

@end


#pragma mark - TKCoverflowCoverView
/**
 `TKCoverflowCoverView` objects are the main views for displaying covers in `TKCoverflowView`.
 */
@interface TKCoverflowCoverView : UIView

- (id) initWithFrame:(CGRect)frame reflection:(BOOL)reflection;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *reflectedImageView;
@property (nonatomic,strong) TKGradientView *reflectionGradientView;
@property (nonatomic,readonly) BOOL hasRelection;

- (void) setImage:(UIImage*)image;

@end