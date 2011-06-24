//
//  UIColor+TKCategory.m
//  Created by Devin Ross on 5/14/11.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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

#import "UIColor+TKCategory.h"

@implementation UIColor (TKCategory)

+ (id) colorWithHex:(unsigned int)hex{
	return [UIColor colorWithHex:hex alpha:1.0f];
}
+ (id) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha{
	
	CGFloat red = ((float)((hex & 0xFF0000) >> 16))/255.0f;
	CGFloat green = ((float)((hex & 0xFF00) >> 8))/255.0f;
	CGFloat blue = ((float)(hex & 0xFF))/255.0f;
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
	
}

@end