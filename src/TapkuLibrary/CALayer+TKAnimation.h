//
//  CALayer+TKAnimation.h
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

@import QuartzCore;

@interface CALayer (TKAnimation)

- (void) addAnimation:(CAAnimation*)animation forKey:(NSString *)key completion:(void (^)(BOOL))completion;

- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(CGPathRef)path options:(UIViewAnimationOptions)options;
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay path:(CGPathRef)path options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion;

- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay bezierPath:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options;
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay bezierPath:(UIBezierPath*)bezierPath options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion;

- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion;
- (void) addKeyframeAnimationWithKeyPath:(NSString *)keyPath forKey:(NSString*)key duration:(CFTimeInterval)duration delay:(CFTimeInterval)delay values:(NSArray*)values options:(UIViewAnimationOptions)options;


@end