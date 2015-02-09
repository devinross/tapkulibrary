//
//  CAKeyframeAnimation+TKAnimation.m
//  Created by Devin Ross on 2/9/15.
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

#import "CAKeyframeAnimation+TKAnimation.h"
#import "CALayer+TKAnimation.h"
#import "CAAnimation+TKAnimation.h"

@implementation CAKeyframeAnimation (TKAnimation)

+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(CGPathRef)path options:(UIViewAnimationOptions)options{
    return [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay path:path options:options completion:nil];
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(CGPathRef)path options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay options:options completion:completion];
    animation.path = path;
    return animation;
}

+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay bezierPath:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options{
    return [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay bezierPath:bezierPath options:options completion:nil];
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay bezierPath:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    return [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay path:bezierPath.CGPath options:options completion:completion];
}

+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options{
    return [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay values:values options:options completion:nil];
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay options:options completion:completion];
    animation.values = values;
    return animation;
}

+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay options:(UIViewAnimationOptions)options{
    return [CAKeyframeAnimation keyframeAnimationWithKeyPath:keyPath duration:duration delay:delay options:options completion:nil];
}
+ (CAKeyframeAnimation*) keyframeAnimationWithKeyPath:(NSString *)keyPath duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    
    NSString *timing = kCAMediaTimingFunctionLinear;
    if((UIViewAnimationOptionCurveEaseInOut & options) == UIViewAnimationOptionCurveEaseInOut){
        timing = kCAMediaTimingFunctionEaseInEaseOut;
    }else if((UIViewAnimationOptionCurveEaseIn & options) == UIViewAnimationOptionCurveEaseIn){
        timing = kCAMediaTimingFunctionEaseIn;
    }else if((UIViewAnimationOptionCurveEaseOut & options) == UIViewAnimationOptionCurveEaseOut){
        timing = kCAMediaTimingFunctionEaseOut;
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = (UIViewAnimationOptionAutoreverse & options) == UIViewAnimationOptionAutoreverse ? YES : NO;
    animation.duration = duration;
    
    if(delay != 0.0)
        animation.beginTime = CACurrentMediaTime() + delay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    
    if(completion)
        animation.completion = completion;
    
    return animation;
}



@end