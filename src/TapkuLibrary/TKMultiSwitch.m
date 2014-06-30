//
//  TKMultiSwitch.m
//  Created by Devin Ross on 6/27/14.
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

#import "TKMultiSwitch.h"
#import "UIGestureRecognizer+TKCategory.h"
#import "TKGlobal.h"

@interface TKMultiSwitch () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *selectionView;
@property (nonatomic,strong) NSArray *labels;
@property (nonatomic,assign) CGFloat offsetFromCenter;

@end

@implementation TKMultiSwitch

#define HEIGHT 40
#define INSET 3
#define UNSELECTED_ALPHA 0.5
#define SCALE_UP CGScale(1.04, 1.16)

- (id) init{
	self = [self initWithItems:@[@""]];
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [self initWithItems:@[@""]];
    return self;
}
- (id) initWithItems:(NSArray*)items{
	if(!(self=[super initWithFrame:CGRectMake(10, 6, 320-20, HEIGHT)])) return nil;
	
	self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
	self.clipsToBounds = NO;
	self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
	
	CGFloat per = CGRectGetWidth(self.frame) / items.count;
	self.selectionView = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, per, HEIGHT), INSET, INSET)];
	self.selectionView.layer.borderColor = self.tintColor.CGColor;
	self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
	self.selectionView.layer.borderWidth = 1;
	[self addSubview:self.selectionView];
	
	NSInteger i = 0;
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:items.count];
	for(NSString *txt in items){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(per * i, 0, per, HEIGHT)];
		label.font = [UIFont systemFontOfSize:12];
		label.text = txt;
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = self.tintColor;
		label.alpha = i == 0 ? 1 : UNSELECTED_ALPHA;
		[self addSubview:label];
		[labels addObject:label];
		i++;
	}
	self.labels = labels.copy;
	
	self.multipleTouchEnabled = NO;
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	pan.delegate = self;
	[self addGestureRecognizer:pan];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	tap.delegate = self;
	[self addGestureRecognizer:tap];
	
	UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtap:)];
	longtap.minimumPressDuration = 0.25;
	longtap.delegate = self;
	[self addGestureRecognizer:longtap];
	
	self.offsetFromCenter = -1;
	_indexOfSelectedItem = 0;

    return self;
}

#pragma mark UIGesture Actions
- (void) longtap:(UILongPressGestureRecognizer*)press{
	
	CGPoint point = [press locationInView:self];
	CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
	NSInteger index = point.x / per;
	
	if(press.began){
		
		
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		self.selectionView.transform = SCALE_UP;
		[UIView commitAnimations];



		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

		if(index != _indexOfSelectedItem){

			CGFloat x = point.x;
			x = MIN(CGRectGetWidth(self.frame)-(CGRectGetWidth(self.selectionView.frame)/2),x);
			x = MAX(CGRectGetWidth(self.selectionView.frame)/2,x);

			self.selectionView.center = CGPointMake( x, self.selectionView.center.y);
			self.offsetFromCenter = 0;

			NSInteger i = 0;;
			for(UILabel *label in self.labels){
				label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
				i++;
			}
		}
		[UIView commitAnimations];
		
		
	}else if(press.ended || press.cancelled){
		
		CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
		NSInteger index = self.selectionView.center.x / per;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		self.selectionView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
		
		
		
		[UIView beginAnimations:nil context:nil];
		self.selectionView.transform = CGAffineTransformIdentity;
		self.selectionView.center = CGPointMake( INSET + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
		[UIView commitAnimations];
		
		self.offsetFromCenter = -1;
		
		if(_indexOfSelectedItem == index) return;
		_indexOfSelectedItem = index;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		
		
	}
	

}
- (void) pan:(UIPanGestureRecognizer*)pan{
	
	CGPoint p = [pan locationInView:self];
	if(pan.began){
		if(self.offsetFromCenter == -1)
			self.offsetFromCenter = p.x - self.selectionView.center.x;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		self.selectionView.transform = SCALE_UP;
		[UIView commitAnimations];

	}
	
	CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
	NSInteger index = self.selectionView.center.x / per;
	
	if(pan.changed){
		
		CGFloat x = p.x - self.offsetFromCenter;
		x = MIN(CGRectGetWidth(self.frame)-(CGRectGetWidth(self.selectionView.frame)/2),x);
		x = MAX(CGRectGetWidth(self.selectionView.frame)/2,x);
		
		[UIView beginAnimations:nil context:nil];
		self.selectionView.center = CGPointMake( x, self.selectionView.center.y);
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:nil];
		NSInteger i = 0;
		for(UILabel *label in self.labels){
			label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
			i++;
		}
		[UIView commitAnimations];
	}
	
	if(pan.ended || pan.cancelled){

		[UIView beginAnimations:nil context:nil];
		self.selectionView.transform = CGAffineTransformIdentity;
		self.selectionView.center = CGPointMake( INSET + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
		[UIView commitAnimations];
		
		self.offsetFromCenter = -1;
		
		if(_indexOfSelectedItem == index) return;
		_indexOfSelectedItem = index;
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		
	}
	
	
}
- (void) tap:(UITapGestureRecognizer*)tap{
		
	CGPoint point = [tap locationInView:self];
	CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
	NSInteger index = point.x / per;
	self.offsetFromCenter = -1;

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	self.selectionView.transform = CGAffineTransformIdentity;
	self.selectionView.center = CGPointMake( INSET + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
	NSInteger i = 0;
	for(UILabel *label in self.labels){
		label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
		i++;
	}
	[UIView commitAnimations];
	
	if(index == _indexOfSelectedItem) return;
	_indexOfSelectedItem = index;
	[self sendActionsForControlEvents:UIControlEventValueChanged];

}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
		return NO;
	return YES;
}

#pragma mark Public Properties
- (void) setIndexOfSelectedItem:(NSInteger)indexOfSelectedItem{
	[self selectItemAtIndex:indexOfSelectedItem animated:NO];
}
- (void) selectItemAtIndex:(NSInteger)index animated:(BOOL)animated{
	
	CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
	self.offsetFromCenter = -1;
	if(index == _indexOfSelectedItem) return;
	
	
	if(animated) [UIView beginAnimations:nil context:nil];
	self.selectionView.transform = CGAffineTransformIdentity;
	self.selectionView.center = CGPointMake( INSET + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
	
	NSInteger i = 0;
	for(UILabel *label in self.labels){
		label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
		i++;
	}
	if(animated) [UIView commitAnimations];
	_indexOfSelectedItem = index;
	
}

- (void) tintColorDidChange{
	[super tintColorDidChange];
	for(UILabel *label in self.labels)
		label.textColor = self.tintColor;
	self.selectionView.layer.borderColor = self.tintColor.CGColor;
}

@end