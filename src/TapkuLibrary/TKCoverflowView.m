//
//  TKCoverflowView.m
//  Created by Devin Ross on 11/15/12.
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

#import "TKCoverflowView.h"
#import "UIImageView+TKCategory.h"
#import "TKGradientView.h"
#import "TKGlobal.h"

@interface TKCoverflowView (){
	
	NSMutableArray *_covers,*_grayard;
	NSRange _range;
	NSUInteger _numberOfCovers,_currentIndex;
	UIView *currentTouch;
	BOOL isDragging, gliding, animate;
	CGSize _originalBoundsSize;
	
}

@end

#define DEFAULT_COVER_SIZE 224.0f

#pragma mark - TKCoverflowView
@implementation TKCoverflowView

#pragma mark Init
- (id) initWithFrame:(CGRect)frame{
	self = [self initWithFrame:frame deleclerationRate:UIScrollViewDecelerationRateFast];
	self.decelerationRate = UIScrollViewDecelerationRateFast;
	return self;
}
- (id) initWithFrame:(CGRect)frame deleclerationRate:(CGFloat)decelerationRate{
	if(!(self=[super initWithFrame:frame])) return nil;
	
	@try {
		[self setValue:[NSValue valueWithCGSize:CGSizeMake(decelerationRate,decelerationRate)] forKey:@"_decelerationFactor"];
	}@catch (NSException *exception) {
		// if they modify the way it works under us.
	}
	
	self.backgroundColor = [UIColor blackColor];
	_range = NSMakeRange(0,0);
	_numberOfCovers = 0;
	_covers = [NSMutableArray array];
	self.delegate = self;
	self.multipleTouchEnabled = NO;
	self.contentInset = UIEdgeInsetsMake(0,CGRectGetWidth(self.bounds)/2.0,0,CGRectGetWidth(self.bounds)/2.0);
	self.contentOffset = CGPointMake(-self.contentInset.left, 0);
	
	self.rightIncrementalDistanceFromCenter = self.leftIncrementalDistanceFromCenter = 80;

	self.showsHorizontalScrollIndicator = NO;
	//self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	
	CGFloat x = DEFAULT_COVER_SIZE / 2;
	
	self.leftTransform = CATransform3DMakeRotation(80 * M_PI / 180.0, 0, 1, 0);
	self.leftTransform = CATransform3DConcat(self.leftTransform, CATransform3DMakeTranslation(-x, 0, -200));
	
	self.rightTransform = CATransform3DMakeRotation(-80 * M_PI / 180.0, 0, 1, 0);
	self.rightTransform = CATransform3DConcat(self.rightTransform, CATransform3DMakeTranslation(x, 0, -200));

	self.coverSize = CGSizeMake(DEFAULT_COVER_SIZE, DEFAULT_COVER_SIZE);
	self.spacing = DEFAULT_COVER_SIZE - 50;
	
	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.001;
	[self.layer setSublayerTransform:sublayerTransform];

	return self;
}


#pragma mark Layout Subviews
- (void) layoutSubviews{
	
	if(self.contentInset.left != CGRectGetWidth(self.bounds)/2.0){
		self.contentInset = UIEdgeInsetsMake(0,CGRectGetWidth(self.bounds)/2.0,0,CGRectGetWidth(self.bounds)/2.0);
		
		[UIView beginAnimations:nil context:nil];
		
		for(UIView *active in self.visibleCovers)
			active.center = CGPointMake(active.center.x, CGRectGetHeight(self.frame)/2.0f);
		
		[UIView commitAnimations];
		
	}
	
	/*
	if(_originalBoundsSize.width != CGRectGetWidth(self.frame)){
	
		_originalBoundsSize.width = CGRectGetWidth(self.frame);
		BOOL ani = _range.length > 0 ? YES : NO;
		NSInteger c = _currentIndex;
		self.userInteractionEnabled = NO;
		
		[UIView animateWithDuration:ani ? 0.1 : 0.0 animations:^{
			for(UIView *v in self.subviews)
				v.alpha = 0;
		} completion:^(BOOL finished){
			[self reloadData];
			[self setCurrentCoverAtIndex:c animated:NO];
			[UIView animateWithDuration:ani ? 0.3 : 0.0 animations:^{
				for(UIView *v in self.subviews)
					v.alpha = 1;
			} completion:^(BOOL finished){
				self.userInteractionEnabled = YES;				
			}];
		}];
	}
	*/
	
	[self _setupTiles];
	[self _realignCovers:animate];
	animate = YES;
}

- (void) _setupTiles{
	
	NSRange newRange = [self _currentRange];
	if(NSEqualRanges(newRange, _range)) return;
	
	if(_range.location < newRange.location){
		for(NSInteger i=_range.location;i<newRange.location;i++){
			UIView *v = _covers[i];
			if((NSObject*) v == [NSNull null]) continue;
			[_grayard addObject:v];
			_covers[i] = [NSNull null];
			[v removeFromSuperview];
		}
	}
	
	NSInteger cnt = _covers.count;
	if(_range.location+_range.length > newRange.location+newRange.length){
		for(NSInteger i=newRange.location+newRange.length;i<_range.location+_range.length;i++){
			if(i >= cnt || _covers[i] == [NSNull null]) continue;
			UIView *v = _covers[i];
			[v removeFromSuperview];
			[_grayard addObject:v];
			_covers[i] = [NSNull null];
		}
	}
	
	
	CGFloat y = rintf((CGRectGetHeight(self.bounds) - self.coverSize.height) / 2.0);
	for(NSInteger i=newRange.location;i<newRange.location+newRange.length;i++){
		if(_covers[i] != [NSNull null]) continue;
			
		TKCoverflowCoverView *cover = [self.coverflowDataSource coverflowView:self coverForIndex:i];
		
		//cover.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		cover.frame = CGRectMakeWithSize(rintf([self _centerXPositionForCoverAtIndex:i]-self.coverSize.width/2.0), y, cover.frame.size);
		cover.layer.transform = [self _transformForViewAtIndex:i];
		cover.userInteractionEnabled = YES;
		cover.tag = i;
		[self addSubview:cover];
		[self sendSubviewToBack:cover];
		_covers[i] = cover;
	}
	
	
	_range = newRange;
	
	
}
- (void) _realignCovers:(BOOL)animated{
	
	NSInteger newIndex = [self _calculatedIndexWithContentOffset:self.contentOffset];
	newIndex = MAX(0,MIN(_numberOfCovers-1,newIndex));
	if(_currentIndex == newIndex) return;
	_currentIndex = newIndex;
	

	
	if(_range.length<1) return;
	NSString *ID = [NSString stringWithFormat:@"%@",@(_currentIndex)];
	
	
	
	[UIView beginAnimations:ID context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:animated ? 0.22f : 0.0f];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	NSInteger start = _range.location;
	NSInteger end = _range.location + _range.length;
	
	for(NSInteger x=start;x<end;x++ ){
		UIView *v = _covers[x];
		v.layer.transform = [self _transformForViewAtIndex:x];
	}
	
	[UIView commitAnimations];

	
}
- (void) _adjustViewHeirarchy{
	if(_range.length<1) return;
	
	
	NSInteger start = _range.location;
	NSInteger end = _range.location +_range.length;
	
	for(NSInteger x=_currentIndex-1;x>=start;x-- ){
		UIView *v = _covers[x];
		if((NSObject*)v == [NSNull null]) continue;
		[self sendSubviewToBack:v];
	}
	
	for(NSInteger x=_currentIndex+1;x<end;x++ ){
		UIView *v = _covers[x];
		if((NSObject*)v == [NSNull null]) continue;
		[self sendSubviewToBack:v];
	}
	
}
- (void) _clearCoversFromView{
	
	for(NSInteger i=_range.location;i<_range.length+_range.location;i++){
		if(_covers[i] == [NSNull null]) continue;
		
		UIView *v = _covers[i];
		[_grayard addObject:v];
		_covers[i] = [NSNull null];
		[v removeFromSuperview];
	}
	
}
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	
	if([finished boolValue] && [animationID intValue] == _currentIndex && [self.coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasBroughtToFront:)])
		[self.coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:_currentIndex];
	
}


#pragma mark Private Property Methods
- (CATransform3D) _transformForViewAtIndex:(NSInteger)i{
	
	CATransform3D trans = CATransform3DIdentity;
	NSInteger ii = abs((int)(i-_currentIndex));
	
	if(i<_currentIndex)
		trans = CATransform3DConcat(self.leftTransform, CATransform3DMakeTranslation(0, 0, -self.leftIncrementalDistanceFromCenter * ii));
	else if(i>_currentIndex)
		trans = CATransform3DConcat(self.rightTransform, CATransform3DMakeTranslation(0, 0, -self.rightIncrementalDistanceFromCenter * ii));
	
	
	//trans = CATransform3DIdentity;
	return trans;
	
}
- (NSInteger) _calculatedIndexWithContentOffset:(CGPoint)point{
	
	point.x += self.contentInset.left;
	
	CGFloat per = point.x / self.contentSize.width;
	CGFloat ind = _numberOfCovers * per;
	CGFloat mi = ind / (_numberOfCovers/2);
	mi = 1 - mi;
	mi = mi / 2;
	NSInteger index = (int)(ind+mi);
	
	index = MIN(MAX(0,index),_numberOfCovers-1);
	return index;
}
- (CGFloat) _centerXPositionForCoverAtIndex:(NSInteger)index{
	return (self.coverSize.width-self.spacing)*index;
}
- (NSRange) _currentRange{
		
	CGPoint p = self.contentOffset;
	p.x -= self.contentInset.left;
	
	NSInteger s = [self _calculatedIndexWithContentOffset:p]-5;
	NSInteger start = MAX(0,s);
	p.x += CGRectGetWidth(self.bounds);
	
	
	NSInteger max = _numberOfCovers;
	NSInteger e = [self _calculatedIndexWithContentOffset:p]+5;
	NSInteger end = MAX(0,MIN(max,e));
	return NSMakeRange(start, MAX(0,end - start));
}


#pragma mark Touch Events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	
	if(touch.view != self &&  [touch locationInView:touch.view].y < self.coverSize.height){
		currentTouch = touch.view;
	}
	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	
	
	if(touch.view == currentTouch){
		if(touch.tapCount > 0 && _currentIndex == [_covers indexOfObject:currentTouch]){
			
			if([self.coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasTappedInFront:tapCount:)])
				[self.coverflowDelegate coverflowView:self coverAtIndexWasTappedInFront:_currentIndex tapCount:touch.tapCount];
			
		}else{
			NSInteger index = [_covers indexOfObject:currentTouch];
			CGFloat x = [self _centerXPositionForCoverAtIndex:index] - (CGRectGetWidth(self.bounds) / 2.0f);
			[self setContentOffset:CGPointMake(x, 0) animated:YES];
		}
		
		
	}
	currentTouch = nil;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(currentTouch!= nil) currentTouch = nil;
}


#pragma mark UIScrollViewDelegate methods
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	isDragging = YES;
	gliding = NO;
	[self setNeedsLayout];
}
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocityTangent targetContentOffset:(inout CGPoint *)targetContentOffset{
	
	NSInteger i = [self _calculatedIndexWithContentOffset:*targetContentOffset];
	*targetContentOffset = CGPointMake([self _centerXPositionForCoverAtIndex:i] - self.contentInset.left, 0);
	
	isDragging = NO;
	gliding = YES;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_adjustViewHeirarchy) object:nil];
	
	[self performSelector:@selector(_adjustViewHeirarchy) withObject:nil afterDelay:0.3];
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(!decelerate){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_adjustViewHeirarchy) object:nil];
		[self performSelector:@selector(_adjustViewHeirarchy) withObject:nil afterDelay:0.3];
	}
	
	isDragging = NO;

}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_adjustViewHeirarchy) object:nil];

	[self performSelector:@selector(_adjustViewHeirarchy) withObject:nil afterDelay:0.3];
}


#pragma mark Properties & Public Methods
- (void) setCoverSize:(CGSize)coverSize{
	_coverSize = coverSize;
	if(self.coverflowDataSource) [self reloadData];
}
- (NSArray*) visibleCovers{
	return [_covers subarrayWithRange:_range];
}
- (TKCoverflowCoverView*) coverAtIndex:(NSInteger)index{
	id ret = _covers[index];
	return ret != [NSNull null] ? ret : nil;
}
- (NSInteger) currentIndex{
	return _currentIndex;
}
- (NSRange) visibleRange{
	return _range;
}
- (void) setCoverflowDataSource:(id<TKCoverflowViewDataSource>)coverflowDataSource{
	_coverflowDataSource = coverflowDataSource;
	[self reloadData];
}
- (TKCoverflowCoverView*) dequeueReusableCoverView{
	
	if([_grayard count] < 1)  return nil;
	
	TKCoverflowCoverView *v = [_grayard lastObject];
	v.layer.transform = CATransform3DIdentity;
	[v.layer removeAllAnimations];
	[_grayard removeLastObject];
	
	return v;
	
}
- (void) reloadData{
	_originalBoundsSize = self.bounds.size;

	if(_range.length>0) [self _clearCoversFromView];
	[_covers removeAllObjects];
	_range = NSMakeRange(0,0);
	
	self.contentSize = CGSizeZero;
	self.contentOffset = CGPointZero;
	
	if(self.coverflowDataSource==nil){
		_numberOfCovers = 0;
		return;
	}
	
	_numberOfCovers = [self.coverflowDataSource numberOfCoversInCoverflowView:self];
	
	for(NSInteger i=0;i<_numberOfCovers;i++)
		[_covers addObject:[NSNull null]];
	

	CGFloat xx =  [self _centerXPositionForCoverAtIndex:_numberOfCovers-1];
	self.contentInset = UIEdgeInsetsMake(0,CGRectGetWidth(self.bounds)/2.0,0,CGRectGetWidth(self.bounds)/2.0);
	self.contentSize = CGSizeMake(xx,0);
	
	
	animate = NO;
	[self setNeedsLayout];
	[self _adjustViewHeirarchy];
	

}
- (void) setCurrentCoverAtIndex:(NSInteger)index animated:(BOOL)animated{
	CGFloat x = [self _centerXPositionForCoverAtIndex:index] - (CGRectGetWidth(self.bounds) / 2.0f);
	animate = animated;
	[self setContentOffset:CGPointMake(x, 0) animated:animated];
	[self _realignCovers:animated];
	[self setNeedsLayout];
	if([self.coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasBroughtToFront:)])
		[self.coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:_currentIndex];
	
}
- (void) setCurrentCoverAtIndex:(NSInteger)index{
	[self setCurrentCoverAtIndex:index animated:NO];
}
- (NSInteger) currentCoverIndex{
	return _currentIndex;
}

@end


#pragma mark - TKCoverflowCoverView
@implementation TKCoverflowCoverView

- (id) initWithFrame:(CGRect)frame reflection:(BOOL)reflection{
	if(!(self=[super initWithFrame:frame])) return nil;
	self.imageView = [UIImageView imageViewWithFrame:self.bounds];
	[self addSubview:self.imageView];
	
	if(reflection){
		CGRect r = self.bounds;
		r.origin.y = r.size.height;
		self.reflectedImageView = [UIImageView imageViewWithFrame:r];
		self.reflectedImageView.transform = CGAffineTransformMakeScale(1, -1);
		[self addSubview:self.reflectedImageView];
		
		
		self.reflectionGradientView = [[TKGradientView alloc] initWithFrame:r];
		
		self.reflectionGradientView.colors = @[[UIColor colorWithWhite:0 alpha:0.7],[UIColor colorWithWhite:0 alpha:1]];
		self.reflectionGradientView.locations = @[@0.0f,@0.4f];
		[self addSubview:self.reflectionGradientView];

	}
	
    return self;
}
- (id) initWithFrame:(CGRect)frame {
	self = [self initWithFrame:frame reflection:YES];
	return self;
}
- (BOOL) hasRelection{
	return self.reflectedImageView != nil;
}
- (void) setImage:(UIImage*)image{
	self.imageView.image = image;
	self.reflectedImageView.image = image;
}

@end