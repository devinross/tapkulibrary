//
//  TKLabelTextView.m
//  Created by Devin Ross on 7/1/09.
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

#import "TKLabelTextViewCell.h"


@implementation TKLabelTextViewCell

@synthesize textView;

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) return nil;

    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self addSubview:textView];
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 8);
	r.origin.x += 73;
	r.size.width -= 73;
	
	if(self.editing){
		r.origin.x += 30;
		r.size.width -= 30;
	}
	
	textView.frame = r;
	
	
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
	if(selected){
		textView.textColor = [UIColor whiteColor];
	}else{
		textView.textColor = [UIColor grayColor];
	}
	
}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		textView.textColor = [UIColor whiteColor];
	}else{
		textView.textColor = [UIColor grayColor];
	}
}

- (void) willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	[self setNeedsDisplay];
}

- (void) dealloc {
	[textView release];
	[super dealloc];
}


@end
