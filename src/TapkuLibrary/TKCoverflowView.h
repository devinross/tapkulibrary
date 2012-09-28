//
//  TKCoverflowView.h
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TKCoverflowViewDelegate,TKCoverflowViewDataSource;
@class TKCoverflowCoverView;

/**
`TKCoverflowView` imitates the coverflow you’d find in the iPod/Music app on the iPhone OS. Coverflow displays `TKCoverflowView` objects. This view functions similar to the `UITableView` where covers that are off screen aren’t loaded until need. Thus, similar to the tableview, you can dequeue a cover view and hand it back to Coverflow View using the data source.
 */
@interface TKCoverflowView : UIScrollView <UIScrollViewDelegate> {
	
	NSMutableArray *coverViews;  // sequential covers
	NSMutableArray *views;		// only covers view (no nulls)
	NSMutableArray *yard;	   // covers ready for reuse (ie. graveyard)
	
	BOOL movingRight;

	UIView *currentTouch;
	NSRange deck;
	
	
	NSInteger margin, coverBuffer, currentIndex;
	CGFloat spaceFromCurrent;
	CATransform3D leftTransform, rightTransform;
	CGSize boundSize;
	
	// SPEED
	NSInteger pos;
	CGFloat velocity;
	
	
	BOOL isDragging;
	BOOL gliding;
	NSInteger movingIndex;
}


/** The delegate must adopt the `TKCoverflowViewDelegate` protocol. The delegate is not retained. */
@property (nonatomic, assign) id <TKCoverflowViewDelegate> coverflowDelegate;

/** The data source must adopt the `TKCoverflowViewDataSource` protocol. The data source is not retained. */
@property (nonatomic, assign) id <TKCoverflowViewDataSource> dataSource;

/** Coversize is used to center the cover view in the view. This doesn’t have to be the exact size of the `TKCoverflowView` objects hand through the data source. The default is (224,224).*/
@property (nonatomic, assign) CGSize coverSize;

/** The total number cover views in the coverflow view. Changing this property will cause the coverflow to reload data. */
@property (nonatomic, assign) int numberOfCovers;

/** The spacing between cover views */
@property (nonatomic, assign) float coverSpacing;

/** The angle which covers will be display at when they are not on the center. */
@property (nonatomic, assign) float coverAngle;

/** The amount of space the center cover is infront of the rest of the other covers. Default is 300. */
@property (nonatomic, assign) float spaceInFront;



/** Returns an usued coverflow view. If there are no reusable views, it will return nil. */
- (TKCoverflowCoverView*) dequeueReusableCoverView; // like a tableview

/** Returns the cover object corresponding to that index.
 @param index Index of the cover object.
 @return The cover object at the index. If the cover is outside the visible range, it will return nil.
 */
- (TKCoverflowCoverView*) coverAtIndex:(int)index; // returns nil if cover is outside active range

/** Returns the visible covers on screen.
 @return An array of visible covers.
 */
- (NSArray*) visibleCovers;

/** Returns the range covers on screen.
 @return A range of visible covers.
 */
- (NSRange) visibleRange;

/** Sets the foremost cover.
 @param index The index of the cover that will become the foremost cover.
 @param animated Boolean flag to animate the change.
 */
- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated;

/** The index of the foremost cover */
@property (nonatomic, assign) NSInteger currentIndex;


@end

/** The delegate of a `TKCoverflowView` object must adopt the `TKCoverflowViewDelegate` protocol. */ 
@protocol TKCoverflowViewDelegate <NSObject>
@required

/** Tells the delegate that a specified cover is now the foremost cover.
 @param coverflowView The coverflow view.
 @param index The index of the foremost cover.
 */
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index;
@optional
/** Tells the delegate that a specified cover was tapped.
 @param coverflowView The coverflow view.
 @param index The index of the double tapped cover.
 @param tapCount The number of times the front cover was tapped.
 */
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasTappedInFront:(int)index tapCount:(NSInteger)tapCount;
@end

/** The data source of a `TKCoverflowView` object must adopt the `TKCoverflowViewDataSource` protocol. */ 
@protocol TKCoverflowViewDataSource <NSObject>
@required
/** Returns a coverflow cover view to place at the cover index.
 @param coverflowView The coverflow view.
 @param index The index for the coverflow cover.
 @return A `TKCoverflowCoverView` view that is either newly created or from the coverflow's reusable queue.
 */
- (TKCoverflowCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index;
@end