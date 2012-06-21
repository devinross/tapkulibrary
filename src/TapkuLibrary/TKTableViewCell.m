//
//  TKTableViewCell.m
//  Created by Devin Ross on 3/31/11.
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

#import "TKTableViewCell.h"

@interface TKTableViewCellView : UIView
@end

@implementation TKTableViewCellView

- (void) drawRect:(CGRect)r{
	[(TKTableViewCell *)[self superview] drawContentView:r];
}

@end



@implementation TKTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    _mainView = [[TKTableViewCellView alloc] initWithFrame:CGRectZero];
    _mainView.opaque = YES;
    [self addSubview:_mainView];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}

- (void) layoutSubviews{
	[super layoutSubviews];
	self.contentView.hidden = YES;
	[self.contentView removeFromSuperview];
	[self setNeedsDisplay];
}
- (void) setFrame:(CGRect)f{
	[super setFrame:f];
	_mainView.frame = CGRectMake(0,0,f.size.width,f.size.height-1);
	[_mainView setNeedsDisplay];
}
- (void) setNeedsDisplay{
	[super setNeedsDisplay];
	[_mainView setNeedsDisplay];
}
- (void) setNeedsDisplayInRect:(CGRect)rect{
	[super setNeedsDisplayInRect:rect];
	[_mainView setNeedsDisplayInRect:rect];
}

- (void) drawContentView:(CGRect)r { 
	// for subclassing
	// default implementation does nothing
}

@end
