//
//  TKSwitchCell.m
//  ToDoLists
//
//  Created by Devin Ross on 6/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKSwitchCell.h"


@implementation TKSwitchCell
@synthesize slider;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
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

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
