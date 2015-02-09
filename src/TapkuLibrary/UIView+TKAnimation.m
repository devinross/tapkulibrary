//
//  UIView+TKMaterial.m
//  Created by Devin Ross on 12/22/14.
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

#import "UIView+TKAnimation.h"
#import "UIView+TKCategory.h"

@interface CAAnimationDelegate : NSObject

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)(void);

- (void) animationDidStart:(CAAnimation *)anim;
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end


@implementation CAAnimationDelegate

- (void) animationDidStart:(CAAnimation *)anim{
    if (self.start != nil) {
        self.start();
    }
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.completion != nil) {
        self.completion(flag);
    }
}

@end


@implementation CAAnimation (BlocksAddition)

- (void) setCompletion:(void (^)(BOOL))completion{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        ((CAAnimationDelegate *)self.delegate).completion = completion;
    }
    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.completion = completion;
        self.delegate = delegate;
    }
}
- (void (^)(BOOL)) completion{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).completion: nil;
}

- (void) setStart:(void (^)(void))start{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        ((CAAnimationDelegate *)self.delegate).start = start;
    }
    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.start = start;
        self.delegate = delegate;
    }
}
- (void (^)(void)) start{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).start: nil;
}

@end



@implementation UIView (TKAnimation)

#pragma mark Material Like Animations
- (void) fireMaterialTouchDiskAtPoint:(CGPoint)point{
	
	UIView *disk = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	disk.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	disk.layer.cornerRadius = CGRectGetWidth(disk.frame)/2;
	disk.center = point;
	[self addSubview:disk];
	
	[UIView animateWithDuration:0.5 animations:^{
		disk.transform = CGAffineTransformMakeScale(10, 10);
		disk.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
	} completion:^(BOOL finished) {
		
		[disk removeFromSuperview];
	}];
	
}
- (void) materialTransitionWithSubview:(UIView*)subview atPoint:(CGPoint)point changes:(void (^)(void))changes completion:(void (^)(BOOL finished))completion{
	[self materialTransitionWithSubview:subview expandCircle:YES atPoint:point duration:1 changes:changes completion:completion];
	return;
}
- (void) materialTransitionWithSubview:(UIView*)subview expandCircle:(BOOL)expandCircle atPoint:(CGPoint)point duration:(CFTimeInterval)duration changes:(void (^)(void))changes completion:(void (^)(BOOL finished))completion{
	
	UIImage *snapshotImage = [subview snapshotImageAfterScreenUpdates:NO];
	
	UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:subview.frame];
	snapshotView.image = snapshotImage;
	[self addSubview:snapshotView];
	
	if(changes) changes();
	
	NSInteger size = 10;
	NSInteger expandScale = MAX(CGRectGetWidth(subview.frame),CGRectGetHeight(subview.frame)) / size;
	expandScale *= 2;
	
	[CATransaction begin]; {
		[CATransaction setCompletionBlock:^{
			[snapshotView removeFromSuperview];
			if(completion) completion(YES);
		}];
	
		CATransform3D endTransform = expandCircle ? CATransform3DMakeScale(expandScale, expandScale, 1) : CATransform3DIdentity;
		CATransform3D startTransform = expandCircle ? CATransform3DIdentity : CATransform3DMakeScale(expandScale, expandScale, 1);

		
		CAShapeLayer *shapeMask = [CAShapeLayer layer];
		shapeMask.frame = CGRectMake(point.x-size/2, point.y-size/2, size, size);
		shapeMask.fillColor = [UIColor redColor].CGColor;
	
	
		UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size, size)];
	
	
		if(expandCircle)
			[path appendPath:[UIBezierPath bezierPathWithRect:CGRectInset(shapeMask.bounds, -500, -500)]];
		shapeMask.path = path.CGPath;
		snapshotView.layer.mask = shapeMask;
		shapeMask.fillRule = kCAFillRuleEvenOdd;
		
		shapeMask.transform = startTransform;

		
		CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"transform"];
		anime.fromValue = [NSValue valueWithCATransform3D:shapeMask.transform];
		anime.toValue = [NSValue valueWithCATransform3D:endTransform];
		anime.duration = duration;
		[shapeMask addAnimation:anime forKey:@"material"];
		shapeMask.transform = endTransform;

	} [CATransaction commit];

}

#pragma mark Keyframe Animations
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    [self.layer addKeyframeAnimationWithKeyPath:key forKey:key duration:duration delay:delay path:bezierPath options:options completion:completion];
}
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    [self.layer addKeyframeAnimationWithKeyPath:key forKey:key duration:duration delay:delay values:values options:options completion:completion];
}

#pragma mark CAAnimation Convience Methods
- (void) addAnimation:(CAAnimation*)animation forKey:(NSString *)key{
    [self addAnimation:animation forKey:key completion:nil];
}
- (void) addAnimation:(CAAnimation*)animation forKey:(NSString *)key completion:(void (^)(BOOL))completion{
    [self.layer addAnimation:animation forKey:key completion:completion];
}

@end


@implementation CALayer (TKAnimation)

- (void) addAnimation:(CAAnimation*)animation forKey:(NSString *)key completion:(void (^)(BOOL))completion{
    if(completion)
        animation.completion = completion;
    [self addAnimation:animation forKey:key];
    
}

#pragma mark Keyframe Animations
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay path:bezierPath options:options completion:completion];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    [self addAnimation:animation forKey:key];
}
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay values:values options:options completion:completion];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    [self addAnimation:animation forKey:key];
}

@end

@implementation CAKeyframeAnimation

+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay options:options completion:completion];
    animation.path = bezierPath.CGPath;
    return animation;
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay options:options completion:completion];
    animation.values = values;
    return animation;
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{

    NSString *timing = kCAMediaTimingFunctionLinear;
    if(UIViewAnimationOptionCurveEaseInOut & options){
        timing = kCAMediaTimingFunctionEaseInEaseOut;
    }else if(UIViewAnimationOptionCurveEaseIn & options){
        timing = kCAMediaTimingFunctionEaseIn;
    }else if(UIViewAnimationOptionCurveEaseOut & options){
        timing = kCAMediaTimingFunctionEaseOut;
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = UIViewAnimationOptionAutoreverse & options;
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    
    if(completion)
        animation.completion = completion;
    
    return animation;
}

@end