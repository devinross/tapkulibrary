//
//  TKExtendedScrollView.m
//  Created by Devin Ross on 12/7/14.
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

#import "TKExtendedScrollView.h"

@implementation TKExtendedScrollView

- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	self.clipsToBounds = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.pagingEnabled = YES;
	return self;
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	UIView *view = [super hitTest:point withEvent:event];
	if(view) return view;
	
	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneX && self.extensionPlane & TKExtendedScrollViewExtensionPlaneY) return self;
	
	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneX && (point.y < 0 || point.y > self.frame.size.height)) return nil;
	
	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneY && (point.x < 0 || point.x > self.frame.size.width)) return nil;

	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneNone) return nil;
	
	return self;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	CGRect newBounds = self.bounds;
	
	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneX)
		newBounds = CGRectInset(newBounds, -100, 0.0f);
	
	if(self.extensionPlane & TKExtendedScrollViewExtensionPlaneY)
		newBounds = CGRectInset(newBounds, 0, -100.0f);
	
	return CGRectContainsPoint(newBounds, point);
}


@end
