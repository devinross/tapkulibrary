//
//  QuartzDrawing.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuartzDrawing : NSObject {

}

+ (void) drawLinearGradientWithFrame:(CGRect)rect colors:(CGFloat[])colors;
+ (void) drawLineWithFrame:(CGRect)rect colors:(CGFloat[])colors;

@end
