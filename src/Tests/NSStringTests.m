//
//  String.m
//  Created by Devin on 7/18/12.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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

#import "NSStringTests.h"

@implementation NSStringTests

- (void) testShouldValidateEmailAddress{
    
	XCTAssertFalse(nil, @"POCKET");
    XCTAssertTrue([@"bob@sanders.com" isEmail], @"Expected to be a valid email");
    XCTAssertTrue([@"ao123sda.b2132Ob@sAND123123dsadrs.c" isEmail], @"Expected to be a valid email");
    
    XCTAssertFalse([@"ao,sda.bOb@sANDdsadrs.c" isEmail], @"Expected to be an invalid email");
    XCTAssertFalse([@"" isEmail], @"Expected to be an invalid email");
    XCTAssertFalse([@"@b.d" isEmail], @"Expected to be an invalid email");
    
}

- (void) testShouldGenerateMD5Sum{
	XCTAssertEqualObjects([@"password" md5sum], @"5f4dcc3b5aa765d61d8327deb882cf99");
	XCTAssertEqualObjects([@"devin" md5sum], @"11ef1590a74e1ab26c31a4e13f52d71b");
}

- (void) testShouldEncodeString{
	XCTAssertEqualObjects([@"Bob Sanders" URLEncode], @"Bob%20Sanders");
	XCTAssertEqualObjects([@"\"Aardvarks lurk, OK?\"" URLEncode], @"%22Aardvarks%20lurk%2C%20OK%3F%22");
}

- (void) testShouldHaveString{
	
	XCTAssertTrue([@"Bob Sanders" hasString:@"Sanders"]);
	
	XCTAssertFalse([@"Bob Sanders" hasString:@"SANDERS"]);
	XCTAssertFalse([@"Bob Sanders" hasString:@"Cooper"]);
	
}

- (void) testShouldPassCreditCardValidation{
	
	XCTAssertNil([@"12" creditCardType], @"Card number not long enough");
	
	
	XCTAssertEqualObjects([@"12HelloGuys" creditCardType],NSLocalizedString(@"Unknown", @""), @"Not a proper card");

	
	XCTAssertEqualObjects([@"34085943" creditCardType],NSLocalizedString(@"American Express", @"")); // 34 AE
	XCTAssertEqualObjects([@"37085943" creditCardType],NSLocalizedString(@"American Express", @"")); // 37 AE
	XCTAssertEqualObjects([@"378282246310005" creditCardType],NSLocalizedString(@"American Express", @"")); // 37 AE
	XCTAssertEqualObjects([@"371449635398431" creditCardType],NSLocalizedString(@"American Express", @"")); // 37 AE

	XCTAssertEqualObjects([@"36085943" creditCardType],NSLocalizedString(@"Diners Club", @"")); // 36 DC

	XCTAssertEqualObjects([@"38085943" creditCardType],NSLocalizedString(@"Carte Blanche", @"")); //38 CB

	XCTAssertEqualObjects([@"51085943" creditCardType],NSLocalizedString(@"Master Card", @"")); // 50-55 MC
	XCTAssertEqualObjects([@"52085943" creditCardType],NSLocalizedString(@"Master Card", @""));
	XCTAssertEqualObjects([@"55085943" creditCardType],NSLocalizedString(@"Master Card", @""));
	XCTAssertEqualObjects([@"5555555555554444" creditCardType],NSLocalizedString(@"Master Card", @""));
	XCTAssertEqualObjects([@"5105105105105100" creditCardType],NSLocalizedString(@"Master Card", @""));

	
	
	XCTAssertEqualObjects([@"20145943" creditCardType],NSLocalizedString(@"EnRoute", @"")); // 2014 ER
	XCTAssertEqualObjects([@"21495943" creditCardType],NSLocalizedString(@"EnRoute", @"")); // 2149 ER

	XCTAssertEqualObjects([@"18005943" creditCardType],NSLocalizedString(@"JCB", @"")); // 2131 JCB
	XCTAssertEqualObjects([@"21315943" creditCardType],NSLocalizedString(@"JCB", @"")); // 1800 JCB

	XCTAssertEqualObjects([@"60115943" creditCardType],NSLocalizedString(@"Discover", @"")); // 6011 Discover
	XCTAssertEqualObjects([@"6011111111111117" creditCardType],NSLocalizedString(@"Discover", @"")); // 6011 Discover
	XCTAssertEqualObjects([@"6011000990139424" creditCardType],NSLocalizedString(@"Discover", @"")); // 6011 Discover

	XCTAssertEqualObjects([@"30095943" creditCardType],NSLocalizedString(@"Diners Club", @"")); // 300-305 ADC
	XCTAssertEqualObjects([@"30195943" creditCardType],NSLocalizedString(@"Diners Club", @""));
	XCTAssertEqualObjects([@"30595943" creditCardType],NSLocalizedString(@"Diners Club", @""));
	XCTAssertEqualObjects([@"30569309025904" creditCardType],NSLocalizedString(@"Diners Club", @""));

	XCTAssertEqualObjects([@"39595943" creditCardType],NSLocalizedString(@"JCB", @"")); // 3 JCB
	XCTAssertEqualObjects([@"3530111333300000" creditCardType],NSLocalizedString(@"JCB", @"")); // 3 JCB
	XCTAssertEqualObjects([@"3566002020360505" creditCardType],NSLocalizedString(@"JCB", @"")); // 3 JCB

	XCTAssertEqualObjects([@"49595943" creditCardType],NSLocalizedString(@"Visa", @"")); // 4 Visa
	XCTAssertEqualObjects([@"4242424242424242" creditCardType],NSLocalizedString(@"Visa", @""));
	XCTAssertEqualObjects([@"4012888888881881" creditCardType],NSLocalizedString(@"Visa", @""));

}

- (void) testShouldValidateCreditCard{
	
	XCTAssertTrue([@"4242424242424242" isValidCreditCardNumber], @"");
	XCTAssertFalse([@"4242424252424242" isValidCreditCardNumber], @"");

}

- (void) testShouldFormatPhoneString{
		
	NSString *output = [@"2345678901" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"(234) 567-8901");
	
	output = [@"12345678901" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"1 (234) 567-8901");
	
	output = [@"123456789012" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"123456789012");
	
	output = [@"123" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"1 (23)");
	
	output = [@"1234" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"1 (234)");
	
	output = [@"12345" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"1 (234) 5");
	
	output = [@"12345678" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"1 (234) 567-8");
	
	output = [@"529112345678912" formattedPhoneNumberWithLastCharacterRemoved:NO];
	XCTAssertEqualObjects(output, @"529112345678912");

}


@end