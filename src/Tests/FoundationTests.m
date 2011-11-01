//
//  FoundationTests.m
//  Created by Devin Ross on 4/6/11.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FoundationTests.h"

@implementation FoundationTests

- (void) testStringCategory{
    
    NSString *string;
    
    
    string = @"bob@sanders.com";
    STAssertTrue([string isEmail], @"Expected '%@' to be a valid email", string);
    
    
    string = @"ao123sda.b2132Ob@sAND123123dsadrs.c";
    STAssertTrue([string isEmail], @"Expected '%@' to be a valid email", string);
    
    
    string = @"ao,sda.bOb@sANDdsadrs.c";
    STAssertFalse([string isEmail], @"Expected '%@' to be an invalid email", string);
    
	string = @"";
    STAssertFalse([string isEmail], @"Expected '%@' to be an invalid email", string);
    
	
	string = @"@b.d";
    STAssertFalse([string isEmail], @"Expected '%@' to be an invalid email", string);
    
	
    
}
- (void) testDateCategory{
	
    NSDate *date,*date2;
    
	date = [NSDate date];
    STAssertTrue([date isToday],@"Expected %@ is today.",date);
    
	date = [NSDate yesterday];
    STAssertFalse([date isToday],@"Expected %@ is not today.",date);
    
    date = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 40];
    STAssertFalse([date isToday],@"Expected %@ is not today.",date);
    
	
    date = [NSDate yesterday];
    date2 = [NSDate date];
    STAssertFalse([date isSameDay:date2],@"Expected %@ is not same day as %@.",date,date2);
    
    
    date = [NSDate date];
    TKDateInformation info = [date dateInformation];
    info.day = 1;
    info.hour = info.minute = info.second = 0;
    date2 = [NSDate dateFromDateInformation:info];
	
    STAssertTrue([date2 isSameDay:[date monthDate]], @"Expected %@ is same day as %@.",date2,date);
    
    date = [NSDate date];
    date2 = [NSDate yesterday];
    STAssertEquals([date daysBetweenDate:date2], 1, @"Expected difference between %@ and %@ is zero.",date,date2);
	
	
}
- (void) testArrayCategory{
	
	
	STAssertThrows([[NSArray array] firstObject],@"Throws exception because empty arrays don't have objects");
	
	NSArray *ar = [NSArray arrayWithObjects:@"BOB",nil];
	STAssertNoThrow([ar firstObject],@"Doesn't throw exception.");

	
}


@end
