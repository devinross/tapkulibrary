//
//  TKGlobal.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKGlobal.h"


@implementation TKGlobal


+ (NSString*) fullBundlePath:(NSString*)bundlePath{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundlePath];
}



@end
