//
//  NSStringAddition.m
//  TapkuLibrary
//
//  Created by Devin Ross on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSStringAddition.h"


@implementation NSString (TKCategory)


- (float) heightWithWidth:(NSString*)text 
					 font:(UIFont*)withFont 
					width:(float)width 
				linebreak:(UILineBreakMode)lineBreakMode{

	[text retain];
	[withFont retain];
	CGSize suggestedSize = [text sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	[text release];
	[withFont release];
	
	return suggestedSize.width;
}


@end
