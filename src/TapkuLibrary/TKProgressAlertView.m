//
//  TTProgressWindow.m
//  TapTapShare
//
//  Created by Devin Ross on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TKProgressAlertView.h"
#import "UIView+TKCategory.h"

@implementation TKProgressAlertView


- (id) initWithProgressTitle:(NSString*)txt{
	if(![super initWithFrame:CGRectZero]) return nil;
		
	self.label.text = txt;
	
	return self;
}

- (void) drawRect:(CGRect)rect{
	CGRect r = CGRectInset(rect, 6, 0);
	[UIView drawRoundRectangleInRect:r withRadius:10 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
}


- (void) show{
	[super show];
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.progressBar];
	[self addSubview:self.label];
}
- (void) hide{
	[self dismissWithClickedButtonIndex:0 animated:NO];
}


- (TKProgressBarView *) progressBar{
	if(progressBar==nil){
		progressBar = [[TKProgressBarView alloc] initWithStyle:TKProgressBarViewStyleLong];
		CGRect r = self.progressBar.frame;
		r.origin.x = 37;
		r.origin.y = 42;
		self.progressBar.frame = r;
	}
	return progressBar;
}
- (UILabel*) label{
	if(label==nil){
		label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 245, 25)];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:16];
		//label.font = [UIFont fontWithName:@"Bree Oblique" size:16];
		
	}
	return label;
}

- (void)dealloc {
	[progressBar release];
	[label release];
	[super dealloc];
}


@end
