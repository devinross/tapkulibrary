//
//  UIViewAdditions.m
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
#import "UIView+TKCategory.h"


@implementation UIView (TKCategory)


- (void) addSubviewToBack:(UIView*)view{
	[self insertSubview:view atIndex:0];
}


- (void) roundOffFrame{
	self.frame = CGRectMake(roundf(CGRectGetMinX(self.frame)), roundf(CGRectGetMinY(self.frame)), roundf(CGRectGetWidth(self.frame)), roundf(CGRectGetHeight(self.frame)));
}




- (UIImage*) snapshotImageAfterScreenUpdates:(BOOL)updates{
	
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
	[self drawViewHierarchyInRect:self.bounds  afterScreenUpdates:updates];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}



@end
