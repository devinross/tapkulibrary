//
//  TKInputKey.m
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

#import "TKInputKey.h"
#import "UIColor+TKCategory.h"
#import "UIDevice+TKCategory.h"
#import "TKGlobal.h"
#import "UIFont+TKCategory.h"

@implementation TKInputKey

+ (id) keyWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner{
	return [[TKInputKey alloc] initWithFrame:frame symbol:symbol normalType:normal selectedType:highlighted runner:runner];
}

- (id) initWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner{
	if(!(self=[super initWithFrame:frame])) return nil;
	
	if([UIDevice padIdiom]){
		
		self.layer.cornerRadius = 5;
		self.layer.shadowRadius = 0;
		self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
		self.layer.shadowOpacity = 1;
		self.layer.shadowOffset = CGSizeMake(0, 1);
	}else{
		
		UIView *line;
		
		line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
		line.backgroundColor = [UIColor colorWithHex:0xcfd1d5];
		line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
		[self addSubview:line];
		
		line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-1, 0, 1, frame.size.height)];
		line.backgroundColor = [UIColor colorWithHex:0xcfd1d5];
		line.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
		[self addSubview:line];
	}
	
	
	
	
	if([symbol isKindOfClass:[NSString class]]){
		
		CGRect bounds = frame;
		bounds.origin = CGPointZero;
		
		self.label = [[UILabel alloc] initWithFrame:CGRectInset(bounds, 5, 5)];
		self.label.font = [UIFont helveticaNeueLightWithSize:30];
		self.label.textAlignment = NSTextAlignmentCenter;
		self.label.backgroundColor = [UIColor clearColor];
		self.label.adjustsFontSizeToFitWidth = YES;
		self.label.text = symbol;
		[self addSubview:self.label];
		
	}else if([symbol isKindOfClass:[UIImage class]]){
		
		
		self.symbol = [[UIImageView alloc] initWithImage:(UIImage*)symbol];
		self.symbol.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
		
		NSInteger w = (CGRectGetWidth(self.frame) - CGRectGetWidth(self.symbol.frame)) / 2;
		NSInteger h = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.symbol.frame)) / 2;
		
		self.symbol.frame = CGRectMakeWithSize(w, h, self.symbol.frame.size);
		
		self.symbol.center = CGPointMake(self.frame.size.width/2., self.frame.size.height/2.);
		self.symbol.frame = CGRectIntegral(self.symbol.frame);
		[self addSubview:self.symbol];
		
	}
	
	self.normalType = normal;
	self.highlighedType = highlighted;
	self.runner = runner;
	
    return self;
}
- (void) setHighlighted:(BOOL)highlighted{
	
	TKInputKeyType type = highlighted ? self.highlighedType : self.normalType;
	
	if(type == TKInputKeyTypeDark || type == TKInputKeyTypeDefault){
		
		self.label.textColor = [UIColor blackColor];
		
		
		if(type == TKInputKeyTypeDark)
			self.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
		else
			self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
		self.symbol.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
		self.symbol.image = self.symbol.image;
		
	}else if(type == TKInputKeyTypeHighlighted){
		
		self.symbol.tintColor = [UIColor whiteColor];
		self.symbol.image = [self.symbol.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.label.textColor = [UIColor whiteColor];
		self.backgroundColor = [UIColor colorWithHex:0x4185f4];
	}
	
}
- (void) setNormalType:(TKInputKeyType)normalType{
	_normalType = normalType;
	[self setHighlighted:NO];
}


- (void) layoutSubviews{
	[super layoutSubviews];
	
	self.label.frame = CGRectInset(self.bounds, 5, 5);
	self.symbol.center = CGPointMake(self.frame.size.width/2., self.frame.size.height/2.);
	self.symbol.frame = CGRectIntegral(self.symbol.frame);
}


- (NSString*) description{
	return [NSString stringWithFormat:@"<%@ %@>",NSStringFromClass([self class]),self.label.text];
}
@end
