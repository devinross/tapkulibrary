//
//  TKTextViewCell.m
//  Created by Devin Ross on 8/3/09.
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
#import "TKTextViewCell.h"


@implementation TKTextViewCell
@synthesize textView;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if(![super initWithStyle:style reuseIdentifier:reuseIdentifier]) return nil;
	
	textView = [[UITextView alloc] initWithFrame:CGRectZero];
	textView.font = [UIFont boldSystemFontOfSize:14.0];
	[self addSubview:textView];
	
	return self;
}


- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect r = CGRectInset(self.bounds, 16, 8);
	textView.frame = r;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlight animated:(BOOL)animated {
	
    [super setHighlighted:highlight animated:animated];
	
	if(highlight)
		textView.textColor = [UIColor whiteColor];
	else
		textView.textColor = [UIColor blackColor];
	
}

- (void) dealloc {
	[textView release];
	[super dealloc];
}


@end
