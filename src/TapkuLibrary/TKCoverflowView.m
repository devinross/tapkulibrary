//
//  TKCoverflowView.m
//  Created by Devin Ross on 1/3/10.
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

#import "TKCoverflowView.h"
#import "TKCoverflowCoverView.h"
#import "TKGlobal.h"

#define COVER_SPACING 70.0
#define CENTER_COVER_OFFSET 70
#define SIDE_COVER_ANGLE 1.4
#define SIDE_COVER_ZPOSITION -80
#define COVER_SCROLL_PADDING 4
#define COVER_SCROLL_PADDING 4
#define FRONT_SPACE 300.0

#pragma mark -
@interface TKCoverflowView (hidden)

- (void) animateToIndex:(int)index animated:(BOOL)animated;
- (void) _load;
- (void) _setup;
- (void) newrange;
- (void) _setupTransforms;
- (void) adjustViewHeirarchy;
- (void) deplaceAlbumsFrom:(int)start to:(int)end;
- (void) deplaceAlbumsAtIndex:(int)cnt;
- (BOOL) placeAlbumsFrom:(int)start to:(int)end;
- (void) placeAlbumAtIndex:(NSInteger)cnt;
- (void) snapToAlbum:(BOOL)animated;

@end

#pragma mark -
@implementation TKCoverflowView

#pragma mark Initialize
- (id) initWithFrame:(CGRect)frame {
	if(!(self=[super initWithFrame:frame])) return nil;
	[self _load];
    return self;
}
- (void) awakeFromNib{
    [self _load];
}

#pragma mark Setup
- (void) _setupTransforms{

	leftTransform = CATransform3DMakeRotation(_coverAngle, 0, 1, 0);
	leftTransform = CATransform3DConcat(leftTransform,CATransform3DMakeTranslation(-spaceFromCurrent, 0, -self.spaceInFront));
	
	rightTransform = CATransform3DMakeRotation(-_coverAngle, 0, 1, 0);
	rightTransform = CATransform3DConcat(rightTransform,CATransform3DMakeTranslation(spaceFromCurrent, 0, -self.spaceInFront));
	
}
- (void) _load{
	self.backgroundColor = [UIColor blackColor];
	_numberOfCovers = 0;
	_coverSpacing = COVER_SPACING;
	_coverAngle = SIDE_COVER_ANGLE;
	self.spaceInFront = FRONT_SPACE;
	self.showsHorizontalScrollIndicator = NO;
	super.delegate = self;
	
	yard = [[NSMutableArray alloc] init];
	views = [[NSMutableArray alloc] init];
	
	_coverSize = CGSizeMake(224, 224);
	spaceFromCurrent = _coverSize.width/2.4;
	[self _setupTransforms];


	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.001;
	[self.layer setSublayerTransform:sublayerTransform];
	
	currentIndex = -1;
	
	
}
- (void) _setup{

	currentIndex = -1;
	for(UIView *v in views) [v removeFromSuperview];
	[yard removeAllObjects];
	[views removeAllObjects];
	coverViews = nil;
	
	if(_numberOfCovers < 1){
		self.contentOffset = CGPointZero;
		return;
	} 
	
	
	coverViews = [[NSMutableArray alloc] initWithCapacity:_numberOfCovers];
	for (unsigned i = 0; i < _numberOfCovers; i++) [coverViews addObject:[NSNull null]];
	deck = NSMakeRange(0, 0);
	
	CGSize size = self.frame.size;
	margin = (self.frame.size.width / 2);
	self.contentSize = CGSizeMake( (_coverSpacing) * (_numberOfCovers-1) + (margin*2) , size.height);
	coverBuffer = (int) ((size.width - _coverSize.width) / _coverSpacing) + 3;
	

	movingRight = YES;
	currentIndex = 0;
	movingIndex = 0;
	self.contentOffset = CGPointZero;


	[self newrange];
	[self animateToIndex:currentIndex animated:NO];
	
	
	boundSize = self.frame.size;
}


#pragma mark Manage Visible Covers
- (void) deplaceAlbumsFrom:(int)start to:(int)end{
	if(start >= end) return;
	
	for(int cnt=start;cnt<end;cnt++)
		[self deplaceAlbumsAtIndex:cnt];

}
- (void) deplaceAlbumsAtIndex:(int)cnt{
	if(cnt >= [coverViews count]) return;
	
	if([coverViews objectAtIndex:cnt] != [NSNull null]){
		
		UIView *v = [coverViews objectAtIndex:cnt];
		[v removeFromSuperview];
		[views removeObject:v];
		[yard addObject:v];
		[coverViews replaceObjectAtIndex:cnt withObject:[NSNull null]];
		
	}
}
- (BOOL) placeAlbumsFrom:(int)start to:(int)end{
	if(start >= end) return NO;
	
	
	for(int cnt=start;cnt<= end;cnt++) 
		[self placeAlbumAtIndex:cnt];
	
	return YES;
}
- (void) placeAlbumAtIndex:(NSInteger)index{
	if(index >= [coverViews count]) return;
	
	if([coverViews objectAtIndex:index] == [NSNull null]){
		
		TKCoverflowCoverView *cover = [self.dataSource coverflowView:self coverAtIndex:index];
		cover.transform = CGAffineTransformIdentity;
		[coverViews replaceObjectAtIndex:index withObject:cover];
		
		[cover.layer removeAllAnimations];

		
		CGSize size = self.frame.size;

		
		CGRect r = cover.frame;
		r.origin.y = size.height/2 - (_coverSize.height/2) - (_coverSize.height/16);
		r.origin.x = (size.width/2 - (_coverSize.width/ 2)) + (_coverSpacing) * index;
		cover.frame = r;


		
		CATransform3D tr = CATransform3DIdentity;
	
		if(index < movingIndex)
			tr = leftTransform;
		
		else if(index > movingIndex){
			tr = rightTransform;
			[self sendSubviewToBack:cover];
			
		}
		
		
		cover.layer.transform = tr;
		
		[self addSubview:cover];
		[views addObject:cover];
		
	}
}

#pragma mark Manage Range and Animations
- (void) newrange{
	
	int loc = deck.location, len = deck.length, buff = coverBuffer;
	int newLocation = currentIndex - buff < 0 ? 0 : currentIndex-buff;
	int newLength = currentIndex + buff > _numberOfCovers ? _numberOfCovers - newLocation : currentIndex + buff - newLocation;
	
	if(loc == newLocation && newLength == len) return;
	
	if(movingRight){
		[self deplaceAlbumsFrom:loc to:MIN(newLocation,loc+len)];
		[self placeAlbumsFrom:MAX(loc+len,newLocation) to:newLocation+newLength];
	}else{
		[self deplaceAlbumsFrom:MAX(newLength+newLocation,loc) to:loc+len];
		[self placeAlbumsFrom:newLocation to:newLocation+newLength];
	}
	
	NSRange spectrum = NSMakeRange(0, _numberOfCovers);
	deck = NSIntersectionRange(spectrum, NSMakeRange(newLocation, newLength));
	
		
}
- (void) adjustViewHeirarchy{
	
	int i = currentIndex-1;
	if (i >= 0) 
		for(;i > deck.location;i--) 
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
	
	i = currentIndex+1;
	if(i<_numberOfCovers-1)
		for(;i < deck.location+deck.length;i++) 
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
	
	UIView *v = [coverViews objectAtIndex:currentIndex];
	if((NSObject*)v != [NSNull null])
		[self bringSubviewToFront:[coverViews objectAtIndex:currentIndex]];
	
	
}

- (void) snapToAlbum:(BOOL)animated{
	
	UIView *v = [coverViews objectAtIndex:currentIndex];
	
	if((NSObject*)v!=[NSNull null]){
		CGSize size = self.frame.size;
		[self setContentOffset:CGPointMake(v.center.x - (size.width/2), 0) animated:animated];
	}else{		
		[self setContentOffset:CGPointMake(_coverSpacing*currentIndex, 0) animated:animated];
	}
	
}
- (void) animateToIndex:(int)index animated:(BOOL)animated{
	NSString *ID = [NSString stringWithFormat:@"%d",index];
	//if(velocity>200) animated = NO;
	
		
	if(animated){
		//float speed = 0.2;
		//if(velocity>80)speed=0.05;
		[UIView beginAnimations:ID context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)]; 
	}

	for(UIView *v in views){
		int i = [coverViews indexOfObject:v];
		if(i < index) v.layer.transform = leftTransform;
		else if(i > index) v.layer.transform = rightTransform;
		else v.layer.transform = CATransform3DIdentity;
	}
	
	if(animated) [UIView commitAnimations];
	else [self.coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:currentIndex];

}
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{

	
	if(![finished boolValue]) return;
	

	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adjustViewHeirarchy) object:nil];
	[self performSelector:@selector(adjustViewHeirarchy) withObject:nil afterDelay:0.3f];
	
	if([animationID intValue] == movingIndex)
		[self.coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:movingIndex];
	
}




#pragma mark View Bounds
- (void) _adjustToBounds{
	
	
	CGSize size = self.frame.size;

	margin = (self.frame.size.width / 2);
	self.contentSize = CGSizeMake( (_coverSpacing) * (_numberOfCovers-1) + (margin*2) , self.frame.size.height);
	coverBuffer = (int)((size.width - _coverSize.width) / _coverSpacing) + 3;
	
	
	for(UIView *v in views){
		v.layer.transform = CATransform3DIdentity;
		CGRect r = v.frame;
		r.origin.y = size.height / 2 - (_coverSize.height/2) - (_coverSize.height/16);
		v.frame = r;
	}
	
	for(int i= deck.location; i < deck.location + deck.length; i++){
		if([coverViews objectAtIndex:i] != [NSNull null]){
			UIView *cover = [coverViews objectAtIndex:i];
			CGRect r = cover.frame;
			r.origin.x = (size.width/2 - (_coverSize.width/ 2)) + (_coverSpacing) * i;
			cover.frame = r;
		}
	}
	
	[self newrange];
	[self animateToIndex:currentIndex animated:NO];
}
- (void) setFrame:(CGRect)frame{
	[super setFrame:frame];
	[self _adjustToBounds];
}
- (void) setBounds:(CGRect)bounds{
	[super setBounds:bounds];
	if(boundSize.width == bounds.size.width && boundSize.height == bounds.size.height) return;
	[self _adjustToBounds];
}


- (NSInteger) calculatedIndexWithContentOffset:(CGPoint)point{
	CGSize size = self.frame.size;
	CGFloat per = point.x / (self.contentSize.width - size.width);
	CGFloat ind = _numberOfCovers * per;
	CGFloat mi = ind / (_numberOfCovers/2);
	mi = 1 - mi;
	mi = mi / 2;
	int index = (int)(ind+mi);
	index = MIN(MAX(0,index),_numberOfCovers-1);
	return index;
}

- (void) layoutSubviews{
	
	velocity = abs(pos-self.contentOffset.x);
	movingRight = self.contentOffset.x - pos > 0 ? YES : NO;
	pos = self.contentOffset.x;

	
	
	

	
	NSInteger index = [self calculatedIndexWithContentOffset:self.contentOffset];
	NSInteger oldIndex = movingIndex;
	currentIndex=index;

	
	[CATransaction begin];
	[CATransaction setAnimationDuration:0];
	[self newrange];
	[CATransaction commit];

	
	
	if(!gliding || isDragging){
		movingIndex = index;
		
		if(oldIndex!=movingIndex)
			[self animateToIndex:movingIndex animated:YES];

	}else{
		[self animateToIndex:movingIndex animated:YES];
	}
	
	

}


#pragma mark Public Methods
- (TKCoverflowCoverView *) coverAtIndex:(int)index{
	if(index<0 || index >= coverViews.count) return nil;
	
	if([coverViews objectAtIndex:index] != [NSNull null]) 
		return [coverViews objectAtIndex:index];
	return nil;
}

- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated{
	if(index == currentIndex) return;
	
    currentIndex = index;
    [self snapToAlbum:animated];
	[self newrange];
	[self animateToIndex:index animated:animated];
}
- (TKCoverflowCoverView*) dequeueReusableCoverView{
	
	if([yard count] < 1)  return nil;
	
	TKCoverflowCoverView *v = [yard lastObject];
	v.layer.transform = CATransform3DIdentity;
	[v.layer removeAllAnimations];
	[yard removeLastObject];
	
	return v;
}

#pragma mark Touch Events
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];

	
	if(touch.view != self &&  [touch locationInView:touch.view].y < _coverSize.height){
		currentTouch = touch.view;
	}

}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if(touch.view == currentTouch){
		if(touch.tapCount > 0 && currentIndex == [coverViews indexOfObject:currentTouch]){
			
			if([self.coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasTappedInFront:tapCount:)])
				[self.coverflowDelegate coverflowView:self coverAtIndexWasTappedInFront:currentIndex tapCount:touch.tapCount];
			
		}else{
			int index = [coverViews indexOfObject:currentTouch];
			[self setContentOffset:CGPointMake(_coverSpacing*index, 0) animated:YES];
		}
	}
	
	currentTouch = nil;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(currentTouch!= nil) currentTouch = nil;
}

#pragma mark UIScrollView Delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	isDragging = YES;
	gliding = NO;
	[self setNeedsLayout];
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	isDragging = NO;
}
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocityTangent targetContentOffset:(inout CGPoint *)targetContentOffset{
	
	
	NSInteger i = [self calculatedIndexWithContentOffset:*targetContentOffset];
	*targetContentOffset = CGPointMake(_coverSpacing * i, 0);
	
	if(fabs(velocityTangent.x)<2.0f) return;
	
	isDragging = NO;
	gliding = YES;
	movingIndex = i;
	
}


#pragma mark Properties
- (void) setNumberOfCovers:(int)cov{
	_numberOfCovers = cov;
	[self _setup];
}
- (void) setCoverSpacing:(float)space{
	_coverSpacing = space;
	[self _setupTransforms];
	[self _setup];
	[self layoutSubviews];
}
- (void) setSpaceInFront:(float)front{
	_spaceInFront = front;
	[self _setupTransforms];
	[self _setup];
	[self layoutSubviews];
}
- (void) setCoverAngle:(float)f{
	_coverAngle = f;
	[self _setupTransforms];
	[self _setup];
}
- (void) setCoverSize:(CGSize)s{
	_coverSize = s;
	spaceFromCurrent = _coverSize.width/2.4;
	[self _setupTransforms];
	[self _setup];
}
- (void) setCurrentIndex:(NSInteger)index{
	[self bringCoverAtIndexToFront:index animated:NO];
}
- (NSInteger) currentIndex{
	return movingIndex;
}


- (NSArray*) visibleCovers{
	return [coverViews subarrayWithRange:deck];
}
- (NSRange) visibleRange{
	return deck;
}

@end