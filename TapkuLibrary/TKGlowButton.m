//
//  TKGlowButton.m
//  Created by Devin Ross on 8/24/13.
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

#import "TKGlowButton.h"

@interface TKGlowButton (){
	UIColor *normalBackgroundColor, *selectedBackgroundColor, *highlightedBackgroundColor;
}
@end

@implementation TKGlowButton

- (void) setBackgroundColor:(UIColor*)color forState:(UIControlState)state{
	
	if(state == UIControlStateNormal){
		normalBackgroundColor = color;
		self.backgroundColor = color;
	}else if(state == UIControlStateHighlighted){
		highlightedBackgroundColor = color;
	}else if(state == UIControlStateSelected){
		selectedBackgroundColor = color;
	}
	
}


- (void) setSelected:(BOOL)selected{
	[super setSelected:selected];
	
	UIColor *clr = [UIColor clearColor];
	
	if(selected && selectedBackgroundColor)
		clr = selectedBackgroundColor;
	else if(!selected && normalBackgroundColor)
		clr = normalBackgroundColor;
	
	[UIView beginAnimations:nil context:nil];
	self.backgroundColor = clr;
	[UIView commitAnimations];
	
}

- (void) setHighlighted:(BOOL)highlighted{
	[super setHighlighted:highlighted];
	
	UIColor *clr = [UIColor clearColor];
	
	if(highlighted && highlightedBackgroundColor)
		clr = highlightedBackgroundColor;
	else if(!highlighted && normalBackgroundColor)
		clr = normalBackgroundColor;
	
	[UIView beginAnimations:nil context:nil];
	self.backgroundColor = clr;
	[UIView commitAnimations];
	
}

@end
