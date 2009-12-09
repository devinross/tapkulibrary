//
//  TKSwitchCell.m
//  Created by Devin Ross on 6/13/09.
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
#import "TKSwitchCell.h"


@implementation TKSwitchCell
@synthesize slider;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.font = [UIFont boldSystemFontOfSize:16.0];
		title.adjustsFontSizeToFitWidth = YES;
		[self addSubview:title];
		
		slider = [[UISwitch alloc] initWithFrame:CGRectZero];
		[self addSubview:slider];
		
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect r = CGRectInset(self.bounds, 20, 8);
	r.size.width -= 100;
	title.frame = r;
	
	r = CGRectInset(self.bounds, 20,8);
	r.origin.x += 185;
	r.size.width = 95;
	
	slider.frame = r;
	
}




- (NSString*) text{
	return title.text;
}
- (void) setText:(NSString*)txt{
	title.text = txt;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    [super dealloc];
}


@end
