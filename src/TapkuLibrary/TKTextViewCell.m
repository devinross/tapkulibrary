//
//  TKTextViewCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 8/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKTextViewCell.h"


@implementation TKTextViewCell
@synthesize textView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		textView = [[UITextView alloc] initWithFrame:CGRectZero];
		textView.font = [UIFont boldSystemFontOfSize:14.0];
		[self addSubview:textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect r = CGRectInset(self.bounds, 16, 8);
	textView.frame = r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}


@end
