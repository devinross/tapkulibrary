//
//  NSMutableAttributedString+TKCategory.m
//  Created by Devin Ross on 12/16/14.
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

#import "NSMutableAttributedString+TKCategory.h"

@implementation NSMutableAttributedString (TKCategory)

- (void) addTextColor:(UIColor*)color range:(NSRange)range{
	[self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
- (void) addTextColor:(UIColor *)color{
	[self addTextColor:color range:NSMakeRange(0, self.length)];
}

- (void) addFont:(UIFont*)font range:(NSRange)range{
	[self addAttribute:NSFontAttributeName value:font range:range];
}
- (void) addFont:(UIFont*)font{
	[self addFont:font range:NSMakeRange(0, self.length)];
}

- (void) addKerning:(CGFloat)kerning range:(NSRange)range{
	[self addAttribute:NSKernAttributeName value:@(kerning) range:range];
}
- (void) addKerning:(CGFloat)kerning{
	[self addKerning:kerning range:NSMakeRange(0, self.length)];
}

- (void) addLineHeight:(CGFloat)lineHeight range:(NSRange)range{
	NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
	[paragrahStyle setLineSpacing:lineHeight];
	[self addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:range];
}
- (void) addLineHeight:(CGFloat)lineHeight{
	[self addLineHeight:lineHeight range:NSMakeRange(0, self.length)];
}

@end