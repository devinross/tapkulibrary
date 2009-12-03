//
//  TKTimeGraph.h
//  Created by Devin Ross on 5/25/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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

@class TKGraph, TKGraphPlotView, TKGraphIndicator,TKGraphGoalLabel;
@protocol TKGraphDataSource;



@interface TKGraph : UIView <UIScrollViewDelegate> {
	
	// Data
	float highValue;
	float lowValue;
	BOOL goal;
	float goalValue;
	NSMutableArray *data;
	id<TKGraphDataSource> dataSource;
	
	
	// View
	UILabel *title;
	UIImageView *border;
	UIScrollView *scrollView;
	TKGraphPlotView *plotView;
	
	UIView *goalLine;
	TKGraphGoalLabel *goalLabel;
	
	BOOL touchIndicatorEnabled;
	TKGraphIndicator *indicator;
	
}

@property (assign,nonatomic) id<TKGraphDataSource> dataSource;
@property (copy,nonatomic) NSString *graphTitle;
@property (assign,nonatomic) BOOL touchIndicatorEnabled;
- (void) reload;
- (void) moveToPoint:(NSInteger)point animated:(BOOL)animated;
- (void) showIndicatorForPoint:(int)point;

@end





@protocol TKGraphDataSource <NSObject>
@optional
- (NSString*) titleForGraph:(TKGraph*)graph;
- (NSNumber*) goalValueForGraph:(TKGraph*)graph;
- (NSString*) graph:(TKGraph*)graph titleForIndicatorAtXPoint:(NSInteger)x;
@required
- (NSInteger) numberofPointsOnGraph:(TKGraph*)graph;
- (NSNumber*) graph:(TKGraph*)graph yValueForPoint:(int)x;
- (NSString*) graph:(TKGraph*)graph xLabelForPoint:(int)x;
- (NSString*) graph:(TKGraph*)graph yLabelForValue:(float)value;
@end