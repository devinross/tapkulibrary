//
//  TKPageControl.m
//  Created by Devin Ross on 12/22/14.
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

#import "TKPageControl.h"

@interface TKPageControl ()

@property (nonatomic,strong) NSArray *dots;
@property (nonatomic,strong) NSMutableArray *images;

@end


#define DEFAULT_DOT_RADIUS 4
#define DOT_DIAMETER self.dotRadius * 2
#define BOUNCE 5
#define DEFAULT_SPACE 20

@implementation TKPageControl

- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	self.images = [NSMutableArray array];
	_dotRadius = DEFAULT_DOT_RADIUS;
	_spaceBetweenDots = DEFAULT_SPACE;
	return self;
}

- (void) _configure{
	NSInteger i = 0;
	for(UIImageView *dot in self.dots){
		if(self.images[i] == [NSNull null]){
			dot.backgroundColor = _currentPage == i ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
			dot.image = nil;
		}else{
			dot.image = [(UIImage*)self.images[i] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			dot.backgroundColor = [UIColor clearColor];
			dot.tintColor = _currentPage == i ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
			
		}
		i++;
	}
}
- (void) _setup{
	[self.dots makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSInteger start = (CGRectGetWidth(self.frame) - (DOT_DIAMETER + (_numberOfPages-1) * self.spaceBetweenDots))/2;
	NSInteger y = (CGRectGetHeight(self.frame) - DOT_DIAMETER) / 2;
	
	NSMutableArray *dots = [NSMutableArray arrayWithCapacity:_numberOfPages];
	for(NSInteger i=0;i<self.numberOfPages;i++){
		UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectMake(self.spaceBetweenDots * i + start, y, DOT_DIAMETER, DOT_DIAMETER)];
		page.backgroundColor = [UIColor blackColor];
		page.layer.cornerRadius = self.dotRadius;
		page.contentMode = UIViewContentModeCenter;
		[self addSubview:page];
		[dots addObject:page];
	}
	
	self.dots = dots.copy;
	
	
	self.currentPage = self.currentPage;
	
}

- (void) setCurrentPage:(NSInteger)currentPage{
	_currentPage = currentPage;
	[self _configure];
}
- (void) setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated{
	
	currentPage = MIN(_numberOfPages-1,currentPage);
	currentPage = MAX(0,currentPage);
	
	if(!animated){
		self.currentPage = currentPage;
		return;
	}
	
	NSInteger oldPage = _currentPage;
	_currentPage = currentPage;
	
	
	UIImageView *oldDot = oldPage < self.dots.count ? self.dots[oldPage] : nil;
	UIImageView *selected = self.dots[_currentPage];
	CGPoint center = selected.center;
	CGPoint prevCenter = oldDot.center;
	
	CGPoint oldCenter = oldDot.center;
	CGFloat duration = 0.4;
	
	
	if(oldPage+1 != _currentPage && oldPage-1 != _currentPage){
		
		[UIView beginAnimations:nil context:nil];
		oldDot.backgroundColor = oldDot.image ? [UIColor clearColor] : self.pageIndicatorTintColor;
		oldDot.tintColor = self.pageIndicatorTintColor;
		selected.backgroundColor = selected.image ? [UIColor clearColor] : self.currentPageIndicatorTintColor;
		selected.tintColor = self.currentPageIndicatorTintColor;
		[UIView commitAnimations];
		
		return;
	}
	
	
	
	CGFloat prev = oldCenter.x > center.x ? (CGRectGetMaxX(selected.frame) + self.dotRadius) : (CGRectGetMinX(selected.frame) - self.dotRadius);
	
	[UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
		[UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
			oldDot.center = CGPointMake(prev, center.y);
		}];
		[UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
			
			
			oldDot.backgroundColor = oldDot.image ? [UIColor clearColor] : self.pageIndicatorTintColor;
			oldDot.tintColor = self.pageIndicatorTintColor;
			
			selected.backgroundColor = selected.image ? [UIColor clearColor] : self.currentPageIndicatorTintColor;
			
			selected.tintColor = self.currentPageIndicatorTintColor;
			
		}];
		[UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
			CGFloat x = center.x > oldCenter.x ? BOUNCE : -BOUNCE;
			selected.center = CGPointMake(center.x + x, selected.center.y);
		}];
		[UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.2 animations:^{
			CGFloat x = center.x < oldCenter.x ? BOUNCE : -BOUNCE;
			selected.center = CGPointMake(center.x + x/2, selected.center.y);
		}];
		[UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.1 animations:^{
			selected.center = center;
		}];
		[UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4 animations:^{
			oldDot.center = prevCenter;
		}];
	} completion:nil];
	
}

- (void) setNumberOfPages:(NSInteger)numberOfPages{
	_numberOfPages = numberOfPages;
	
	for(NSInteger i=self.dots.count;i<numberOfPages;i++){
		[self.images addObject:[NSNull null]];
	}
	
	[self _setup];
}
- (void) setImage:(UIImage *)image forPage:(NSInteger)page{
	
	if(image==nil)
		[self.images replaceObjectAtIndex:page withObject:[NSNull null]];
	else
		[self.images replaceObjectAtIndex:page withObject:image];
	
	[self _configure];
}


#pragma mark Visual Properties
- (void) setDotRadius:(CGFloat)dotRadius{
	_dotRadius = dotRadius;
	[self _setup];
}
- (void) setSpaceBetweenDots:(CGFloat)spaceBetweenDots{
	_spaceBetweenDots = spaceBetweenDots;
	[self _setup];
}
- (void) setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
	_currentPageIndicatorTintColor = currentPageIndicatorTintColor;
	[self _configure];
}
- (void) setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
	_pageIndicatorTintColor = pageIndicatorTintColor;
	[self _configure];
}

@end
