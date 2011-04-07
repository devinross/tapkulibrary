//
//  LogicTests.h
//  TapkuLibrary
//
//  Created by Devin Ross on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSString+TKCategory.h"
#import "NSDate+TKCategory.h"
#import "NSArray+TKCategory.h"


@interface FoundationTests : SenTestCase {

}


- (void) testStringCategory;
- (void) testDateCategory;

@end
