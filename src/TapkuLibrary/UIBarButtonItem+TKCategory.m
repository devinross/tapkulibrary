//
//  UIBarButtonItem+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIBarButtonItem+TKCategory.h"
#import "UIButton+TKCategory.h"

@implementation UIBarButtonItem (TKCategory)

+ (UIBarButtonItem*) barButtonItemWithTitle:(NSString*)t 
							backgroundImage:(UIImage*)backgroundImage 
				 highlightedBackgroundImage:(UIImage*)highlighedBackgroundImage 
									 target:(id)target selector:(SEL)s{
	
	UIButton *btn = [UIButton buttonWithFrame:CGRectMake(0,0,52,44) title:target];
	[btn addTarget:t action:s forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
	item.target = t;
	item.action = s;
	return [item autorelease];
	
}

+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*)img 
							backgroundImage:(UIImage*)backgroundImage 
				 highlightedBackgroundImage:(UIImage*)highlighedBackgroundImage 
									 target:(id)t selector:(SEL)s{
	
	UIButton *btn = [UIButton buttonWithFrame:CGRectMake(0,0,52,44) image:img];
	[btn addTarget:t action:s forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
	item.target = t;
	item.action = s;
	return [item autorelease];
	
}


@end
