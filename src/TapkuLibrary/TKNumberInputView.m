//
//  TKNumberInputView.m
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

#import "TKNumberInputView.h"
#import "UIDevice+TKCategory.h"
#import "TKInputKey.h"
#import "TKGlobal.h"

@implementation TKNumberInputView

#define RECT(_X,_Y,_S) CGRectMakeWithSize(_X,_Y,_S)



- (id) initWithFrame:(CGRect)frame withKeysModels:(NSArray*)keys keypadFrame:(CGRect)padFrame{
	frame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIDevice phoneIdiom] ? 216 : 352);
	
	CGFloat w = padFrame.size.width / 3;
	CGFloat h = padFrame.size.height / 4;
	CGFloat pad = 0, xPad = 0, marginX = 0;
	
	
	if([UIDevice padIdiom]){
		w = 108, h = 75, pad = 10, xPad = 16, marginX = 24;
	}
	
	
	CGSize s = CGSizeMake(w,h);
	
	self.oneKey =		[TKInputKey keyWithFrame:RECT( marginX,				pad,		s) symbol:@"1" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.twoKey =		[TKInputKey keyWithFrame:RECT( marginX+w+xPad,		pad,		s) symbol:@"2" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.threeKey =		[TKInputKey keyWithFrame:RECT( marginX+w*2+xPad*2,	pad,		s) symbol:@"3" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.fourKey =		[TKInputKey keyWithFrame:RECT( marginX,				h+pad*2,	s) symbol:@"4" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.fiveKey =		[TKInputKey keyWithFrame:RECT( marginX+w+xPad,		h+pad*2,	s) symbol:@"5" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.sixKey =		[TKInputKey keyWithFrame:RECT( marginX+w*2+xPad*2,	h+pad*2,	s) symbol:@"6" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.sevenKey =		[TKInputKey keyWithFrame:RECT( marginX,				h*2+pad*3,	s) symbol:@"7" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.eightKey =		[TKInputKey keyWithFrame:RECT( marginX+w+xPad,		h*2+pad*3,	s) symbol:@"8" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.nineKey =		[TKInputKey keyWithFrame:RECT( marginX+w*2+xPad*2,	h*2+pad*3,	s) symbol:@"9" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	self.zeroKey =		[TKInputKey keyWithFrame:CGRectMake( marginX,		h*3+pad*4,	w*3+xPad*2,h) symbol:@"0" normalType:TKInputKeyTypeDefault selectedType:TKInputKeyTypeDark runner:YES];
	
	NSMutableArray *ar = [NSMutableArray arrayWithArray:self.keypadKeys];
	[ar addObjectsFromArray:keys];
	
	
	if(!(self=[super initWithFrame:frame withKeysModels:ar])) return nil;
	
	return self;
}
- (NSArray*) keypadKeys{
	return @[self.oneKey,self.twoKey,self.threeKey,self.fourKey,self.fiveKey,self.sixKey,self.sevenKey,self.eightKey,self.nineKey,self.zeroKey];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	if(self.selectedKey && [self.keypadKeys containsObject:self.selectedKey]){
		
		BOOL insert = YES;
		
		if(self.textField.delegate)
			insert = [self.textField.delegate textField:self.textField shouldChangeCharactersInRange:NSMakeRange(self.textField.text.length, 1) replacementString:self.selectedKey.label.text];
		
		if(insert)
			[self.textField insertText:self.selectedKey.label.text];
		
		[super touchesCancelled:touches withEvent:event];
		return;
	}
	
	[super touchesEnded:touches withEvent:event];
	
}


@end
