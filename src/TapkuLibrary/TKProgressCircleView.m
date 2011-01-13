//
//  TKProgressCircleView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TKProgressCircleView.h"

#define AnimationTimer 0.015
#define AnimationIncrement 0.02

@implementation TKProgressCircleView
@synthesize  progress=_progress,twirlMode=_twirlMode;

- (id) init{
	if(!(self=[super initWithFrame:CGRectMake(0, 0, 40, 40)])) return nil;
	
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
	self.opaque = NO;
	_progress = 0;
	_displayProgress = 0;
	_twirlMode = NO;
	
	return self;
}
- (id) initWithFrame:(CGRect)frame {
	self = [self init];
	return self;
}
- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect r = CGRectInset(rect, 4, 4);
	
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 3.0);
    CGContextAddEllipseInRect(context, r);
	CGContextStrokePath(context);
	
	// CGContextSetRGBFillColor(context, 1.0, 0.0, 1.0, 1.0);
	// CGContextFillEllipseInRect(context, rr);
	
	CGContextSetRGBFillColor(context,1,1,1,1);
	

	
	
	
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

	if(_displayProgress < _progress)
		[self performSelector:@selector(updateProgress) withObject:nil afterDelay:AnimationTimer];

}

- (void) setProgress:(float)p animated:(BOOL)animated{
	_twirlMode = NO;
	
	p = MIN(MAX(0.0,p),1.0);
	
	if(animated){
		
		_progress = p;
		[self updateProgress];
		//_displayProgress += AnimationIncrement;
		//[self performSelector:@selector(updateProgress) withObject:nil afterDelay:AnimationTimer];
	}else{
		_progress = p;
		_displayProgress = _progress;
		[self setNeedsDisplay];

	}

	
}
- (void) setProgress:(float)p{
	[self setProgress:p animated:NO];
}


- (void) updateTwirl{
	
	if(!_twirlMode) return;
	
	_displayProgress += AnimationIncrement;
	[self setNeedsDisplay];
	
	[self performSelector:@selector(updateTwirl) withObject:nil afterDelay:AnimationTimer];

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
