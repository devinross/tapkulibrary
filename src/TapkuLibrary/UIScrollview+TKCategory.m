//
//  UIScrollview+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIScrollview+TKCategory.h"


@implementation UIScrollView (TKCategory)


- (void) scrollToTop{
	self.contentOffset = CGPointMake(0,0);
}

@end
