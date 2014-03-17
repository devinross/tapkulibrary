//
//  TKRetroButton.m
//  Created by Devin Ross on 6/22/13.
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

#import "TKRetroButton.h"

@implementation TKRetroButton

- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
	self.borderWidth = 2;
	self.insetWidth = self.borderWidth * 2.5;
	self.layer.contentsScale = [UIScreen mainScreen].scale;
    return self;
}




- (void) drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGColorRef strokeColor;
	CGColorRef fillColor;
	
	switch (self.state) {
		case UIControlStateHighlighted:
		case UIControlStateSelected:
			strokeColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
			fillColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
			break;
		case UIControlStateDisabled:
			strokeColor = [self titleColorForState:UIControlStateDisabled] ? [self titleColorForState:UIControlStateDisabled].CGColor : [UIColor blackColor].CGColor;
			fillColor = [self titleColorForState:UIControlStateDisabled] ? [self titleColorForState:UIControlStateDisabled].CGColor : [UIColor blackColor].CGColor;
			break;
		default:
			strokeColor = [self titleColorForState:UIControlStateNormal] ? [self titleColorForState:UIControlStateNormal].CGColor : [UIColor blackColor].CGColor;
			fillColor = [UIColor clearColor].CGColor;
			break;
	}
	
	CGContextSetFillColorWithColor(ctx, fillColor);
	CGContextSetStrokeColorWithColor(ctx, strokeColor);
	CGContextSaveGState(ctx);
    
	CGContextSetLineWidth(ctx, self.borderWidth);
	
	UIBezierPath *outlinePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.borderWidth, self.borderWidth) cornerRadius:(CGRectGetHeight(self.bounds)-2)/2];
	
	CGContextAddPath(ctx, outlinePath.CGPath);
	CGContextStrokePath(ctx);
	
	CGContextRestoreGState(ctx);
	
	if (self.highlighted || self.selected) {
		CGContextSaveGState(ctx);
		UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.insetWidth, self.insetWidth) cornerRadius:CGRectGetHeight(self.bounds)/2];
		
		CGContextAddPath(ctx, fillPath.CGPath);
		CGContextFillPath(ctx);
		
		CGContextRestoreGState(ctx);
	}
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self setNeedsDisplay];
}

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

- (void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self setNeedsDisplay];
}

- (void) setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (void) setBorderWidth:(CGFloat)borderWidth{
	_borderWidth = borderWidth;
	[self setNeedsDisplay];
}
- (void) setInsetWidth:(CGFloat)insetWidth{
	_insetWidth = insetWidth;
	[self setNeedsDisplay];
}


@end
