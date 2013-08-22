//
//  UIDevice+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 8/22/13.
//
//

#import "UIDevice+TKCategory.h"

@implementation UIDevice (TKCategory)

+ (BOOL) padIdiom{
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}
+ (BOOL) phoneIdiom{
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

@end
