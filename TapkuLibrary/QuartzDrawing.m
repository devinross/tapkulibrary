//
//  QuartzDrawing.m
//  Created by Devin Ross on 7/13/09.
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

#import "QuartzDrawing.h"


@implementation QuartzDrawing




// Returns an appropriate starting point for the demonstration of a linear gradient
/*- (CGPoint) demoLGStart:(CGRect)bounds{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

*/


CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

// Returns the center point for a radial gradient
CGPoint demoRGCenter(CGRect bounds)
{
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

// Returns an appropriate inner radius for the demonstration of the radial gradient
CGFloat demoRGInnerRadius(CGRect bounds)
{
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}



+ (void) drawLinearGradientWithFrame:(CGRect)rect colors:(CGFloat[])colours{

	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
	/*
	 //NSLog(@"DRAW GRADIENT %f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
	CGFloat colors[] =
	{
		204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
		29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00
	};
	 //NSLog(@"%f %d %f %d",colours[0],sizeof(colours),colors[0],sizeof(colors));
	 //NSLog(@"/%f %f %f",sizeof(colors),sizeof(colors[0])*4,sizeof(colors)/(sizeof(colors[0])*4));
	 */
	


	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	
	CGPoint start, end;

	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	
}



+ (void) drawLineWithFrame:(CGRect)rect colors:(CGFloat[])colors {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	
	CGContextSetLineWidth(context, 1);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
	CGContextStrokePath(context);
}

/*

-(void)drawView:(QuartzView*)view inContext:(CGContextRef)context bounds:(CGRect)bounds
{
	// The clipping rects we plan to use, which also defines the locations of each gradient
	CGRect clips[] =
	{
		CGRectMake(10.0, 30.0, 60.0, 90.0),
		CGRectMake(90.0, 30.0, 60.0, 90.0),
		CGRectMake(170.0, 30.0, 60.0, 90.0),
		CGRectMake(250.0, 30.0, 60.0, 90.0),
		CGRectMake(30.0, 140.0, 120.0, 120.0),
		CGRectMake(170.0, 140.0, 120.0, 120.0),
		CGRectMake(30.0, 280.0, 120.0, 120.0),
		CGRectMake(170.0, 280.0, 120.0, 120.0),
	};
	
	// Linear Gradients
	CGPoint start, end;
	
	// Clip to area to draw the gradient, and draw it. Since we are clipping, we save the graphics state
	// so that we can revert to the previous larger area.
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[0]);
	
	// A linear gradient requires only a starting & ending point.
	// The colors of the gradient are linearly interpolated along the line segment connecting these two points
	// A gradient location of 0.0 means that color is expressed fully at the 'start' point
	// a location of 1.0 means that color is expressed fully at the 'end' point.
	// The gradient fills outwards perpendicular to the line segment connectiong start & end points
	// (which is why we need to clip the context, or the gradient would fill beyond where we want it to).
	// The gradient options (last) parameter determines what how to fill the clip area that is "before" and "after"
	// the line segment connecting start & end.
	start = demoLGStart(clips[0]);
	end = demoLGEnd(clips[0]);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[1]);
	start = demoLGStart(clips[1]);
	end = demoLGEnd(clips[1]);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[2]);
	start = demoLGStart(clips[2]);
	end = demoLGEnd(clips[2]);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[3]);
	start = demoLGStart(clips[3]);
	end = demoLGEnd(clips[3]);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	// Radial Gradients
	
	CGFloat startRadius, endRadius;
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[4]);
	
	// A radial gradient requires a start & end point as well as a start & end radius.
	// Logically a radial gradient is created by linearly interpolating the center, radius and color of each
	// circle using the start and end point for the center, start and end radius for the radius, and the color ramp
	// inherant to the gradient to create a set of stroked circles that fill the area completely.
	// The gradient options specify if this interpolation continues past the start or end points as it does with
	// linear gradients.
	start = end = demoRGCenter(clips[4]);
	startRadius = demoRGInnerRadius(clips[4]);
	endRadius = demoRGOuterRadius(clips[4]);
	CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, 0);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[5]);
	start = end = demoRGCenter(clips[5]);
	startRadius = demoRGInnerRadius(clips[5]);
	endRadius = demoRGOuterRadius(clips[5]);
	CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[6]);
	start = end = demoRGCenter(clips[6]);
	startRadius = demoRGInnerRadius(clips[6]);
	endRadius = demoRGOuterRadius(clips[6]);
	CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[7]);
	start = end = demoRGCenter(clips[7]);
	startRadius = demoRGInnerRadius(clips[7]);
	endRadius = demoRGOuterRadius(clips[7]);
	CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
	
	// Show the clipping areas
	CGContextSetLineWidth(context, 2.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	CGContextAddRects(context, clips, sizeof(clips)/sizeof(clips[0]));
	CGContextStrokePath(context);
}



*/
@end
