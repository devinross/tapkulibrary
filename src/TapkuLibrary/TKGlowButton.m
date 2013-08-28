//
//  TKGlowButton.m
//  TapkuLibrary
//
//  Created by Devin Ross on 8/24/13.
//
//

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
