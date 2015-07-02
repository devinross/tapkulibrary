//
//  UIImageAdditions.m
//  Created by Devin Ross on 7/25/09.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

#import "UIImage+TKCategory.h"
#import "TKGlobal.h"
@import Accelerate;
#import <float.h>

@implementation UIImage (Tapku)

+ (UIImage*) imageNamedTK:(NSString*)str{
	
	CGFloat s = 1.0f;
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
		s = [[UIScreen mainScreen] scale];
	}
	NSString *path = [NSString stringWithFormat:@"%@%@.png",str,s > 1 ? @"@2x":@""];
	return [UIImage imageWithCGImage:[UIImage imageWithContentsOfFile:TKBUNDLE(path)].CGImage scale:s orientation:UIImageOrientationUp];

}

@end
