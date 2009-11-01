//
//  NSStringAddition.m
//  TapkuLibrary
//
//  Created by Devin Ross on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSStringAdditions.h"


@implementation NSString (TKCategory)


- (CGSize) heightWithFont:(UIFont*)withFont 
					width:(float)width 
				linebreak:(UILineBreakMode)lineBreakMode{


	[withFont retain];
	CGSize suggestedSize = [self sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	[withFont release];
	
	return suggestedSize;
}


@end
