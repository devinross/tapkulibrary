//
//  ControlsViewController.m
//  Created by Devin Ross on 6/30/14.
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

#import "ControlsViewController.h"

@implementation ControlsViewController

- (void) loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = NSLocalizedString(@"Controls",@"");
	
	self.multiswitch1 = [[TKMultiSwitch alloc] initWithItems:@[@"Option 1", @"Option 2"]];
	self.multiswitch1.frame = CGRectMakeWithSize(10, 80, self.multiswitch1.frame.size);
	[self.multiswitch1 addTarget:self action:@selector(changedSwitchValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.multiswitch1];
	
	self.multiswitch2 = [[TKMultiSwitch alloc] initWithItems:@[@"One", @"Two",@"Three"]];
	self.multiswitch2.frame = CGRectMakeWithSize(10, 140, self.multiswitch2.frame.size);
	[self.multiswitch2 addTarget:self action:@selector(changedSwitchValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.multiswitch2];
	
	
	self.pegSlider = [[TKPegSlider alloc] initWithFrame:CGRectMake(10, 200, 40, 40)];
	self.pegSlider.frame = CGRectMakeWithSize(10, 200, self.pegSlider.frame.size);
	self.pegSlider.numberOfPegs = 8;
	self.pegSlider.leftEndImage = [UIImage imageNamed:@"sad"];
	self.pegSlider.rightEndImage = [UIImage imageNamed:@"happy"];

	[self.pegSlider addTarget:self action:@selector(changedPegValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.pegSlider];
	
}

- (void) changedPegValue:(TKPegSlider*)slider{
	TKLog(@"%@",slider);
}

- (void) changedSwitchValue:(TKMultiSwitch*)switcher{
	TKLog(@"%@",switcher);

}

@end
