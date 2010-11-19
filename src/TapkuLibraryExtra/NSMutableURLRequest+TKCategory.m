//
//  NSMutableURLRequestAdditions.m
//  PhoneHome
//
//  Created by Devin Ross on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableURLRequest+TKCategory.h"
#import "NSDictionary+TKCategory.h"
#import "CJSONSerializer.h"

@implementation NSMutableURLRequest ( TKAdditions )



+ (NSMutableURLRequest*) POSTrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict{
	
	
	NSString *post = [dict formatForHTTP];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	
	return [request autorelease];
}

+ (NSMutableURLRequest*) JSONrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict{
	
	NSString *json = [[CJSONSerializer serializer] serializeDictionary:dict];

	NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [json length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:requestData];

	
	
	return [request autorelease];
}



@end
