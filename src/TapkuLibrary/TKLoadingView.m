//
//  PopoverEmptyView.m
//  Created by Devin on 4/13/13.
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

#import "TKLoadingView.h"

@implementation TKLoadingView


- (instancetype) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	
	
	self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.loadingLabel.backgroundColor = [UIColor clearColor];
	self.loadingLabel.text = [NSString stringWithFormat:@"%@...",NSLocalizedString(@"Loading", @"Loading")];
	self.loadingLabel.font = [UIFont boldSystemFontOfSize:16];
	[self.loadingLabel sizeToFit];
	self.loadingLabel.center = CGPointMake(CGRectGetWidth(frame)/2.0, CGRectGetHeight(frame)/2.0);
	self.loadingLabel.frame = CGRectIntegral(self.loadingLabel.frame);
	[self addSubview:self.loadingLabel];
	self.loadingLabel.hidden = YES;
	
	return self;
}


- (void) layoutSubviews{
	[super layoutSubviews];
	NSString *str = [NSString stringWithFormat:@"%@...",NSLocalizedString(@"Loading", @"Loading")];
	CGSize size = [str sizeWithFont:self.loadingLabel.font];
	CGFloat wid = CGRectGetWidth(self.frame), hei = CGRectGetHeight(self.frame);
	NSInteger x = (wid-size.width) / 2, y = (hei-size.height) / 2;
	CGRect frame = CGRectMake(x, y, size.width, size.height);
	self.loadingLabel.frame = frame;
}


#define DELAY 0.25


- (void) startAnimating{
	self.loadingLabel.hidden = NO;
	self.loadingLabel.text = [NSString stringWithFormat:@"%@...",NSLocalizedString(@"Loading", @"Loading")];
	if(!self.window) return;
	
	[self.loadingLabel sizeToFit];
	self.loadingLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
	self.loadingLabel.frame = CGRectIntegral(self.loadingLabel.frame);
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_next) object:nil];
	[self performSelector:@selector(_next) withObject:nil afterDelay:DELAY];
}
- (void) stopAnimating{
	self.loadingLabel.hidden = YES;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_next) object:nil];
}

- (void) didMoveToWindow{
	if(self.loadingLabel.hidden) return;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_next) object:nil];
	[self performSelector:@selector(_next) withObject:nil afterDelay:DELAY];
}


- (void) _next{
	if(!self.loadingLabel.superview) return;
	
	NSString *str = self.loadingLabel.text;
	
	if([str hasSuffix:@"..."])
		str = NSLocalizedString(@"Loading", @"Loading");
	else
		str = [str stringByAppendingString:@"."];
	
	
	self.loadingLabel.text = str;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_next) object:nil];
	[self performSelector:@selector(_next) withObject:nil afterDelay:DELAY];
	
	
}



@end