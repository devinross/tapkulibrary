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

@class TKTimeGraph, TKTimeGraphPointsView, TKTimeGraphIndicator;

@protocol TKTimeGraphDelegate <NSObject>
@optional
- (NSString*) titleForTimeGraph:(TKTimeGraph*)graph;
- (NSNumber*) goalValueForTimeGraph:(TKTimeGraph*)graph;
@required
- (int) numberofPointsOnTimeGraph:(TKTimeGraph*)graph;
- (NSNumber*) timeGraph:(TKTimeGraph*)graph yValueForPoint:(int)x;
- (NSString*) timeGraph:(TKTimeGraph*)graph xLabelForPoint:(int)x;
- (NSString*) timeGraph:(TKTimeGraph*)graph yLabelForValue:(float)value;


@end


@interface TKTimeGraph : UIView {
	
	// Data
	float highValue;
	float lowValue;
	BOOL goal;
	float goalValue;
	NSMutableArray *data;
	id<TKTimeGraphDelegate> delegate;
	
	
	// View
	UIActivityIndicatorView *activity;
	
	UILabel *title;
	UIImageView *border;
	UIScrollView *scrollView;
	TKTimeGraphPointsView *pointsView;
	
}
@property (retain,nonatomic) NSMutableArray *data;
@property (assign) id<TKTimeGraphDelegate> delegate;
- (void) setTitle:(NSString*)str;
@end


@interface TKTimeGraphPointsView : UIView {
	NSMutableArray *data;
	TKTimeGraphIndicator *indicator;
}
@property (retain,nonatomic) NSMutableArray *data;
@end

@interface TKTimeGraphIndicator : UIView {
	UIImageView *background;
	UILabel *label;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up;
@end
