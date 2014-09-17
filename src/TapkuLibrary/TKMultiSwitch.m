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
@property (nonatomic,assign) BOOL needsReadjustment;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@end

@implementation TKMultiSwitch

#define UNSELECTED_ALPHA 0.5

#define UP_SCALE (CGRectGetHeight(self.frame) / (CGRectGetHeight(self.frame) - self.selectionInset*2))
#define SCALE_UP CGScale(UP_SCALE, UP_SCALE)

- (id) init{
	self = [self initWithItems:@[@""]];
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [self initWithItems:@[@""]];
    return self;
}
- (id) initWithItems:(NSArray*)items{
	CGFloat height = 40;
	if(!(self=[super initWithFrame:CGRectMake(10, 6, 320-20, height)])) return nil;
	
	_style = TKMultiSwitchStyleHollow;
	
	self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
	self.clipsToBounds = NO;
	self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
	
	self.selectionInset = 3;
	
	CGFloat per = CGRectGetWidth(self.frame) / items.count;
	self.selectionView = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, per, height), self.selectionInset, self.selectionInset)];
	self.selectionView.layer.borderColor = self.tintColor.CGColor;
	self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
	self.selectionView.layer.borderWidth = 1;
	self.selectionView.userInteractionEnabled = NO;
	[self addSubview:self.selectionView];
	
	_font = [UIFont systemFontOfSize:12];
	
	NSInteger i = 0;
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:items.count];
	for(NSString *txt in items){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(per * i, 0, per, height)];
		label.font = self.font;
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
	self.panGesture = pan;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	tap.delegate = self;
	[self addGestureRecognizer:tap];
	self.tapGesture = tap;
	
	UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtap:)];
	longtap.minimumPressDuration = 0.25;
	longtap.delegate = self;
	[self addGestureRecognizer:longtap];
	self.longPressGesture = longtap;
	
	self.offsetFromCenter = -1;
	_indexOfSelectedItem = 0;
	
    return self;
}



- (void) layoutSubviews{
	[super layoutSubviews];
	[self readjustLayout];
}

- (void) setFrame:(CGRect)frame{
	[super setFrame:frame];
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}




- (void) readjustLayout{
	
	if(!self.needsReadjustment) return;
	
	self.needsReadjustment = NO;
	
	CGFloat height = CGRectGetHeight(self.frame);
	self.layer.cornerRadius = height/2;
	
	CGFloat per = (CGRectGetWidth(self.frame)) / self.labels.count;
	self.selectionView.frame = CGRectInset(CGRectMake(0, 0, per, height), self.selectionInset, self.selectionInset);
	
	
	if(self.style == TKMultiSwitchStyleHollow) {
		self.selectionView.layer.borderColor = self.tintColor.CGColor;
		self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
		self.selectionView.layer.borderWidth = 1;
		self.selectionView.backgroundColor = [UIColor clearColor];
	}else{
		self.selectionView.layer.borderColor = self.tintColor.CGColor;
		self.selectionView.layer.cornerRadius = CGRectGetHeight(self.selectionView.frame) / 2;
		self.selectionView.layer.borderWidth = 0;
		self.selectionView.backgroundColor = self.tintColor;
	}
	
	
	[self addSubview:self.selectionView];
	[self sendSubviewToBack:self.selectionView];
	
	NSInteger i = 0;
	for(UILabel *label in self.labels){
		label.frame = CGRectMake(per * i , 0, per, CGFrameGetHeight(self));
		label.font = self.font;
		
		
		if(self.style == TKMultiSwitchStyleFilled){
			label.textColor = i == _indexOfSelectedItem ? self.selectedTextColor : self.textColor;
			label.alpha = 1;
		}else{
			label.alpha = i == _indexOfSelectedItem ? 1 : UNSELECTED_ALPHA;
		}
		
		
		i++;
	}
	
	CGFloat x = [self.labels[_indexOfSelectedItem] center].x;
	self.selectionView.center = CGPointMake( x, CGFrameGetHeight(self)/2);
	
}
- (void) tintColorDidChange{
	[super tintColorDidChange];
	for(UILabel *label in self.labels)
		label.textColor = self.tintColor;
	self.selectionView.layer.borderColor = self.tintColor.CGColor;
	[self readjustLayout];
}

#pragma mark UIGesture Actions
- (void) longtap:(UILongPressGestureRecognizer*)press{
	
	CGPoint point = [press locationInView:self];
	CGFloat per = CGRectGetWidth(self.frame) / self.labels.count;
	NSInteger index = point.x / per;
		
	if(press.began){
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		self.selectionView.transform = SCALE_UP;
		
		if(index != _indexOfSelectedItem){
			
			CGFloat x = point.x;
			x = MIN(CGRectGetWidth(self.frame)-(CGRectGetWidth(self.selectionView.frame)/2),x);
			x = MAX(CGRectGetWidth(self.selectionView.frame)/2,x);
			
			self.selectionView.center = CGPointMake( x, self.selectionView.center.y);
			self.offsetFromCenter = 0;
			
			NSInteger i = 0;
			
			
			
			
			
			for(UILabel *label in self.labels){
				
				
				if(self.style == TKMultiSwitchStyleFilled){
					[UIView transitionWithView:label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState animations:^{
						label.textColor = i == index ? self.selectedTextColor : self.textColor;
						label.alpha = 1;
					} completion:nil];
					
				}else{
					label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
					
				}
				
				i++;
			}
		}else{
			
			CGFloat x = point.x;
			x = MIN(CGRectGetWidth(self.frame)-(CGRectGetWidth(self.selectionView.frame)/2),x);
			x = MAX(CGRectGetWidth(self.selectionView.frame)/2,x);
			self.selectionView.center = CGPointMake( x, self.selectionView.center.y);
			
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
		self.selectionView.center = CGPointMake( self.selectionInset + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
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
			if(self.style == TKMultiSwitchStyleFilled){
				[UIView transitionWithView:label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
					label.textColor = i == index ? self.selectedTextColor : self.textColor;
					label.alpha = 1;
				} completion:nil];
				
			}else{
				label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
			}
			i++;
		}
		[UIView commitAnimations];
	}
	
	if(pan.ended || pan.cancelled){
		
		[UIView beginAnimations:nil context:nil];
		self.selectionView.transform = CGAffineTransformIdentity;
		self.selectionView.center = CGPointMake( self.selectionInset + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
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
	self.selectionView.center = CGPointMake( self.selectionInset + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
	NSInteger i = 0;
	for(UILabel *label in self.labels){
		
		if(self.style == TKMultiSwitchStyleFilled){
			[UIView transitionWithView:label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState animations:^{
				label.textColor = i == index ? self.selectedTextColor : self.textColor;
				label.alpha = 1;
			} completion:nil];
		}else{
			label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
		}
		i++;
	}
	[UIView commitAnimations];
	
	if(index == _indexOfSelectedItem) return;
	_indexOfSelectedItem = index;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	if(self.longPressGesture == gestureRecognizer && self.panGesture == otherGestureRecognizer)
		return YES;
	if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
		return NO;
	if(gestureRecognizer == self.panGesture || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
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
	self.selectionView.center = CGPointMake( self.selectionInset + per * index + CGRectGetWidth(self.selectionView.frame)/2, self.selectionView.center.y);
	
	NSInteger i = 0;
	for(UILabel *label in self.labels){
		
		
		if(self.style == TKMultiSwitchStyleFilled){
			
			[UIView transitionWithView:label duration:animated ? 0.3 : 0 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState animations:^{
				label.textColor = i == index ? self.selectedTextColor : self.textColor;
				label.alpha = 1;
			} completion:nil];
		}else{
			label.alpha = i == index ? 1 : UNSELECTED_ALPHA;
			
		}
		
		
		i++;
	}
	if(animated) [UIView commitAnimations];
	_indexOfSelectedItem = index;
	
}

- (void) setStyle:(TKMultiSwitchStyle)style{
	_style = style;
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}

- (void) setSelectionInset:(CGFloat)selectionInset{
	_selectionInset = selectionInset;
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}

- (void) setSelectedTextColor:(UIColor *)selectedTextColor{
	_selectedTextColor = selectedTextColor;
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}
- (void) setTextColor:(UIColor *)textColor{
	_textColor = textColor;
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}

- (void) setFont:(UIFont *)font{
	_font = font;
	self.needsReadjustment = YES;
	[self setNeedsLayout];
}


@end