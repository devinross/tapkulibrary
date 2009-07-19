//
//  TKTimeGraph.h
//  Graph
//
//  Created by Devin Ross on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class TKTimeGraph, TKTimeGraphPointsView, TKTimeGraphIndicator;

@protocol TKTimeGraphDelegate <NSObject>
@optional
- (NSString*) titleForTimeGraph:(TKTimeGraph*)graph;
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
