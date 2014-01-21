//
//  TKTextfieldCell.m
//  Created by Devin Ross on 5/18/13.
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

#import "TKTextFieldCell.h"

@implementation TKTextFieldCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
	
	_textField = [[UITextField alloc] initWithFrame:CGRectZero];
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.contentView addSubview:_textField];
	
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}

- (void) layoutSubviews {
    [super layoutSubviews];
	
	CGRect frame = CGRectInset(self.contentView.bounds, 14, 4);
	if(self.indentationLevel != 0 && self.indentationWidth != 0){
		frame.origin.x = self.indentationLevel * self.indentationWidth;
		frame.size.width = CGRectGetWidth(self.contentView.frame) - CGRectGetMinX(frame) - 14;
	}
	_textField.frame = frame;
}

- (void) _colorText:(BOOL)active{
	_textField.textColor = active ? [UIColor whiteColor] : [UIColor blackColor];
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	[self _colorText:selected];
}
- (void) setHighlighted:(BOOL)highlight animated:(BOOL)animated {
    [super setHighlighted:highlight animated:animated];
	[self _colorText:highlight];
}


@end
