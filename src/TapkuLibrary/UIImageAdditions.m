//
//  UIImageAdditions.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIImageAdditions.h"
#import "UIViewAdditions.h"

@implementation UIImage (TKCategory)

+ (UIImage*) imageFromPath:(NSString*)URL{
	return 	[UIImage imageWithData:[NSData dataWithContentsOfFile:URL]];
}


- (void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color{
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
	CGContextFillRect(context, rect);
	

	
	CGContextRestoreGState(context);
}


- (void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors{
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	[UIView drawLinearGradientInRect:rect colors:colors];

	

	
	CGContextRestoreGState(context);
	
}



@end
