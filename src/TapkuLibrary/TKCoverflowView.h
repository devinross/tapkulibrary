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

#import <QuartzCore/QuartzCore.h>

@protocol TKCoverflowViewDelegate,TKCoverflowViewDataSource;
@class TKCoverView;

static const CGFloat TKCoverflowViewCoverAngleNormal = 1.4;
static const CGFloat TKCoverflowViewCoverAngleMore = 1.4;
static const CGFloat TKCoverflowViewCoverAngleLess = 1.1;

@interface TKCoverflowView : UIScrollView <UIScrollViewDelegate> {

	
	NSMutableArray *coverViews;  // sequential covers
	NSMutableArray *views;		// only covers view (no nulls)
	NSMutableArray *yard;	   // covers ready for reuse
	
	
	int numberOfCovers;
	int currentIndex;
	
	BOOL fast;
	float origin;
	BOOL movingRight;

	
	UIView *currentTouch;
	
	NSRange deck;
	
	
	int margin;
	CGSize coverSize;
	float coverSpacing;
	int coverBuffer,speedbuffer;
	CATransform3D leftTransform, rightTransform, leftForward, rightForward;
	
	float angle;

	
	id <TKCoverflowViewDelegate> delegate;
	id <TKCoverflowViewDataSource> dataSource;
}
@property (nonatomic, assign) id <TKCoverflowViewDelegate> delegate;
@property (nonatomic, assign) id <TKCoverflowViewDataSource> dataSource;
@property (nonatomic, assign) CGSize coverSize; // default 124 x 124
@property (nonatomic, assign) int numberOfCovers;
@property (nonatomic, assign) float coverSpacing;
@property (nonatomic, assign) float angle;

- (TKCoverView*) dequeueReusableCoverView; // like a tableview

- (TKCoverView*) coverAtIndex:(int)index; // returns nil if cover is outside active range
- (int) indexOfFrontCoverView;
- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated;


@end

@protocol TKCoverflowViewDelegate <NSObject>
@required
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index;
@optional
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index;
@end

@protocol TKCoverflowViewDataSource <NSObject>
@required
- (TKCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index;
@end