//
//  TKLabelTextfieldCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKLabelTextFieldCell.h"


@implementation TKLabelTextFieldCell
@synthesize field;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		field = [[UITextField alloc] initWithFrame:CGRectZero];
		field.autocorrectionType = UITextAutocorrectionTypeYes;
		[self addSubview:field];
		//field.backgroundColor = [UIColor redColor];
		field.font = [UIFont boldSystemFontOfSize:16.0];
		
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 8);
	r.origin.y += 5;
	r.size.height -= 5;
	r.origin.x += 80;
	r.size.width -= 80;
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
