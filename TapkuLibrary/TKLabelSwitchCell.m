//
//  TKLabelSlider.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKLabelSwitchCell.h"


@implementation TKLabelSwitchCell
@synthesize switcher;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		switcher = [[UISwitch alloc] initWithFrame:CGRectZero];
		[self addSubview:switcher];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 10);
	r.origin.x += label.frame.size.width + 10;
	switcher.frame = r;
	
	
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
