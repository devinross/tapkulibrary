//
//  TKShimmerLabel.m
//  Created by Devin Ross on 7/20/13.
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

#import "TKShimmerLabel.h"

@implementation TKShimmerLabel

- (id) initWithFrame:(CGRect)frame{
    if (!(self = [super initWithFrame:frame])) return nil;
		
	self.textAlignment = NSTextAlignmentCenter;
	self.backgroundColor = [UIColor clearColor];
	_direction = TKShimmerLabelDirectionLeftToRight;
	
	id dark = (id)[UIColor colorWithWhite:1 alpha:0.40].CGColor;
	id light = (id)[UIColor colorWithWhite:1 alpha:1.0f].CGColor;
	
	self.textHighlightLayer = [CAGradientLayer layer];
	self.textHighlightLayer.frame = CGRectInset(self.bounds, -400, 0);
	self.textHighlightLayer.colors = @[dark,dark,light,dark,dark];
	self.textHighlightLayer.locations = @[@0,@0.46,@0.5,@0.54,@1];
	self.textHighlightLayer.startPoint = CGPointZero;
	self.textHighlightLayer.endPoint = CGPointMake(1.0, 0);
	self.layer.mask = self.textHighlightLayer;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification object:nil];
	
    return self;
}
- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Private Animation Methods
- (NSNumber*) _animationStartPoint{
	CGFloat x = CGRectGetWidth(self.textHighlightLayer.frame)/2.0f;
	if(self.direction == TKShimmerLabelDirectionLeftToRight)
		return @(-x + CGRectGetWidth(self.frame));
	return @(x);
}
- (NSNumber*) _animationEndPoint{
	CGFloat x = CGRectGetWidth(self.textHighlightLayer.frame)/2.0f;
	if(self.direction == TKShimmerLabelDirectionLeftToRight)
		return @(x);
	return @(-x + CGRectGetWidth(self.frame));
}
- (void) _startShimmerAnimation{
	if(!self.superview) return;
	
	[self.textHighlightLayer removeAllAnimations];
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
	animation.repeatCount = HUGE_VALF;
	animation.toValue = [self _animationEndPoint];
	animation.fromValue = [self _animationStartPoint];
	animation.duration = 4.0f;
	[self.textHighlightLayer addAnimation:animation forKey:@"position.x"];
}

#pragma mark Methods That Trigger The Animation To Start
- (void) applicationDidBecomeActive:(id)sender{
	
	[self _startShimmerAnimation];
	
}
- (void) willMoveToWindow:(UIWindow *)newWindow{
	[self _startShimmerAnimation];
}

#pragma mark Properties
- (void) setDirection:(TKShimmerLabelDirection)direction{
	_direction = direction;
	[self _startShimmerAnimation];
}


@end