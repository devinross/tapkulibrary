//
//  TKProgressBar.m
//  TapkuLibrary
//
//  Created by Devin Ross on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TKProgressBarView.h"


@implementation TKProgressBarView
@synthesize progress;

- (id) initWithStyle:(TKProgressBarViewStyle)s{
	
	CGRect r = s==TKProgressBarViewStyleLong ? CGRectMake(0, 0, 210, 20) : CGRectMake(0, 0, 180, 42);
	
	if(![super initWithFrame:r]) return nil;
	
	style = s;	
	progress = 0;
	self.backgroundColor = [UIColor clearColor];
	
	return self;
}

- (void) setProgress:(float)p{
	p = MIN(MAX(0,p),1);
	
	if(style == TKProgressBarViewStyleLong && p > 0 && p < 0.08) p = 0.08;
	else if(style == TKProgressBarViewStyleShort && p > 0 && p < 0.17) p = 0.17;
	if(p == progress) return;
	progress = p;
	[self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect borderRadius:(CGFloat)rad borderWidth:(CGFloat)thickness barRadius:(CGFloat)barRadius barInset:(CGFloat)barInset{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect rrect = CGRectInset(rect,thickness, thickness);
	CGFloat radius = rad;
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
	CGContextSetLineWidth(context, thickness);
	CGContextDrawPath(context, kCGPathStroke);
	
	
	
	radius = barRadius;
	
	rrect = CGRectInset(rrect, barInset, barInset);
	rrect.size.width = rrect.size.width * self.progress;
	minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextSetRGBFillColor(context,1, 1, 1, 1);
	CGContextDrawPath(context, kCGPathFill);
	
	
	
}
- (void) drawRect:(CGRect)rect {

	if(style == TKProgressBarViewStyleLong) 
		[self drawRect:rect borderRadius:8. borderWidth:2. barRadius:5. barInset:3];
	else
		[self drawRect:rect borderRadius:17. borderWidth:4. barRadius:11. barInset:6.];
	
}



- (void)dealloc {
    [super dealloc];
}


@end
