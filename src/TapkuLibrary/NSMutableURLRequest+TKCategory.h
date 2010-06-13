//
//  NSMutableURLRequestAdditions.h
//  PhoneHome
//
//  Created by Devin Ross on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableURLRequest ( TKAdditions )

+ (NSMutableURLRequest*) POSTrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict;
+ (NSMutableURLRequest*) JSONrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict;

@end
