//
//  NSDictionaryAdditions.h
//  PhoneHome
//
//  Created by Devin Ross on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (TKCategory)

- (NSString *) formatForHTTP;
- (NSString *) formatForHTTPUsingEncoding:(NSStringEncoding)inEncoding;
- (NSString *) formatForHTTPUsingEncoding:(NSStringEncoding)inEncoding ordering:(NSArray *)inOrdering;

@end
