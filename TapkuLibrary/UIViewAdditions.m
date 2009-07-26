//
//  UIViewAdditions.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIViewAdditions.h"


@implementation UIView (TKCategory)


// Returns an appropriate starting point for the demonstration of a linear gradient
/*- (CGPoint) demoLGStart:(CGRect)bounds{
 return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
 }
 
 */


CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}


CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

CGPoint demoRGCenter(CGRect bounds)
{
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

CGFloat demoRGInnerRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}



+ (void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	CGPoint start, end;
	
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	
	
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
	
}



+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	
	CGContextSetLineWidth(context, 1);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
	CGContextStrokePath(context);
	
	
	CGContextRestoreGState(context);
	
	
}



@end
