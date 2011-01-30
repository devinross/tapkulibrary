//
//  TKBarButtonItem.m
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

#import "TKBarButtonItem.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"

@implementation TKBarButtonItem

- (UIImage*) imageForStyle:(TKBarButtonItemStyle)s{
	NSString *imageName;
	NSString *scale = [[UIScreen mainScreen] scale] > 1 ? @"@2x" : @"";
	
	
	
	switch (s) {
		case TKBarButtonItemStyleBack:
			imageName = @"ui back button";
			break;
		case TKBarButtonItemStyleDone:
			imageName = @"ui done button";
			break;
		default:
			imageName = @"ui plain button";
			break;
	}
	
	NSString *url = [NSString stringWithFormat:@"TapkuLibrary.bundle/Images/gui/%@%@.png",imageName,scale];
	
	
	UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithContentsOfFile:TKBUNDLE(url)].CGImage 
									   scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp]; 


	return [img stretchableImageWithLeftCapWidth:24 topCapHeight:0];
}
- (UIImage*) hoverImageForStyle:(TKBarButtonItemStyle)s{
	
	NSString *imageName;
	NSString *scale = [[UIScreen mainScreen] scale] > 1 ? @"@2x" : @"";
	

	switch (s) {
		case TKBarButtonItemStyleBack:
			imageName = @"ui back button hover";
			break;
		default:
			imageName = @"ui plain button hover";
			break;
	}
	
	NSString *url = [NSString stringWithFormat:@"TapkuLibrary.bundle/Images/gui/%@%@.png",imageName,scale];
	
	UIImage *img = [UIImage imageWithCGImage:[UIImage imageWithContentsOfFile:TKBUNDLE(url)].CGImage 
									   scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp]; 
	
	
	return [img stretchableImageWithLeftCapWidth:24 topCapHeight:0];
}
- (UIEdgeInsets) insetForStyle:(TKBarButtonItemStyle)s{
	
	UIEdgeInsets e;
	
	switch (s) {
		case TKBarButtonItemStyleBack:
			e = UIEdgeInsetsMake(0, 14, 2, 6);
			break;
		default:
			e = UIEdgeInsetsMake(0, 8, 2, 8);
			break;
	}
	
	return e;
	
}
- (UIEdgeInsets) insetForImageWithStyle:(TKBarButtonItemStyle)s{
	UIEdgeInsets e;
	
	switch (s) {
		case TKBarButtonItemStyleBack:
			e = UIEdgeInsetsMake(0, 12, 2, 8);
			break;
		default:
			e = UIEdgeInsetsMake(0, 8, 2, 8);
			break;
	}
	
	return e;
	
}

- (void) setupButtonWithStyle:(TKBarButtonItemStyle)s{


	UIImage *glyph = [_buttonContainer imageForState:UIControlStateNormal];

	
	if(!glyph){
		UIEdgeInsets e = [self insetForStyle:s];
		_buttonContainer.titleEdgeInsets = e;
		NSString *ti = [_buttonContainer titleForState:UIControlStateNormal];
		CGSize size = [ti sizeWithFont:_buttonContainer.titleLabel.font forWidth:200 lineBreakMode:UILineBreakModeTailTruncation];
		_buttonContainer.frame = CGRectMake(_buttonContainer.frame.origin.x, _buttonContainer.frame.origin.y, size.width + e.left + e.right, 30);
	
	}else{
		UIEdgeInsets e = [self insetForImageWithStyle:s];
		_buttonContainer.imageEdgeInsets = e;
		_buttonContainer.frame = CGRectMake(_buttonContainer.frame.origin.x, _buttonContainer.frame.origin.y, glyph.size.width + e.left + e.right, 30);
	}
	
	UIImage *img = [self imageForStyle:s];
	
	//[_buttonContainer setImage:img forState:UIControlStateNormal];
	[_buttonContainer setBackgroundImage:img forState:UIControlStateNormal];
	[_buttonContainer setBackgroundImage:[self hoverImageForStyle:s] forState:UIControlStateHighlighted];
	_buttonContainer.showsTouchWhenHighlighted = NO;
	_buttonContainer.adjustsImageWhenHighlighted = NO;
	

}


- (id) initWithTitle:(NSString*)_title style:(TKBarButtonItemStyle)s target:(id)t action:(SEL)a{
	if(!(self = [super initWithCustomView:nil])) return nil;
	
	self.title = _title;
	
	
	_buttonContainer = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_buttonContainer.frame = CGRectMake(0, 0, 30, 30);
	

	_buttonContainer.titleLabel.textColor = [UIColor whiteColor];
	_buttonContainer.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	_buttonContainer.titleLabel.shadowColor = [UIColor blackColor];
	_buttonContainer.titleLabel.shadowOffset = CGSizeMake(0, -1);
	_buttonContainer.titleLabel.backgroundColor = [UIColor clearColor];
	_buttonContainer.showsTouchWhenHighlighted = NO;
	_buttonContainer.adjustsImageWhenHighlighted = NO;

	
	[_buttonContainer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_buttonContainer setTitle:_title forState:UIControlStateNormal];
	[_buttonContainer addTarget:t action:a forControlEvents:UIControlEventTouchUpInside];
	
	[self setupButtonWithStyle:s];
	
	self.customView = _buttonContainer;

	
	_style = s;

	
	return self;
}
- (id) initWithImage:(UIImage*)img style:(TKBarButtonItemStyle)s target:(id)t action:(SEL)a{
	
	if(!(self = [super initWithCustomView:nil])) return nil;
	
	_buttonContainer = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_buttonContainer.frame = CGRectMake(0, 0, 30, 30);
	
	[_buttonContainer setImage:img forState:UIControlStateNormal];
	[_buttonContainer addTarget:t action:a forControlEvents:UIControlEventTouchUpInside];
	[self setupButtonWithStyle:s];
		
	self.customView = _buttonContainer;
	
	_style = s;
	
	
	return self;
}

- (void) setTarget:(id)target{
	return;
}
- (void) setAction:(SEL)a{
	return;
}
- (id) target{
	NSSet *set = [_buttonContainer allTargets];
	if([set count] < 1) return nil;
	return  [[_buttonContainer allTargets] anyObject];
}
- (SEL) action{
	return NSSelectorFromString([[_buttonContainer actionsForTarget:[[_buttonContainer allTargets] anyObject] forControlEvent:UIControlEventTouchUpInside] lastObject]);
}
- (void) setTarget:(id)tt action:(SEL)aa{
	
	id t = [self target];
	if(t != nil){
		SEL act =  NSSelectorFromString([[_buttonContainer actionsForTarget:[[_buttonContainer allTargets] anyObject] forControlEvent:UIControlEventTouchUpInside] lastObject]);
		[_buttonContainer removeTarget:t action:act forControlEvents:UIControlEventTouchUpInside];
	}
	
	
	[_buttonContainer addTarget:tt action:aa forControlEvents:UIControlEventTouchUpInside];
}
- (TKBarButtonItemStyle) buttonStyle{
	return _style;
}
- (void) setButtonStyle:(TKBarButtonItemStyle)s{
	_style = s;
	[self setupButtonWithStyle:s];
}


- (void) dealloc{
	[_buttonContainer release];
	[super dealloc];
}

@end
