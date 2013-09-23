//
//  TKSlideToUnlockView.m
//  Created by Devin Ross on 5/21/13.
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

#import "TKSlideToUnlockView.h"
#import "UIImageView+TKCategory.h"
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"
#import "UIGestureRecognizer+TKCategory.h"
#import "TKShimmerLabel.h"


@interface CustomScrollView : UIScrollView

@end

@implementation CustomScrollView

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesEnded:touches withEvent:event];
}

@end


#define TRACK_PADDING 4.0
#define SLIDER_VIEW_WIDTH 82.0f
#define FADE_TEXT_OVER_LENGTH 50.0f

@implementation TKSlideToUnlockView

#pragma mark Init & Friends
- (id) init{
	CGRect frame = CGRectInset(CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 62), 15, 0) ;
	self = [self initWithFrame:frame];
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	frame.size.height = 62;
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
	[self _setupView];
}
- (void) _setupView{
	
	
	self.backgroundView = [UIImageView imageViewWithFrame:self.bounds];
	self.backgroundView.layer.cornerRadius = 5;
	self.backgroundView.clipsToBounds = YES;
	[self addSubview:self.backgroundView];


	self.scrollView = [[CustomScrollView alloc] initWithFrame:self.bounds];
	self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*2, 0);
	self.scrollView.backgroundColor = [UIColor colorWithRed:233/255.0f green:52/255.0f blue:41/255.0f alpha:0.7];
	self.scrollView.layer.cornerRadius = 5;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.delegate = self;
	self.scrollView.delaysContentTouches = NO;
	[self addSubview:self.scrollView];
	
	self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
	
	
	UIImage *arrow = [UIImage imageNamedTK:@"unlockslider/arrow"];
	UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
	arrowView.center = CGPointMake(CGRectGetWidth(self.scrollView.frame) + 25, CGRectGetHeight(self.scrollView.frame)/2.0f);
	[self.scrollView addSubview:arrowView];
	
	
	CGRect textFrame = self.scrollView.bounds;
	textFrame.origin.x = CGRectGetWidth(self.scrollView.frame);
	textFrame = CGRectInset(textFrame, 40, 10);
	
	
	self.textLabel = [[TKShimmerLabel alloc] initWithFrame:textFrame];
	self.textLabel.text = NSLocalizedString(@"slide to unlock", @"Slide to Unlock");
	self.textLabel.textColor = [UIColor whiteColor];
	self.textLabel.font = [UIFont systemFontOfSize:25];
	self.textLabel.userInteractionEnabled = NO;
	[self.scrollView addSubview:self.textLabel];
	


}


- (void) renderScreen{
	self.alpha = 0;
	
	
	CGPoint p = [self convertPoint:self.superview.bounds.origin fromView:self.superview];
	
	UIGraphicsBeginImageContextWithOptions(self.backgroundView.frame.size, NO, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, p.x, p.y);
	[self.superview.layer renderInContext:context];
	
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	CGContextRestoreGState(context);
	UIGraphicsEndImageContext();
	
	newImage = [newImage imageByApplyingBlurWithRadius:2 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
	
	
	
	self.backgroundView.image = newImage;
	self.alpha = 1;
}

- (void) layoutSubviews {
	[self renderScreen];
}


- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	if(scrollView.contentOffset.x == 0){
		_isUnlocked = YES;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	[self _resetShimmer];

}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if(!decelerate)
		[self _resetShimmer];
}


- (void) resetSlider:(BOOL)animated{
	[self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:animated];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	id white = (id)[UIColor whiteColor].CGColor;
	self.textLabel.textHighlightLayer.colors = @[white,white,white,white,white];
}


- (void) _resetShimmer{
	[self layoutSubviews];
	id dark = (id)[UIColor colorWithWhite:1 alpha:0.40].CGColor;
	id light = (id)[UIColor colorWithWhite:1 alpha:1.0f].CGColor;
	self.textLabel.textHighlightLayer.colors = @[dark,dark,light,dark,dark];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self _resetShimmer];
}





@end
