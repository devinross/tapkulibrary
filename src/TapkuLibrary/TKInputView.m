//
//  TKInputView.m
//  Created by Devin Ross on 3/21/14.
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

#import "TKInputView.h"
#import "UIDevice+TKCategory.h"
#import "UIColor+TKCategory.h"
#import "TKInputKey.h"
#import "UIView+TKCategory.h"
#import "UIImageView+TKCategory.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"

@interface TKInputView ()

@property (nonatomic,strong) NSArray *keyViews;
@property (nonatomic,assign) TKInputKey *originalSelectedKey;
@property (nonatomic,strong) TKInputKey *selectedKey;

@end

@implementation TKInputView

- (id) initWithFrame:(CGRect)frame withKeysModels:(NSArray*)keys{
	
	frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIDevice phoneIdiom] ? 216 : 352);
	
	if(!(self=[super initWithFrame:frame])) return nil;
	
	self.backgroundColor = [UIColor colorWithHex:0xd7dadf];
	self.clipsToBounds = YES;
	self.multipleTouchEnabled = NO;
	self.exclusiveTouch = YES;
	
	
	
	
	CGRect cntFrame = self.bounds;
	self.containerView = [[UIView alloc] initWithFrame:cntFrame];
	
	if([UIDevice padIdiom])
		self.containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	self.containerView.clipsToBounds = YES;
	[self addSubview:self.containerView];
	
	int tag = 0;
	
	CGFloat maxX = 0,minX = CGRectGetWidth(self.containerView.frame);
	
	for(TKInputKey *key in keys){
		
		CGRect r = key.frame;
		r.origin.y++;
		key.frame = r;
		
		minX = MIN(CGRectGetMinX(r),minX);
		maxX = MAX(CGRectGetMaxX(r),maxX);
				
		key.tag = tag;
		[key setHighlighted:NO];
		[self.containerView addSubviewToBack:key];
		tag++;
	}
	
	self.keyViews = keys;
	
	
	if([UIDevice padIdiom]){
		CGRect cntRect = self.containerView.frame;
		cntRect.size.width = maxX + minX;
		cntRect.origin.x = (CGRectGetWidth(self.frame) - cntRect.size.width) / 2.0f;
		self.containerView.frame = cntRect;
		
		self.hideKeyboardKey = [[TKInputKey alloc] initWithFrame:CGRectMake(frame.size.width - 80 - 32, frame.size.height - 75 - 12, 80, 75)
														  symbol:[UIImage imageNamedTK:@"keyboard/down-keyboard"]
													  normalType:TKInputKeyTypeDefault
													selectedType:TKInputKeyTypeHighlighted runner:NO];
		self.hideKeyboardKey.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		self.hideKeyboardKey.tag = tag;
		[self.hideKeyboardKey setHighlighted:NO];
		[self addSubview:self.hideKeyboardKey];
		
		UIImageView *dots = [UIImageView imageViewWithFrame:CGRectMakeWithSize(CGRectGetWidth(frame) - 18, CGRectGetHeight(frame) - 57, dots.frame.size)];
		dots.image = [UIImage imageNamedTK:@"keyboard/move-keyboard-dots"];
		dots.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:dots];
	}
	
	
	
	
	
    return self;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	
	UITouch *touch = [touches anyObject];
	UIView *view = [self hitTest:[touch locationInView:self] withEvent:event];
	
	if(self.selectedKey!=nil){
		
		[self.selectedKey setHighlighted:NO];
		self.originalSelectedKey = nil;
		self.selectedKey = nil;
		
	}
	
	
	if(![view isKindOfClass:[TKInputKey class]])
		return;
	
	
	[[UIDevice currentDevice] playInputClick];
	
	
	self.originalSelectedKey = (TKInputKey*)view;
	self.selectedKey = self.originalSelectedKey;
	[self.selectedKey setHighlighted:YES];
	[self.containerView bringSubviewToFront:self.selectedKey];
	
	
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	
	
	UIView *view = [self hitTest:[touch locationInView:self] withEvent:event];
	
	TKInputKey *currentKey = nil;
	
	
	if([view isKindOfClass:[TKInputKey class]])
		currentKey = (TKInputKey*)view;
	
	
	
	BOOL on = NO;
	
	if(self.originalSelectedKey == currentKey)
		on = YES;
	else if(self.originalSelectedKey.runner && currentKey.runner)
		on = YES;
	
	
	if(self.selectedKey != currentKey){
		[self.selectedKey setHighlighted:NO];
		self.selectedKey = nil;
	}
	
	if(on){
		self.selectedKey = currentKey;
		[self.containerView bringSubviewToFront:self.selectedKey];
		[self.selectedKey setHighlighted:YES];
	}
	
	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	
	if(self.selectedKey == self.backspaceKey){
		
		
		
		BOOL delete = YES;
		
		if(self.textField.delegate && [self.textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
			delete = [self.textField.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(self.textField.text.length-1, 0) replacementString:@""];
		
		if(delete)
			[self.textField deleteBackward];
		
		
	}else if(self.selectedKey){
		
		[self.delegate inputView:self didSelectKey:self.selectedKey];
		
	}
	
	
	[self touchesCancelled:touches withEvent:event];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	
	[self.selectedKey setHighlighted:NO];
	self.selectedKey = nil;
	self.originalSelectedKey = nil;
	
}
- (BOOL) enableInputClicksWhenVisible{
    return YES;
}

@end