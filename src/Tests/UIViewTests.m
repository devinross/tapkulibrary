//
//  UIViewTests.m
//  Created by Devin on 7/18/12.
//
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
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

#import "UIViewTests.h"

@implementation UIViewTests

- (void) testAddSubviewToBack{
	
	CGRect zero = CGRectMake(0, 0, 0, 0);
	
	UIView *superview = [[UIView alloc] initWithFrame:zero];
	UIView *one = [[UIView alloc] initWithFrame:zero];
	UIView *two = [[UIView alloc] initWithFrame:zero];
	UIView *three = [[UIView alloc] initWithFrame:zero];
	
	[superview addSubview:one];
	[superview addSubview:two];
	[superview addSubviewToBack:three];
	
	STAssertTrue([superview.subviews objectAtIndex:0] == three, nil);
}

@end
