//
//  TKLabelTextView.m
//  Created by Devin Ross on 7/1/09.
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

#import "TKLabelTextViewCell.h"

@implementation TKLabelTextViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
	_textView.contentInset = UIEdgeInsetsZero;
	_textView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_textView];
	
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
	
	
	CGRect r = CGRectInset(self.contentView.bounds, 8, 8);
	CGFloat wid = CGRectGetWidth(self.label.frame);
	r.origin.x += wid;
	r.size.width -= wid;
	_textView.frame = r;

}

- (void) _colorText:(BOOL)active animated:(BOOL)animated{
	if(animated)
		[UIView beginAnimations:nil context:nil];
	_textView.textColor = active ? [UIColor whiteColor] : [UIColor grayColor];
	if(animated)
		[UIView commitAnimations];
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	[self _colorText:selected animated:animated];
}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	[self _colorText:highlighted animated:animated];
}



@end
