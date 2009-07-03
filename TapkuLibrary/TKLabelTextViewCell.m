//
//  TKLabelTextView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKLabelTextViewCell.h"


@implementation TKLabelTextViewCell

@synthesize textView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		textView = [[UITextView alloc] initWithFrame:CGRectZero];
		[self addSubview:textView];
		//textView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGRect r = CGRectInset(self.bounds, 16, 8);
	r.origin.x += 73;
	r.size.width -= 73;
	textView.frame = r;
	
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
	if(selected){
		textView.textColor = [UIColor whiteColor];
	}else{
		textView.textColor = [UIColor grayColor];
	}
	
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		textView.textColor = [UIColor whiteColor];
	}else{
		textView.textColor = [UIColor grayColor];
	}
}



- (void)dealloc {
    [super dealloc];
	[textView release];
}


@end
