//
//  TKPegSlider.m
//  Created by Devin Ross on 6/30/14.
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

#import "TKPegSlider.h"
#import "TKGlobal.h"

#define SCALE_DOWN CGScale(0.18,0.18)
#define OFF_PEG_ALPHA 0.5f

@interface TKPegSlider ()

@property (nonatomic,strong) NSArray *pegs;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

@end


@implementation TKPegSlider

- (id) init{
	self = [self initWithFrame:CGRectZero];
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	frame.size = CGSizeMake(300, 40);
	if(!(self=[super initWithFrame:frame])) return nil;
	self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
	self.clipsToBounds = NO;
	self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
	
	self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, 40, 40), 6, 6)];
	[self addSubview:self.leftImageView];
	
	self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(CGRectGetWidth(self.frame)-40, 0, 40, 40), 6, 6)];
	[self addSubview:self.rightImageView];
	
	_numberOfPegs = 3;
	_selectedPegIndex = 0;
	[self _setupPegs];
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	[self addGestureRecognizer:pan];
	
    return self;
}




- (void) _setupPegs{
	NSMutableArray *pegReserves = [NSMutableArray array];
	[pegReserves addObjectsFromArray:self.pegs];
	[self.pegs makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	if(_numberOfPegs == 0) return;
	
	CGFloat leftPad = 16 +  (self.leftImageView.image ? 40 : 3);
	CGFloat rightPad = 16 + (self.rightImageView.image ? 40 : 3);
	CGFloat per = (CGRectGetWidth(self.frame)-leftPad-rightPad)  / (_numberOfPegs-1);
	
	NSMutableArray *pegs = [NSMutableArray arrayWithCapacity:_numberOfPegs];
	
	for(NSInteger i = 0; i < _numberOfPegs; i++){
		
		UIView *peg;
		if(pegReserves.count > 0){
			peg = [pegReserves lastObject];
			[pegReserves removeLastObject];
		}else{
			peg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
			peg.layer.cornerRadius = CGRectGetHeight(peg.frame)/2;
		}
		
		peg.backgroundColor = self.tintColor;
		peg.tag = i;
		peg.alpha = _selectedPegIndex == i ? 1 : OFF_PEG_ALPHA;
		peg.transform = _selectedPegIndex == i ? CGAffineTransformIdentity : SCALE_DOWN;
		
		CGFloat x = leftPad + per * i;
		peg.center = CGPointMake(x, CGRectGetHeight(self.frame)/2);
		[pegs addObject:peg];
		[self addSubview:peg];
		
	}
	
	self.pegs = pegs.copy;

}
- (void) tintColorDidChange{
	[super tintColorDidChange];
	[self _setupPegs];
	self.leftImageView.tintColor = self.rightImageView.tintColor = self.tintColor;
	
}

- (NSInteger) _indexOfSelectAtPoint:(CGFloat)point{
	CGFloat leftPad = 16 +  (self.leftImageView.image ? 40 : 3);
	CGFloat rightPad = 16 + (self.rightImageView.image ? 40 : 3);
	CGFloat per = (CGRectGetWidth(self.frame)-leftPad-rightPad)  / (_numberOfPegs-1);
	NSInteger index = (point+(per/2)-leftPad) / per;
	index = MAX(0,index);
	return MAX(0,MIN(_numberOfPegs-1,index));
}
- (void) pan:(UIPanGestureRecognizer*)gesture{
	CGPoint p = [gesture locationInView:self];
	NSInteger index = [self _indexOfSelectAtPoint:p.x];
		
	[UIView beginAnimations:nil context:nil];
	NSInteger i = 0;
	for(UIView *peg in self.pegs){
		peg.alpha = i == index ? 1 : OFF_PEG_ALPHA;
		peg.transform = i == index ? CGAffineTransformIdentity : SCALE_DOWN;
		i++;
	}
	[UIView commitAnimations];
	
	if(index!= _selectedPegIndex){
		_selectedPegIndex = index;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	CGPoint p = [touch locationInView:self];
	NSInteger index = [self _indexOfSelectAtPoint:p.x];
	
	[UIView beginAnimations:nil context:nil];
	NSInteger i = 0;
	for(UIView *peg in self.pegs){
		peg.alpha = i == index ? 1 : OFF_PEG_ALPHA;
		peg.transform = i == index ? CGAffineTransformIdentity : SCALE_DOWN;
		i++;
	}
	[UIView commitAnimations];
	
	if(index!= _selectedPegIndex){
		_selectedPegIndex = index;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	
}


#pragma mark Properties
- (void) setNumberOfPegs:(NSUInteger)numberOfPegs{
	_numberOfPegs = numberOfPegs;
	if(_selectedPegIndex >= numberOfPegs)
		_selectedPegIndex = numberOfPegs - 1;
	[self _setupPegs];
}
- (void) setSelectedPegIndex:(NSInteger)selectedPegIndex{
	[self selectPegAtIndex:selectedPegIndex animated:NO];
}
- (void) selectPegAtIndex:(NSInteger)index animated:(BOOL)animated{
	_selectedPegIndex = index;
	
	if(animated) [UIView beginAnimations:nil context:nil];
	NSInteger i = 0;
	for(UIView *peg in self.pegs){
		peg.alpha = i == index ? 1 : OFF_PEG_ALPHA;
		peg.transform = i == index ? SCALE_DOWN : CGAffineTransformIdentity;
		i++;
	}
	if(animated) [UIView commitAnimations];
	
}
- (void) setLeftEndImage:(UIImage *)leftEndImage{
	self.leftImageView.image = [leftEndImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self _setupPegs];
}
- (void) setRightEndImage:(UIImage *)rightEndImage{
	self.rightImageView.image = [rightEndImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self _setupPegs];
}
- (UIImage*) leftEndImage{
	return self.leftImageView.image;
}
- (UIImage*) rightEndImage{
	return self.rightImageView.image;
}

@end