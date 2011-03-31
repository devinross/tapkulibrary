//
//  NSMutableURLRequestAdditions.h
//  Created by Devin Ross on 2/23/10.
//

#import <Foundation/Foundation.h>


@interface NSMutableURLRequest ( TKAdditions )

+ (NSMutableURLRequest*) POSTrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict;
+ (NSMutableURLRequest*) JSONrequestWithURL:(NSURL*)url dictionary:(NSDictionary*)dict;

@end
