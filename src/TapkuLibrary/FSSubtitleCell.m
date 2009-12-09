//
//  FSSubtitleCell.m
//  Created by Devin Ross on 7/20/09.
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

#import "FSSubtitleCell.h"




@implementation FSSubtitleCell
@synthesize title, subtitle;

static UIFont *titlefont = nil;
static UIFont *subtitlefont = nil;


+ (void)initialize
{
	if(self == [FSSubtitleCell class])
	{
		titlefont = [[UIFont boldSystemFontOfSize:18] retain];
		subtitlefont = [[UIFont boldSystemFontOfSize:13] retain];
	}
}


- (void) setTitle:(NSString*)s{
	[title release];
	title = [s copy];
	[self setNeedsDisplay];
}

- (void) setSubtitle:(NSString*)s{
	[subtitle release];
	subtitle = [s copy];
	[self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	UIColor *subtitleColor = [UIColor grayColor];
	
	
	
	if(self.selected || self.highlighted){
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
		subtitleColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	
	CGRect rect = CGRectInset(r, 12, 12);
	

	
	rect.size.width -= 90;
	
	if(self.editing){
		rect.origin.x += 30;
		rect.size.width -= 30;
	}
	
	if((!self.editing && self.accessoryType != UITableViewCellAccessoryNone) || (self.editing && self.editingAccessoryType != UITableViewCellAccessoryNone)){
		rect.size.width -= 20;
	}
	
	
	[textColor set];
	
	[title drawInRect:rect withFont:titlefont lineBreakMode:UILineBreakModeTailTruncation];
	
	//CGContextFillRect(context, rect);
	rect.origin.x += rect.size.width;

	rect.size.width = 90;
	[subtitleColor set];
	[subtitle drawInRect:rect withFont:subtitlefont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	//CGContextFillRect(context, rect);
	
	
}



- (void)dealloc {
	[title release];
	[subtitle release];
    [super dealloc];
}


@end
