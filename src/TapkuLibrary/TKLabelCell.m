//
//  TKLabelCell.m
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

#import "TKLabelCell.h"


@implementation TKLabelCell

@synthesize label;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    // Initialization code
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    [self addSubview:label];
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    
    //label.backgroundColor = [UIColor redColor];
    label.numberOfLines = 20;
    
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
	//NSLog(@"Layout subviews %f",[self indentationWidth]);
	
	float insetx = 16;
	if(self.editing) insetx += 30;
	
	
	CGRect r = CGRectInset(self.bounds, insetx, 8);
	r.size.width = 72;
	r.size.height = 30;
	label.frame = r;
	
	
}

- (void) willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	[self setNeedsDisplay];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
	if(selected){
		label.textColor = [UIColor whiteColor];
	}else{
		label.textColor = [UIColor grayColor];
	}

}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		label.textColor = [UIColor whiteColor];
	}else{
		label.textColor = [UIColor grayColor];
	}
}




- (void) dealloc {
	[label release];
    [super dealloc];
}


@end
