//
//  TKProgressWindow.m
//  Created by Devin Ross on 4/29/10.
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

#import "TKProgressAlertView.h"
#import "UIView+TKCategory.h"
#import "TKGlobal.h"

@implementation TKProgressAlertView


- (id) initWithProgressTitle:(NSString*)txt{
	if(!(self=[super init])) return nil;
	self.label.text = txt;
	return self;
}

- (void) loadView{
	[super loadView];
	[self.alertView addSubview:self.progressBar];
	[self.alertView addSubview:self.label];
	self.alertView.frame = CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame), CGRectGetMaxY(self.progressBar.frame) + 14);
}



#pragma mark Properties
- (TKProgressBarView *) progressBar{
	if(_progressBar) return _progressBar;

	_progressBar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
	_progressBar.frame = CGRectMakeWithSize(37, 42, _progressBar.frame.size);
	return _progressBar;
}
- (UILabel*) label{
	if(_label) return _label;
	
	_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 245, 25)];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.backgroundColor = [UIColor clearColor];
	_label.textColor = [UIColor blackColor];
	_label.font = [UIFont boldSystemFontOfSize:16];
	return _label;
}

@end