//
//  TKWindow.m
//  Created by Devin Ross on 6/4/09.
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

#import "TKWindow.h"

NSString *TKWindowShakeBegan = @"TKWindowShakeBegan";
NSString *TKWindowShakeCancelled = @"TKWindowShakeCancelled";
NSString *TKWindowShakeEnded = @"TKWindowShakeEnded";
NSString *TKWindowRemoteControlEvent = @"TKWindowRemoteControlEvent";


@implementation TKWindow

- (void) remoteControlReceivedWithEvent:(UIEvent *)event{
	[[NSNotificationCenter defaultCenter] postNotificationName:TKWindowRemoteControlEvent object:event];
}



#pragma mark Motion Events
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:TKWindowShakeBegan object:self];
}
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:TKWindowShakeCancelled object:self];
}
- (void) motionEnded:withEvent:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:TKWindowShakeEnded object:self];
}

@end