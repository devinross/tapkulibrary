//
//  TKIndicatorCell.m
//  Created by Devin Ross on 7/4/09.
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

#import "TKIndicatorCell.h"
#import "UIView+TKCategory.h"

static UIFont *textFont = nil;
static UIFont *indicatorFont = nil;
static UIColor *indicatorColor = nil;
static UIColor *indicatorBackgroundColor = nil;


@implementation TKIndicatorCell
@synthesize text = _text, count = _count;


+ (void) initialize{
	if(self == [TKIndicatorCell class])
	{
		textFont = [UIFont boldSystemFontOfSize:18];
		indicatorFont = [UIFont boldSystemFontOfSize:16];
		indicatorColor = [UIColor whiteColor];
		indicatorBackgroundColor = [UIColor colorWithRed:140/255.0 green:153/255.0 blue:180/255.0 alpha:1.0];

	}
}


- (void) setText:(NSString*)s{
	_text = [s copy];
	[self setNeedsDisplay];
}
- (void) setCount:(int)s{
	if(s==_count) return;
	if(s > 99 && _count < 100){
		indicatorFont = [UIFont boldSystemFontOfSize:12.0];
	}else if(s < 100 && _count > 99){
		indicatorFont = [UIFont boldSystemFontOfSize:16.0];
	}
	_count = s;
	_countStr = [NSString stringWithFormat:@"%d",s];
	[self setNeedsDisplay];
}


- (void) drawContentView:(CGRect)r{

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected || self.highlighted ? [UIColor clearColor] : [UIColor whiteColor];
	UIColor *textColor = self.selected || self.highlighted ? [UIColor whiteColor] : [UIColor blackColor];
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	
	CGRect rect = CGRectInset(r, 12, 12);
	rect.size.width -= 45;
	
	if(self.editing){
		rect.origin.x += 30;
	}
	
	
	[textColor set];
	
	[_text drawInRect:rect withFont:textFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if(_count > 0 && !self.editing){
		
		
		[indicatorBackgroundColor set];
		CGRect rr = CGRectMake(rect.size.width+ rect.origin.x, 12, 30,20);
		[UIView drawRoundRectangleInRect:rr withRadius:10];
		

		
		if(_count > 99) rr.origin.y += 2;
		
		[indicatorColor set];
		[_countStr drawInRect:rr withFont:indicatorFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
					   
					   
	}
	
	
}

- (void) willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	[self setNeedsDisplay];
}

@end




