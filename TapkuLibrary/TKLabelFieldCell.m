//
//  TKLabelFieldCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKLabelFieldCell.h"


@implementation TKLabelFieldCell
@synthesize field;



- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		field = [[UILabel alloc] initWithFrame:CGRectZero];
		[self addSubview:field];
		field.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 8);
	r.origin.x += 80;
	r.size.width -= 80;
	
	if(self.editing){
		r.origin.x += 30;
		r.size.width -= 30;
	}
	
	field.frame = r;
	
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
	if(selected){
		field.textColor = [UIColor whiteColor];
	}else{
		field.textColor = [UIColor blackColor];
	}
	
}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		field.textColor = [UIColor whiteColor];
	}else{
		field.textColor = [UIColor blackColor];
	}
}


- (void)dealloc {
    [super dealloc];
	[field release];
}


@end
