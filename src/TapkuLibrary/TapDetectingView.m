
/*
     File: TapDetectingView.m
 Abstract: UIView subclass that responds to taps and notifies its delegate.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

#import "TapDetectingView.h"

#define DOUBLE_TAP_DELAY 0.35

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);

@interface TapDetectingView ()
- (void)handleSingleTap;
- (void)handleDoubleTap;
- (void)handleTwoFingerTap;
@end

@implementation TapDetectingView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // cancel any pending handleSingleTap messages 
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    }    
    
    // check for 2-finger tap if we've seen multiple touches and haven't yet ruled out that possibility
    else if (multipleTouches && twoFingerTapIsPossible) { 
        
        // case 1: this is the end of both touches at once 
        if ([touches count] == 2 && allTouchesEnded) {
            int i = 0; 
            int tapCounts[2]; CGPoint tapLocations[2];
			tapCounts[0] = 0;
			tapCounts[1] = 0;
            for (UITouch *touch in touches) {
                tapCounts[i]    = [touch tapCount];
                tapLocations[i] = [touch locationInView:self];
                i++;
            }
            if (tapCounts[0] == 1 && tapCounts[1] == 1) { // it's a two-finger tap if they're both single taps
                tapLocation = midpointBetweenPoints(tapLocations[0], tapLocations[1]);
                [self handleTwoFingerTap];
            }
        }
        
        // case 2: this is the end of one touch, and the other hasn't ended yet
        else if ([touches count] == 1 && !allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if touch is a single tap, store its location so we can average it with the second touch location
                tapLocation = [touch locationInView:self];
            } else {
                twoFingerTapIsPossible = NO;
            }
        }

        // case 3: this is the end of the second of the two touches
        else if ([touches count] == 1 && allTouchesEnded) {
            UITouch *touch = [touches anyObject];
            if ([touch tapCount] == 1) {
                // if the last touch up is a single tap, this was a 2-finger tap
                tapLocation = midpointBetweenPoints(tapLocation, [touch locationInView:self]);
                [self handleTwoFingerTap];
            }
        }
    }
        
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}

#pragma mark Private

- (void)handleSingleTap {
    if ([delegate respondsToSelector:@selector(tapDetectingView:gotSingleTapAtPoint:)])
        [delegate tapDetectingView:self gotSingleTapAtPoint:tapLocation];
}

- (void)handleDoubleTap {
    if ([delegate respondsToSelector:@selector(tapDetectingView:gotDoubleTapAtPoint:)])
        [delegate tapDetectingView:self gotDoubleTapAtPoint:tapLocation];
}
    
- (void)handleTwoFingerTap {
    if ([delegate respondsToSelector:@selector(tapDetectingView:gotTwoFingerTapAtPoint:)])
        [delegate tapDetectingView:self gotTwoFingerTapAtPoint:tapLocation];
}
    
@end

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}
                    
