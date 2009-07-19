//
//  InfoHeaderView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoHeaderView.h"
#import "QuartzDrawing.h"

@implementation InfoHeaderView
@synthesize title,subtitle;

- (id)initWithFrame:(CGRect)frame {
	return [self init];
}

- (id) init{
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 70)]) {
        // Initialization code
		title = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 200, 23)];
		title.backgroundColor = [UIColor clearColor];
		title.font = [UIFont boldSystemFontOfSize:22.0];
		[self addSubview:title];
		
		subtitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 34, 200, 22)];
		subtitle.backgroundColor = [UIColor clearColor];
		subtitle.font = [UIFont systemFontOfSize:16];
		subtitle.shadowColor = [UIColor whiteColor];
		subtitle.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
		subtitle.shadowOffset = CGSizeMake(0,1);
		[self addSubview:subtitle];
		
		self.backgroundColor = [UIColor clearColor];
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGFloat colors[] =
	{
		200 / 255.0, 207.0 / 255.0, 212.0 / 255.0, 1.00,
		169 / 255.0,  178.0 / 255.0, 185 / 255.0, 1.00
	};
	
	[QuartzDrawing drawLinearGradientWithFrame:CGRectMake(0, 0, 320, 64) colors:colors];
	
	CGFloat colors2[] =
	{
		152/255.0, 156/255.0, 161/255.0, 0.6,
		152/255.0, 156/255.0, 161/255.0, 0.1
	};
	[QuartzDrawing drawLinearGradientWithFrame:CGRectMake(0, 65, 320, 5) colors:colors2];
	
	CGFloat line[]={
		94 / 255.0,  103 / 255.0, 109 / 255.0, 1.00
	};
	[QuartzDrawing drawLineWithFrame:CGRectMake(0, 64.5, 320, 64.5) colors:line];

}


- (void)dealloc {
    [super dealloc];
}


@end
