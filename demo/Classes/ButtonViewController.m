//
//  ButtonViewController.m
//  Created by Devin Ross on 10/20/13.
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

#import "ButtonViewController.h"

@implementation ButtonViewController

- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	CGFloat w = CGRectGetWidth(self.view.frame);
	
	self.glowButton = [TKGlowButton buttonWithFrame:CGRectMake(50, 100, w - 100, 40)];
	self.glowButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.glowButton setTitle:@"Glow" forState:UIControlStateNormal];
	[self.glowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.glowButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.05] forState:UIControlStateNormal];
	[self.glowButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2] forState:UIControlStateHighlighted];
	[self.view addSubview:self.glowButton];
	
	self.retroButton = [TKRetroButton buttonWithFrame:CGRectMake(50, 200,  w - 100, 40)];
	self.retroButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.retroButton.borderWidth = 2;
	[self.retroButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
	[self.retroButton setTitle:@"Retro" forState:UIControlStateNormal];
	[self.view addSubview:self.retroButton];
	
}

@end
