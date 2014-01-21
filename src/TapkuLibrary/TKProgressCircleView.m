//
//  TKProgressCircleView.m
//  Created by Devin Ross on 1/1/11.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

#import "TKProgressCircleView.h"

#define AnimationTimer 0.015
#define AnimationIncrement 0.02

@implementation TKProgressCircleView

- (id) init{
	self = [self initWithFrame:CGRectZero];	
	return self;
}
- (id) initWithFrame:(CGRect)frame {
	frame.size = CGSizeMake(40,40);
	if(!(self = [super initWithFrame:frame])) return nil;
	
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
	self.opaque = NO;
	_progress = 0;
	_displayProgress = 0;
	_twirlMode = NO;
	
	return self;
}
- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect r = CGRectInset(rect, 4, 4);
	
	CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
	CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);

    CGContextSetLineWidth(context, 3.0);
    CGContextAddEllipseInRect(context, r);
	CGContextStrokePath(context);
	
	if(!_twirlMode){
		CGContextAddArc(context, rect.size.width/2, rect.size.height/2, (rect.size.width/2)-7, M_PI/-2.0, ((M_PI*2.0) *_displayProgress) - M_PI/2.0 , false);
		CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height/2);
		CGContextFillPath(context);
	}else{
		float start = (M_PI*2.0 *_displayProgress) - (M_PI/2.0);
		CGContextAddArc(context, rect.size.width/2, rect.size.height/2, (rect.size.width/2)-7, start, start + (M_PI/2.0), false);
		CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height/2);
		CGContextFillPath(context);
	}

}

- (void) updateProgress{
	
	if(_displayProgress >= _progress || _twirlMode) return;
	

	_displayProgress += AnimationIncrement;
	[self setNeedsDisplay];

	if(_displayProgress < _progress){
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateProgress) object:nil];
		[self performSelector:@selector(updateProgress) withObject:nil afterDelay:AnimationTimer];
	}

}
- (void) updateTwirl{
	if(!_twirlMode) return;
	
	_displayProgress += AnimationIncrement;
	[self setNeedsDisplay];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTwirl) object:nil];
	[self performSelector:@selector(updateTwirl) withObject:nil afterDelay:AnimationTimer];
	
}

- (void) didMoveToWindow{
	[self updateTwirl];
	[self updateProgress];
}


#pragma mark Setter Methods
- (void) setProgress:(float)p animated:(BOOL)animated{
	_twirlMode = NO;
	
	p = MIN(MAX(0.0,p),1.0);
	
	if(animated){
		_progress = p;
		[self updateProgress];
	}else{
		_progress = p;
		_displayProgress = _progress;
		[self setNeedsDisplay];
	}

	
}
- (void) setProgress:(float)p{
	[self setProgress:p animated:NO];
}
- (void) setTwirlMode:(BOOL)t{
	if(t==_twirlMode) return;
	
	_twirlMode = t;
	
	if(!_twirlMode){
		[self setProgress:_progress animated:NO];
		return;
	}
	
	_displayProgress = 0;
	
	[self setNeedsDisplay];
	[self updateTwirl];
	
}

@end
