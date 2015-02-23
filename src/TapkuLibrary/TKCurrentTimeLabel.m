//
//  TKCurrentTimeLabel.m
//  Created by Devin Ross on 2/10/15.
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

#import "TKCurrentTimeLabel.h"

@interface TKCurrentTimeLabel ()
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TKCurrentTimeLabel

- (instancetype) initWithFrame:(CGRect)frame {
    if(!(self=[super initWithFrame:frame])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnteredForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

- (void) willMoveToWindow:(UIWindow *)newWindow{
    if(newWindow==nil){
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    [self _updateTime];
    [self _startTimer];
}

- (void) _updateTime{
    self.attributedText = [self attributeStringWithTime:[self currentTime]];
}
- (void) _startTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(_updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void) handleEnteredBackground:(id)sender{
    [self.timer invalidate];
    self.timer = nil;
}
- (void) handleEnteredForeground:(id)sender{
    [self _updateTime];
    if(self.window)
        [self _startTimer];
}

#pragma mark Functions for Subclassing
- (NSString*) currentTime{
    return [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}
- (NSAttributedString*) attributeStringWithTime:(NSString*)time{
    return [[NSAttributedString alloc] initWithString:time];
}

@end