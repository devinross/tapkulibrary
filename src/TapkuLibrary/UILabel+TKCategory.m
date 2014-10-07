//
//  UILabel+TKCategory.m
//  TapkuLibrary
//
//  Created by Devin Ross on 10/7/14.
//
//

#import "UILabel+TKCategory.h"

@implementation UILabel (TKCategory)

- (void) sizeToFitWithAlignment{
	
	if(self.textAlignment != NSTextAlignmentCenter && self.textAlignment != NSTextAlignmentRight){
		[self sizeToFit];
		return;
	}
	
	CGRect frame = self.frame;
	[self sizeToFit];
	
	CGRect newFrame = self.frame;
	NSInteger xPad = (CGRectGetWidth(frame) - CGRectGetWidth(newFrame));
	if(self.textAlignment == NSTextAlignmentCenter)
		xPad /= 2;
	newFrame.origin.x = CGRectGetMinX(frame) + xPad;
	self.frame = newFrame;

}

- (void) sizeToFitWithAlignmentAndVerticalCentering{
	
	CGRect frame = self.frame;
	[self sizeToFitWithAlignment];
	CGRect newFrame = self.frame;
	NSInteger yPad = (CGRectGetHeight(frame) - CGRectGetHeight(newFrame)) / 2;
	newFrame.origin.y = CGRectGetMinY(frame) + yPad;
	self.frame = newFrame;

}

@end
