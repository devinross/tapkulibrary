//
//  TKGlobal.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:_URL]

@interface TKGlobal : NSObject {

}


+ (NSString*) fullBundlePath:(NSString*)bundlePath;


@end
