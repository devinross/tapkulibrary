//
//  UIBarButtonItem+TKCategory.h
//  TapkuLibrary
//
//  Created by Devin Ross on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIBarButtonItem (TKCategory)


+ (UIBarButtonItem*) barButtonItemWithTitle:(NSString*)title 
							backgroundImage:(UIImage*)backgroundImage 
				 highlightedBackgroundImage:(UIImage*)highlighedBackgroundImage 
									 target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*)image
							backgroundImage:(UIImage*)backgroundImage 
				 highlightedBackgroundImage:(UIImage*)highlighedBackgroundImage 
									 target:(id)target selector:(SEL)selector;

@end
