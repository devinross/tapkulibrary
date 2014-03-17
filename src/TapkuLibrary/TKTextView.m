//
//  TKTextView.m
//  Created by Devin Ross on 5/18/13.
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

#import "TKTextView.h"

@implementation TKTextView


#pragma mark Init & Friends
- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	[self _setupView];
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder{
	if(!(self=[super initWithCoder:aDecoder])) return nil;
	[self _setupView];
    return self;
}
- (void) awakeFromNib{
    [super awakeFromNib];
	[self _setupView];
}
- (void) _setupView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}
- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) drawRect:(CGRect)rect{
	[super drawRect:rect];
	
	
	if(_placeHolderLabel){
		if(self.placeHolderLabel.superview==nil){
			[self addSubview:self.placeHolderLabel];
			[self sendSubviewToBack:self.placeHolderLabel];
		}
		
		if([self respondsToSelector:@selector(textContainer)])
			self.placeHolderLabel.frame = CGRectMake(4, self.textContainerInset.top, CGRectGetWidth(self.bounds) - 8, 0);
		else
			self.placeHolderLabel.frame = CGRectMake(8,8,CGRectGetWidth(self.bounds) - 16,0);
		
		
		
		
		[self.placeHolderLabel sizeToFit];
		
	}
    
	_placeHolderLabel.alpha = self.text.length < 1 ? 1 : 0;
	
}


- (void) _textChanged:(NSNotification *)notification{
    if(self.placeholder.length == 0) return;
	_placeHolderLabel.alpha = self.text.length < 1 ? 1 : 0;
}


#pragma mark Properties
- (void) setFont:(UIFont *)font{
	[super setFont:font];
	self.placeHolderLabel.font = font;
	[self setNeedsDisplay];
}
- (void) setText:(NSString *)text{
    [super setText:text];
    [self _textChanged:nil];
}
- (void) setPlaceholder:(NSString *)placeholder{
	
	if(placeholder.length < 1){
		_placeHolderLabel.text = placeholder;
		[self setNeedsDisplay];
		return;
	}
	
	self.placeHolderLabel.text = placeholder;
	[self setNeedsDisplay];
}
- (NSString*) placeholder{
	return _placeHolderLabel.text;
}
- (void) setPlaceholderColor:(UIColor *)placeholderColor{
	self.placeHolderLabel.textColor = placeholderColor;
	[self setNeedsDisplay];
}
- (UIColor*) placeholderColor{
	return _placeHolderLabel.textColor;
}
- (UILabel*) placeHolderLabel{
	if(_placeHolderLabel) return _placeHolderLabel;
	
	_placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,CGRectGetWidth(self.bounds) - 16,0)];
	_placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
	_placeHolderLabel.numberOfLines = 0;
	_placeHolderLabel.font = self.font;
	_placeHolderLabel.backgroundColor = [UIColor clearColor];
	_placeHolderLabel.textColor = [UIColor lightGrayColor];
	
	
	if([self respondsToSelector:@selector(textContainer)]){
		
		_placeHolderLabel.textColor = [UIColor colorWithWhite:0.80 alpha:1];
		_placeHolderLabel.frame = CGRectMake(2, 8, CGRectGetWidth(self.bounds) - 8, 0);
		
	}
	
	
	
	
	_placeHolderLabel.alpha = 0;
	return _placeHolderLabel;
}

@end
