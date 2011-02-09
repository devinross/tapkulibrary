//
//  TKGraphView.h
//  Created by Devin Ross on 12/8/09.
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class TKGraph, TKGraphViewPlotView, TKGraphViewIndicator,TKGraphViewGoalLabel;
@protocol TKGraphViewPoint;


@interface TKGraphView : UIView <UIScrollViewDelegate> {
	
	// DATA
	NSArray *data;
	
	

	// GOAL LINE
	BOOL goalShown;
	NSNumber *goalValue;
	UIView *goalLine;
	TKGraphViewGoalLabel *goalLabel;
	
	// INDICATOR
	BOOL touchIndicatorEnabled;
	TKGraphViewIndicator *indicator;
	
	// BASE ELEMENTS
	UILabel *titleLabel;
	UIImageView *border;
	UIScrollView *scrollView;
	TKGraphViewPlotView *plotView;
}

@property (nonatomic,retain) UILabel *title;
@property (nonatomic,assign) int pointDistance;
@property (nonatomic,assign,getter=isTouchIndicatorEnabled) BOOL touchIndicatorEnabled;
@property (nonatomic,copy) NSString *goalTitle;
@property (nonatomic,assign,getter=isGoalShown) BOOL goalShown;
@property (nonatomic,retain) NSNumber *goalValue;


- (void) setGraphWithDataPoints:(NSArray*)dataPoints; // OBJECTS NEED TO IMPLEMENT TKGRAPHVIEWPOINT PROTOCOL

- (void) showIndicatorForPoint:(int)point;
- (void) hideIndicator;

- (void) scrollToPoint:(NSInteger)point animated:(BOOL)animated;

- (void) reload;

@end


@protocol TKGraphViewPoint

- (NSNumber*) yValue;
- (NSString*) xLabel;
- (NSString*) yLabel;

@end

