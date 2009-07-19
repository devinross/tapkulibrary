//
//  TKLabelCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKLabelCell.h"


@implementation TKLabelCell

@synthesize label;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
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
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
	//NSLog(@"Layout subviews %f",[self indentationWidth]);
	
	float insetx = 16;
	if(self.editing) insetx += 30;
	
	
	CGRect r = CGRectInset(self.bounds, insetx, 8);
	r.size.width = 72;
	r.size.height = 30;
	label.frame = r;
	
	
}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
	NSLog(@"Will translate");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

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


- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
