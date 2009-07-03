//
//  TKButtonCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKButtonCell.h"


@implementation TKButtonCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:14.0];
		[self addSubview:label];
		
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 8);

	label.frame = r;
	
	
}



- (void) setText:(NSString*)str{
	label.text = str;
}
- (NSString*)text{
	return label.text;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
	if(selected){
		label.textColor = [UIColor whiteColor];
	}else{
		label.textColor = [UIColor colorWithRed:74/255.0 green:110/255.0 blue:165/255.0 alpha:1.0];
	}

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
