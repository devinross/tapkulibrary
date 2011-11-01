//
//  TKProgressBar.m
//  Created by Devin Ross on 4/29/10.
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

#import "TKProgressBarView.h"

#define AnimationTimer 0.015
#define AnimationIncrement 0.02

@implementation TKProgressBarView
@synthesize progress=_progress;

- (id) initWithStyle:(TKProgressBarViewStyle)s{
	CGRect r = s==TKProgressBarViewStyleLong ? CGRectMake(0, 0, 210, 20) : CGRectMake(0, 0, 180, 42);
	
	if(!(self=[super initWithFrame:r])) return nil;
	self.backgroundColor = [UIColor clearColor];

	_style = s;	
	_progress = _displayProgress = 0;
	
	return self;
}



- (void) _updateProgress{
	
	if(_displayProgress >= _progress){
		_displayProgress = _progress;
		return;
	} 
	
	
	_displayProgress += AnimationIncrement;
	[self setNeedsDisplay];
	
	if(_displayProgress < _progress)
		[self performSelector:@selector(_updateProgress) withObject:nil afterDelay:AnimationTimer];
	
}


- (void) setProgress:(float)p{
	[self setProgress:p animated:NO];
}
- (void) setProgress:(float)p animated:(BOOL)animated{
	_progress = p;
	
	
	p = MIN(MAX(0.0,p),1.0);
	
	if(animated){
		
		_progress = p;
		[self _updateProgress];
		
	}else{
		
		_progress = p;
		_displayProgress = _progress;
		[self setNeedsDisplay];
		
	}
	
	
}



- (void) drawRect:(CGRect)rect borderRadius:(CGFloat)rad borderWidth:(CGFloat)thickness barRadius:(CGFloat)barRadius barInset:(CGFloat)barInset{
	
	CGFloat p = _displayProgress;
	if(_style == TKProgressBarViewStyleLong && p > 0 && p < 0.08) 
		p = MAX(0.08,p);
	else if(_style == TKProgressBarViewStyleShort && p > 0 && p < 0.17) 
		p = MAX(0.17,p);
	
	p = MIN(p,1.0);
	
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
	rrect.size.width = rrect.size.width * p;
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

	if(_style == TKProgressBarViewStyleLong) 
		[self drawRect:rect borderRadius:8. borderWidth:2. barRadius:5. barInset:3];
	else
		[self drawRect:rect borderRadius:17. borderWidth:4. barRadius:11. barInset:6.];
	
}




@end
