//
//  TKSlideToUnlockView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 5/21/13.
//
//

#import "TKSlideToUnlockView.h"
#import "UIImageView+TKCategory.h"
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"

@interface TKSlideToUnlockView (){
	CGFloat _initialOffset;
}
@property (nonatomic,strong) CAGradientLayer *textHighlightLayer;


@end

#define TRACK_PADDING 4.0
#define SLIDER_VIEW_WIDTH 82.0f
#define FADE_TEXT_OVER_LENGTH 50.0f

@implementation TKSlideToUnlockView

#pragma mark Init & Friends
- (id) initWithFrame:(CGRect)frame{
	frame.size.height = 96;
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
	CGRect frame = self.frame;
	self.backgroundColor = [UIColor blackColor];
	_isUnlocked = NO;
	
	self.trackView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 20, 22)];
	self.trackView.backgroundColor = [UIColor darkGrayColor];
	self.trackView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.trackView.layer.cornerRadius = 11;
	[self addSubview:self.trackView];
	
	UIImage *slider = [UIImage imageNamedTK:@"unlockslider/unlockSlider"];
	CGRect imgRect = CGRectMakeWithSize(SLIDER_VIEW_WIDTH - slider.size.width, (frame.size.height - slider.size.height)/2.0f, slider.size);
	
	UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SLIDER_VIEW_WIDTH, frame.size.height)];
	panView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
	[panView addGestureRecognizer:pan];
	[self addSubview:panView];

	
	self.sliderView = [UIImageView imageViewWithFrame:imgRect];
	self.sliderView.image = slider;
	self.sliderView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.sliderView.bounds cornerRadius:12].CGPath;
	self.sliderView.layer.shadowRadius = 3;
	self.sliderView.layer.shadowOpacity = 0.5;
	self.sliderView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	self.sliderView.layer.shadowOffset = CGSizeZero;
	[panView addSubview:self.sliderView];
	
	CGRect textRect = self.trackView.frame;
	textRect.size.width -= SLIDER_VIEW_WIDTH - textRect.origin.x;
	textRect.origin.x = SLIDER_VIEW_WIDTH;
	textRect = CGRectInset(textRect, 10, 2);
	
	self.textLabel = [[UILabel alloc] initWithFrame:textRect];
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.font = [UIFont systemFontOfSize:24];
	self.textLabel.textColor = [UIColor whiteColor];
	self.textLabel.textAlignment = NSTextAlignmentCenter;
	self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.textLabel.text = NSLocalizedString(@"slide to unlock",@"");
	[self insertSubview:self.textLabel belowSubview:self.sliderView];
	
	
	id dark = (id)[UIColor colorWithWhite:1 alpha:0.35].CGColor;
	id light = (id)[UIColor colorWithWhite:1 alpha:1.0f].CGColor;
	
	
	self.textHighlightLayer = [CAGradientLayer layer];
	self.textHighlightLayer.frame = CGRectInset(self.textLabel.bounds, -400, 0);
	self.textHighlightLayer.colors = @[dark,dark,light,dark,dark];
	self.textHighlightLayer.locations = @[@0,@0.46,@0.5,@0.54,@1];
	self.textHighlightLayer.startPoint = CGPointZero;
	self.textHighlightLayer.endPoint = CGPointMake(1.0, 0);
	self.textLabel.layer.mask = self.textHighlightLayer;

}

- (void) didMoveToWindow{
	[self _startLabelAnimation];
}
- (void) layoutSubviews{
	[super layoutSubviews];
	self.textHighlightLayer.frame = CGRectInset(self.textLabel.bounds, -400, 0);
	[self _startLabelAnimation];
}

- (void) _startLabelAnimation{
	
	[self.textHighlightLayer removeAllAnimations];
	CGFloat x = self.textHighlightLayer.frame.size.width/2.0f;
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
	animation.repeatCount = HUGE_VALF;
	animation.toValue = @(x);
	animation.fromValue = @(-x + self.textLabel.frame.size.width);
	animation.duration = 3.0f;
	[self.textHighlightLayer addAnimation:animation forKey:@"position.x"];
}
- (void) _pan:(UIPanGestureRecognizer*)pan{
	
	UIView *panView = pan.view;
	
	CGPoint p = [pan locationInView:self];
	CGFloat half = panView.frame.size.width/2.0f;
	CGFloat maximum = self.trackView.frame.size.width + self.trackView.frame.origin.x - half - TRACK_PADDING;

	if(pan.state == UIGestureRecognizerStateBegan){
		_initialOffset = [pan locationInView:self].x;
		
	}else if(pan.state == UIGestureRecognizerStateChanged){
		
		CGFloat x = MAX(half,half + p.x - _initialOffset);
		x = MIN(maximum,x);
		panView.center = CGPointMake(x, panView.center.y);

		CGFloat diff = FADE_TEXT_OVER_LENGTH - (p.x - _initialOffset);
		self.textLabel.alpha = diff / FADE_TEXT_OVER_LENGTH;

	}else if(pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){
		
		CGFloat x = MAX(half,half + p.x - _initialOffset);
		x = MIN(maximum,x);
		
		if(x == maximum){
			_isUnlocked = YES;
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}else{
			[self resetSlider:YES];
		}
	}
	
}

- (void) resetSlider:(BOOL)animated{
	
	UIView *panView = self.sliderView.superview;

	
	if(animated)
		[UIView beginAnimations:nil context:nil];
	
	self.textLabel.alpha = 1.0f;
	panView.center = CGPointMake(panView.frame.size.width/2.0f, panView.center.y);
	if(animated)
		[UIView commitAnimations];

	_isUnlocked = NO;
}



@end
