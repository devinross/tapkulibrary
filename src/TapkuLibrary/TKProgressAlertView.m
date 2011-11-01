//
//  TKProgressWindow.m
//  Created by Devin Ross on 4/29/10.
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

#import "TKProgressAlertView.h"
#import "UIView+TKCategory.h"

@implementation TKProgressAlertView
@synthesize progressBar=_progressBar,label=_label;


- (id) initWithProgressTitle:(NSString*)txt{
	if(!(self=[super initWithFrame:CGRectZero])) return nil;
		
	self.label.text = txt;
	
	return self;
}

- (void) drawRect:(CGRect)rect{
	CGRect r = CGRectInset(rect, 6, 0);
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] set];
	[UIView drawRoundRectangleInRect:r withRadius:10];
}


- (void) show{
	[super show];
	
	for (UIView *subview in [self subviews]) {
		if ([subview isKindOfClass:[UIImageView class]])  subview.hidden = YES;
	}
	
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.progressBar];
	[self addSubview:self.label];
}
- (void) hide{
	[self dismissWithClickedButtonIndex:0 animated:NO];
}


- (TKProgressBarView *) progressBar{
	if(_progressBar==nil){
		_progressBar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
		CGRect r = _progressBar.frame;
		r.origin.x = 37;
		r.origin.y = 42;
		_progressBar.frame = r;
	}
	return _progressBar;
}
- (UILabel*) label{
	if(_label==nil){
		_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 245, 25)];
		_label.textAlignment = UITextAlignmentCenter;
		_label.backgroundColor = [UIColor clearColor];
		_label.textColor = [UIColor whiteColor];
		_label.font = [UIFont boldSystemFontOfSize:16];		
	}
	return _label;
}




@end
