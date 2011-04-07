//
//  LogicTests.m
//  TapkuLibrary
//
//  Created by Devin Ross on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoundationTests.h"


@implementation FoundationTests



- (void) testStringCategory{
    
    NSString *string;
    BOOL valid;
    
    
    string = @"bob@sanders.com";
    valid = [string isEmail];
    STAssertTrue(valid, @"Expected %@ to be a valid email", string);
    
    
    string = @"aosda.bOb@sANDdsadrs.c";
    valid = [string isEmail];
    STAssertTrue(valid, @"Expected %@ to be a valid email", string);
    
    
    string = @"ao,sda.bOb@sANDdsadrs.c";
    valid = [string isEmail];
    STAssertFalse(valid, @"Expected %@ to be a valid email", string);
    
    
}
- (void) testDateCategory{
    NSDate *date,*other;
    BOOL value;
    
    date = [NSDate date];
    value = [date isToday];
    STAssertTrue(value,@"Expected %@ is today.",date);
    
    date = [NSDate yesterday];
    value = [date isToday];
    STAssertFalse(value,@"Expected %@ is not today.",date);
    
    
    other = [NSDate date];
    value = [date isSameDay:other];
    STAssertFalse(value,@"Expected %@ is not same day as %@.",date,other);
    
    
    date = [NSDate date];
    TKDateInformation info = [date dateInformation];
    info.day = 1;
    info.hour = info.minute = info.second = 0;
    other = [NSDate dateFromDateInformation:info];
    value = [other isSameDay:[date monthDate]];
    STAssertTrue(value, @"Expected %@ is same day as %@.",other,date);
    
    date = [NSDate date];
    other = [NSDate yesterday];
    int diff = [date daysBetweenDate:other];
    STAssertEquals(diff, 1, @"Expected difference between %@ and %@ is zero.",date,other);
}


@end
