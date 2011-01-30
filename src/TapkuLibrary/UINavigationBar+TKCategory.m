//
//  UINavigationBar+TKCategory.m
//  Created by Devin Ross on 11/24/10.
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

#import "UINavigationBar+TKCategory.h"
#import "UIView+TKCategory.h"

@implementation UINavigationBar (TKCategory)


- (void)TKdrawRect:(CGRect)rect {
	
	if (self.barStyle == UIBarStyleDefault) {
		
		NSArray *colors = [NSArray arrayWithObjects:
						   [UIColor colorWithRed:176/255.0 green:188/255.0 blue:204/255.0 alpha:1],
						   [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1],nil];
		
		[UIView drawGradientInRect:rect withColors:colors];
	
		[[UIColor colorWithRed:45/255.0 green:54/255.0 blue:66/255.0 alpha:1] set];
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, rect.size.height-1, rect.size.width, 1));
	
		[[UIColor colorWithRed:205/255.0 green:213/255.0 blue:223/255.0 alpha:1] set];
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, rect.size.width, 1));
	
	
		[[UIColor colorWithRed:158/255.0 green:173/255.0 blue:193/255.0 alpha:1] set];
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, rect.size.height-2, rect.size.width, 1));
	

        return;
    }
	
    // Call default implementation
	[self TKdrawRect:rect];
}




@end
