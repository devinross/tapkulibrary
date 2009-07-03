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
	
	CGRect r = CGRectInset(self.bounds, 16, 8);
	r.size.width = 72;
	r.size.height = 30;
	label.frame = r;
	
	
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
    [super dealloc];
	[label release];
}


@end
