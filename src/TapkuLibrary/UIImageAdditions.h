//
//  UIImageAdditions.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



@interface UIImage (TKCategory)


+ (UIImage*) imageFromPath:(NSString*)URL;


- (void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color;
- (void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors;

@end

