//
//  NSStringAddition.h
//  TapkuLibrary
//
//  Created by Devin Ross on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



@interface NSString (TKCategory)


- (float) heightWithWidth:(NSString*)text 
					 font:(UIFont*)withFont 
					width:(float)width 
				linebreak:(UILineBreakMode)lineBreakMode;



@end
