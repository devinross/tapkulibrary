//
//  TKCalendarDayView.m
//  Created by Devin Ross on 7/28/09.
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

#import "TKCalendarDayView.h"
#import "NSDate+TKCategory.h"
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"
#import "TKGradientView.h"
#import "UIColor+TKCategory.h"
#import "UIImageView+TKCategory.h"
#import "UIView+TKCategory.h"

#define NOB_SIZE 15.0f
#define TOP_BAR_HEIGHT 45.0
#define EVENT_SAME_HOUR 3.0
#define HORIZONTAL_PAD 5.0f
#define RIGHT_EVENT_INSET 16.0
#define LEFT_INSET 53.0f
#define VERTICAL_INSET 10.0f
#define FONT_SIZE 14.0f
#define AM_SIZE 11.0f
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1]
#define VERTICAL_DIFF 45.0
#define TIMELINE_HEIGHT VERTICAL_INSET * 2 + 24 * (VERTICAL_DIFF)


#pragma mark - TKNowView
@interface TKNowView : UIView
@end

@implementation TKNowView
- (id) init{
	if(!(self=[super initWithFrame:CGRectMake(LEFT_INSET-NOB_SIZE, 0, NOB_SIZE + 20, NOB_SIZE)])) return nil;
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, NOB_SIZE, NOB_SIZE)];
	iv.image = [UIImage imageNamedTK:@"calendar/nob"];
	[self addSubview:iv];
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(NOB_SIZE, 5, self.frame.size.width - NOB_SIZE, 1)];
	line.backgroundColor = [UIColor colorWithWhite:102/255. alpha:1];
	line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview:line];
	
	
	return self;
}
@end

#pragma mark - TKTimelineView
@interface TKTimelineView : UIView

@property (nonatomic,strong) NSMutableArray *events;
@property (nonatomic,assign) CGFloat startY;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSArray *times;
@property (nonatomic,strong) NSArray *periods;
@property (nonatomic,strong) UIColor *hourColor;
@property (nonatomic,assign) BOOL is24hClock;

@end


#pragma mark - TKCalendarDayView
@interface TKCalendarDayView ()

@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSMutableArray *pages;
@property (nonatomic,strong) UIScrollView *horizontalScrollView;
@property (nonatomic,strong) NSDate *currentDay;
@property (nonatomic,strong) NSMutableArray *eventGraveYard;
@property (nonatomic,strong) UILabel *monthYearLabel;
@property (nonatomic,strong) UIButton *leftArrowButton;
@property (nonatomic,strong) UIButton *rightArrowButton;
@property (nonatomic,strong) UIView *topBackground;
@property (nonatomic,strong) TKNowView *nowLineView;

@end


@implementation TKCalendarDayView

#pragma mark Init & Friends
- (id) initWithFrame:(CGRect)frame timeZone:(NSTimeZone*)timeZone{
    if(!(self=[super initWithFrame:frame])) return nil;
	self.timeZone = timeZone;
    [self _setupView];
    return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [self initWithFrame:frame timeZone:[NSTimeZone defaultTimeZone]];
    return self;
}
- (id) initWithCoder:(NSCoder *)decoder {
    if(!(self=[super initWithCoder:decoder])) return nil;
	self.timeZone = [NSTimeZone defaultTimeZone];
    [self _setupView];
    return self;
}
- (void) _setupView{
	
	self.nowLineView = [[TKNowView alloc] init];
	
	NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:self.timeZone];
	info.hour = info.minute = info.second = 0;
	
	self.formatter = [[NSDateFormatter alloc] init];
	self.formatter.timeZone = self.timeZone;
	
	self.eventGraveYard = [NSMutableArray array];
	self.backgroundColor = [UIColor whiteColor];
	self.clipsToBounds = YES;
	self.pages = [NSMutableArray arrayWithCapacity:3];
	
	[self addSubview:self.topBackground];
	[self addSubview:self.monthYearLabel];
	[self addSubview:self.leftArrowButton];
	[self addSubview:self.rightArrowButton];
	

	CGRect r = CGRectInset(CGRectMake(0, TOP_BAR_HEIGHT, self.frame.size.width, self.frame.size.height - TOP_BAR_HEIGHT), -HORIZONTAL_PAD, 0);
	self.horizontalScrollView = [[UIScrollView alloc] initWithFrame:r];
	self.horizontalScrollView.backgroundColor = [UIColor colorWithWhite:214/255.0 alpha:1];
	self.horizontalScrollView.pagingEnabled = YES;
	self.horizontalScrollView.delegate = self;
	self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width*3.0, 0);
	self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.frame.size.width, 0);
	self.horizontalScrollView.showsHorizontalScrollIndicator = NO;
	[self addSubview:self.horizontalScrollView];
	
	
	info.day -= 1;
	
	for(NSInteger i=0;i<3;i++){
		
		NSDate *date = [NSDate dateWithDateComponents:info];
		
		CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
		r.origin.x = self.horizontalScrollView.frame.size.width * i + HORIZONTAL_PAD;
		r.origin.y = 0;
		
		
		CGRect rr = r;
		rr.origin.x = 0;
		
		UIScrollView *sv = [[UIScrollView alloc] initWithFrame:r];
		sv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		sv.clipsToBounds = NO;
		sv.contentSize = CGSizeMake(0, TIMELINE_HEIGHT);
		sv.alwaysBounceVertical = TRUE;
		sv.backgroundColor = [UIColor whiteColor];
		[self.horizontalScrollView addSubview:sv];
		
		sv.layer.shadowPath = [UIBezierPath bezierPathWithRect:rr].CGPath;
		sv.layer.shadowOpacity = 0.4;
		sv.layer.shadowOffset = CGSizeZero;
		sv.layer.shadowRadius = 2;
		sv.layer.shadowColor = [UIColor blackColor].CGColor;
		sv.tag = i;
		

		
		TKTimelineView *timelineView = [[TKTimelineView alloc] initWithFrame:sv.bounds];
		timelineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[sv addSubview:timelineView];
		timelineView.date = date;
		[self.pages addObject:sv];
		
		info.day += 1;
	}
	
	self.currentDay = [self _timelineAtIndex:1].date;
	[self _updateDateLabel];


	
}


#pragma mark UIView Subclasses
- (void) didMoveToWindow{
	if (self.window && ![self _timelineAtIndex:1].events)
		[self _reloadData];
}
- (void) layoutSubviews{

	[CATransaction begin];
	[CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
	[self _realignPages];
	[CATransaction commit];

}


- (void) scrollViewWasTapped:(UITapGestureRecognizer*)gesture{
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:eventViewWasSelected:)])
		[self.delegate calendarDayTimelineView:self eventViewWasSelected:(TKCalendarDayEventView*)gesture.view];
	
}


#pragma mark Private Methods
- (void) _realignPages{
	
	CGFloat w = [self.pages[1] frame].size.width;
	
	self.horizontalScrollView.frame = CGRectInset(CGRectMake(0, TOP_BAR_HEIGHT, self.frame.size.width, self.frame.size.height - TOP_BAR_HEIGHT), -HORIZONTAL_PAD, 0);
	self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width*3.0, 0);
	self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.frame.size.width, 0);
	
	NSInteger i = 0;
	for(UIScrollView *sv in self.pages){
		CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
		r.origin.x = self.horizontalScrollView.frame.size.width * i + HORIZONTAL_PAD;
		r.origin.y = 0;
		if(r.size.width != w){
			sv.frame = r;
			[self _realignEventsAtIndex:i];
		}else
			sv.frame = r;
		sv.bounds = CGRectMakeWithSize(0, 0, r.size);
		i++;
	}
	[self _scrollToTopEvent:NO];
	
}
- (void) _movePagesToIndex:(NSInteger)nowPage animated:(BOOL)animated{
	

	UIScrollView *needsUpdating = nil;
	NSInteger updateIndex = 1;

	if(nowPage<1){
		UIScrollView *sv = [self.pages lastObject];
		[self.pages insertObject:sv atIndex:0];
		[self.pages removeLastObject];
		needsUpdating = sv;
		updateIndex = 0;
	}else if(nowPage>1){
		UIScrollView *sv = self.pages[0];
		[self.pages addObject:sv];
		[self.pages removeObjectAtIndex:0];
		needsUpdating = sv;
		updateIndex = 2;
	}

	self.currentDay = [self _timelineAtIndex:1].date;
	
	NSDateComponents *info = [self.currentDay dateComponentsWithTimeZone:self.timeZone];
	info.day += nowPage < 1 ? -1 : 1;
	[self _timelineWithScrollView:needsUpdating].date = [NSDate dateWithDateComponents:info];
	[self _updateDateLabel];

	
	NSInteger i = 0;
	for(UIScrollView *sv in self.pages){
		CGRect r = sv.frame;
		r.origin.x = HORIZONTAL_PAD + self.horizontalScrollView.frame.size.width * i;
		sv.frame = r;
		i++;
	}
	
	
	self.horizontalScrollView.contentOffset = CGPointMake(self.horizontalScrollView.frame.size.width, 0);
	
	needsUpdating.contentOffset = CGPointZero;
	[self _refreshDataWithPageAtIndex:updateIndex];
		
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
		[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
	
	[self _scrollToTopEvent:animated];

}
- (void) _scrollToTopEvent:(BOOL)animated{
	UIScrollView *sv = self.pages[1];
	TKTimelineView *timeline = [self _timelineAtIndex:1];
	
	CGFloat y = -VERTICAL_INSET + timeline.startY;
	if(sv == self.nowLineView.superview)
		y = self.nowLineView.frame.origin.y - 20;
	y = MIN(sv.contentSize.height - sv.bounds.size.height, y);
	y = MAX(0,y);
	
	[sv setContentOffset:CGPointMake(0, y) animated:animated];
}

- (TKTimelineView*) _timelineWithScrollView:(UIScrollView*)sv{
	return (TKTimelineView*)[sv viewWithTag:5];
}
- (TKTimelineView*) _timelineAtIndex:(NSInteger)index{
	return (TKTimelineView*)[self.pages[index] viewWithTag:5];
}
- (NSInteger) _currentScrolledPage{
	CGFloat w = self.horizontalScrollView.frame.size.width;
	CGFloat x = self.horizontalScrollView.contentOffset.x + (w/2.0f);
	return x / w;
}
- (void) _updateDateLabel{
	self.formatter.dateFormat = @"EEEE, MMM d yyyy";
	self.formatter.timeZone = self.timeZone;
	self.monthYearLabel.text = [self.formatter stringFromDate:self.currentDay];
	self.monthYearLabel.textColor = [self.currentDay isToday] ? [UIColor colorWithRed:0 green:116/255. blue:230/255. alpha:1] : DEFAULT_TEXT_COLOR;
}


#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(decelerate) return;
	NSInteger page = [self _currentScrolledPage];
	if(page!=1) [self _movePagesToIndex:page animated:YES];
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSInteger page = [self _currentScrolledPage];
	if(page!=1) [self _movePagesToIndex:page animated:YES];
	
}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	NSInteger page = [self _currentScrolledPage];
	if(page!=1) [self _movePagesToIndex:page animated:YES];
}


#pragma mark Reload Day
- (void) reloadData{
	[self _reloadData];
}
- (void) _reloadData{
	[self _updateDateLabel];
	[self _refreshDataWithPageAtIndex:0];
	[self _refreshDataWithPageAtIndex:1];
	[self _refreshDataWithPageAtIndex:2];
	[self _scrollToTopEvent:NO];
}
- (void) _refreshDataWithPageAtIndex:(NSInteger)index{
	
	UIScrollView *sv = self.pages[index];
	TKTimelineView *timeline = [self _timelineAtIndex:index];
	
	
	CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
	r.origin.x = self.horizontalScrollView.frame.size.width * index + HORIZONTAL_PAD;
	sv.frame = r;
	

	
	timeline.startY = VERTICAL_INSET;
	
	for (UIView* view in sv.subviews) {
		if ([view isKindOfClass:[TKCalendarDayEventView class]]){
			[self.eventGraveYard addObject:view];
			[view removeFromSuperview];
		}
	}
	
	if(self.nowLineView.superview == sv) [self.nowLineView removeFromSuperview];
	if([timeline.date isTodayWithTimeZone:self.timeZone]){
		
		NSDate *date = [NSDate date];
		NSDateComponents *comp = [date dateComponentsWithTimeZone:self.timeZone];
		
		NSInteger hourStart = comp.hour;
		CGFloat hourStartPosition = hourStart * VERTICAL_DIFF + VERTICAL_INSET;
		
		NSInteger minuteStart = round(comp.minute / 5.0) * 5;
		CGFloat minuteStartPosition = roundf((CGFloat)minuteStart / 60.0f * VERTICAL_DIFF);
		
		CGRect eventFrame = CGRectMake(self.nowLineView.frame.origin.x, hourStartPosition + minuteStartPosition - 5, NOB_SIZE + self.frame.size.width - LEFT_INSET, NOB_SIZE);
		self.nowLineView.frame = eventFrame;
		[sv addSubview:self.nowLineView];

	}
	
	
	if(!self.dataSource) return;
	timeline.events = [NSMutableArray arrayWithArray:[self.dataSource calendarDayTimelineView:self eventsForDate:timeline.date]];
	
	
	[timeline.events sortUsingComparator:^NSComparisonResult(TKCalendarDayEventView *obj1, TKCalendarDayEventView *obj2){
		return [obj1.startDate compare:obj2.startDate];
	}];
	
	[self _realignEventsAtIndex:index];
	if(self.nowLineView.superview == sv)
		[sv bringSubviewToFront:self.nowLineView];

	
}
- (void) _realignEventsAtIndex:(NSInteger)index{
	
	UIScrollView *sv = self.pages[index];
	TKTimelineView *timeline = [self _timelineAtIndex:index];
	

	NSMutableArray *sameTimeEvents = [[NSMutableArray alloc] init];
	NSInteger offsetCount = 0;
	NSInteger repeatNumber = 0;		// number of nested appointments
	CGFloat horizOffset = 0.0f;		// number of pixels to offset horizontally when they are nested
	CGFloat startMarker = -100.0f;	// starting point to check if they match
	CGFloat endMarker = -100.0f;
	
	CGFloat startMarkerHeight = 0;
	
	CGFloat topOrigin = -1;
	
	for (TKCalendarDayEventView *event in timeline.events) {
		
		
		if(event.gestureRecognizers.count<1){
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWasTapped:)];
			[event addGestureRecognizer:tap];
		}
		
		
		BOOL startSameDay = [event.startDate isSameDay:timeline.date timeZone:self.timeZone];
		
		if(!startSameDay && (([event.startDate compare:timeline.date] == NSOrderedAscending && [event.endDate compare:timeline.date] == NSOrderedAscending) || ([event.startDate compare:timeline.date] == NSOrderedDescending))) continue;

		BOOL endSameDay = [event.endDate isSameDay:timeline.date timeZone:self.timeZone];
		NSDateComponents *startComp = [event.startDate dateComponentsWithTimeZone:self.timeZone];
		NSDateComponents *endComp = [event.endDate dateComponentsWithTimeZone:self.timeZone];

		NSInteger hourStart = startSameDay ? startComp.hour : 0;
		CGFloat hourStartPosition = hourStart * VERTICAL_DIFF + VERTICAL_INSET;
		
		NSInteger minuteStart = startSameDay ? round(startComp.minute / 5.0) * 5 : 0;
		CGFloat minuteStartPosition = roundf((CGFloat)minuteStart / 60.0f * VERTICAL_DIFF);
		
		NSInteger hourEnd = endSameDay ? endComp.hour : 23;
		CGFloat hourEndPosition = hourEnd * VERTICAL_DIFF + VERTICAL_INSET;

		NSInteger minuteEnd = endSameDay ? round(endComp.minute / 5.0) * 5 : 60;
		CGFloat minuteEndPosition = roundf((CGFloat)minuteEnd / 60.0f * VERTICAL_DIFF);
		
		CGFloat eventHeight = hourEndPosition + minuteEndPosition - hourStartPosition - minuteStartPosition;
		eventHeight = MAX(roundf(VERTICAL_DIFF/2), eventHeight);
		
		
		
		
		// nobre additions - split control and offset control				
		// split control - adjusts balloon widths so their times/titles don't overlap
		// offset control - adjusts starting balloon position so you can see all starts/ends
		if ((hourStartPosition + minuteStartPosition) - startMarker < 1) {
			repeatNumber++;
		} else {
			repeatNumber = 0;
			[sameTimeEvents removeAllObjects];
			//if this event starts before the last event's end, we have to offset it!
			if (hourStartPosition + minuteStartPosition < endMarker) {
				horizOffset = EVENT_SAME_HOUR * ++offsetCount;
			}
			else {
				horizOffset = 0.0f;
				offsetCount = 0;
			}
		}
		

		
		
		
		CGFloat eventWidth = (self.bounds.size.width  - LEFT_INSET - RIGHT_EVENT_INSET)/(repeatNumber+1);
		CGFloat eventOriginX = LEFT_INSET + 2.0f + horizOffset;
		CGRect eventFrame = CGRectMake(eventOriginX + (repeatNumber*eventWidth), hourStartPosition + minuteStartPosition, eventWidth, eventHeight);
		event.frame = CGRectIntegral(eventFrame);
		[event setNeedsLayout];
		[sv addSubview:event];
		
		for (NSInteger i = [sameTimeEvents count]-1; i >= 0; i--) {
			TKCalendarDayEventView *sameTimeEvent = sameTimeEvents[i];
			CGRect newFrame = sameTimeEvent.frame;
			newFrame.size.width = eventWidth;
			newFrame.origin.x = eventOriginX + (i*(eventWidth));
			sameTimeEvent.frame = CGRectIntegral(newFrame);
			[sameTimeEvent setNeedsLayout];
		}
		[sameTimeEvents addObject:event];
		
		[event setNeedsLayout];
		
		
		startMarker = hourStartPosition + minuteStartPosition;
		endMarker = MAX(endMarker,hourEndPosition + minuteEndPosition);
		
		if(topOrigin<0)
			topOrigin = startMarker;
		
		topOrigin = MIN(topOrigin,startMarker);
		startMarkerHeight = [event contentHeight];
		
	}
	
	if(topOrigin>0)
		timeline.startY = topOrigin;
	if(sv == self.nowLineView.superview)
		[sv bringSubviewToFront:self.nowLineView];
	
		
}


#pragma mark Button Actions
- (void) nextDay:(id)sender {
	[self _movePagesToIndex:2 animated:NO];
}
- (void) previousDay:(id)sender {
	[self _movePagesToIndex:0 animated:NO];
}


#pragma mark Properties & Public Functions
- (UIButton *) leftArrowButton{
	if(_leftArrowButton) return _leftArrowButton;

	_leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_leftArrowButton.tag = 0;
	_leftArrowButton.frame = CGRectMake(0, 3, 48, 38);
	[_leftArrowButton addTarget:self action:@selector(previousDay:) forControlEvents:UIControlEventTouchUpInside];
	[_leftArrowButton setImage:[UIImage imageNamedTK:@"calendar/calendar_left_arrow"] forState:0];
	return _leftArrowButton;
}
- (UIButton *) rightArrowButton{
	if(_rightArrowButton) return _rightArrowButton;

	_rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightArrowButton.tag = 1;
	_rightArrowButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	_rightArrowButton.frame = CGRectMake(self.frame.size.width-48, 3, 48, 38);
	[_rightArrowButton addTarget:self action:@selector(nextDay:) forControlEvents:UIControlEventTouchUpInside];
	[_rightArrowButton setImage:[UIImage imageNamedTK:@"calendar/calendar_right_arrow"] forState:0];
	return _rightArrowButton;
}
- (UILabel *) monthYearLabel{
	if(_monthYearLabel) return _monthYearLabel;
	
	_monthYearLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.topBackground.bounds, 40, 2)];
	_monthYearLabel.textAlignment = NSTextAlignmentCenter;
	_monthYearLabel.backgroundColor = [UIColor clearColor];
	_monthYearLabel.font = [UIFont boldSystemFontOfSize:19.0f];
	_monthYearLabel.textColor = DEFAULT_TEXT_COLOR;
	_monthYearLabel.shadowColor = [UIColor whiteColor];
	_monthYearLabel.shadowOffset = CGSizeMake(0, 1);
	_monthYearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	return _monthYearLabel;
}
- (UIView *) topBackground{
	if(_topBackground) return _topBackground;
	
	
	TKGradientView *gradient = [[TKGradientView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TOP_BAR_HEIGHT)];
	gradient.colors = @[[UIColor colorWithHex:0xf4f4f5],[UIColor colorWithHex:0xccccd1]];
	gradient.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, gradient.bounds.size.width, 1)];
	line.backgroundColor = [UIColor colorWithHex:0xaaaeb6];
	line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[gradient addSubview:line];
	
	_topBackground = gradient;
	return _topBackground;
}
- (BOOL) is24hClock{
	return [self _timelineAtIndex:0].is24hClock;
}
- (void) setIs24hClock:(BOOL)aIs24hClock {
	[self _timelineAtIndex:0].is24hClock = aIs24hClock;
	[self _timelineAtIndex:1].is24hClock = aIs24hClock;
	[self _timelineAtIndex:2].is24hClock = aIs24hClock;
}
- (NSDate*) date{
	return self.currentDay;
}
- (void) setDate:(NSDate *)date{
	
	NSDateComponents *comp = [date dateComponentsWithTimeZone:self.timeZone];
	comp.second = comp.minute = comp.hour = 0;
	
	self.currentDay = [NSDate dateWithDateComponents:comp];
	
	[self _timelineAtIndex:1].date = self.currentDay;
	
	comp.day -= 1;
	[self _timelineAtIndex:0].date = [NSDate dateWithDateComponents:comp];
	
	comp.day += 2;
	[self _timelineAtIndex:2].date = [NSDate dateWithDateComponents:comp];
	
	[self _reloadData];
	
}
- (TKCalendarDayEventView*) dequeueReusableEventView{
	if(self.eventGraveYard.count<1) return nil;
	
	TKCalendarDayEventView *event = [self.eventGraveYard lastObject];
	[self.eventGraveYard removeLastObject];
	
	event.titleLabel.text = @"";
	event.locationLabel.text = @"";
	event.identifier = nil;
	event.startDate = nil;
	event.endDate = nil;
	
	return event;
	
}

@end



#pragma mark - TKTimelineView
@implementation TKTimelineView

#pragma mark Init & Friends
- (id) initWithFrame:(CGRect)frame{
	frame.size.height = TIMELINE_HEIGHT;
    if(!(self=[super initWithFrame:frame])) return nil;
    [self _setupView];
    return self;
}
- (id) initWithCoder:(NSCoder *)decoder{
    if(!(self=[super initWithCoder:decoder])) return nil;
    [self _setupView];
	return self;
}
- (void) _setupView{
	
	
	self.contentScaleFactor = 1.0f;
	self.layer.contentsScale = 1.0f;
	self.tag = 5;
	self.contentMode = UIViewContentModeRedraw;
	self.backgroundColor = [UIColor whiteColor];
	
	
	UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSET, -800, self.frame.size.width - LEFT_INSET, 800 + VERTICAL_INSET)];
	gray.backgroundColor = [UIColor colorWithWhite:242/255.0 alpha:1];
	gray.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview:gray];
	
	gray = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSET, TIMELINE_HEIGHT - VERTICAL_INSET + 1, self.frame.size.width - LEFT_INSET, 800 + VERTICAL_INSET)];
	gray.backgroundColor = [UIColor colorWithWhite:242/255.0 alpha:1];
	gray.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview:gray];
		
}

- (NSString*) description{
	return [NSString stringWithFormat:@"<%@: %@>",NSStringFromClass([self class]),self.date];
}

- (void) setIs24hClock:(BOOL)is24hClock{
	_is24hClock = is24hClock;
	[self setNeedsDisplay];
}

#pragma mark Drawing
- (void) drawRect:(CGRect)rect {
    // Drawing code
	// Here Draw timeline from 12 am to noon to 12 am next day
	
	// Just making sure that times and periods are correctly initialized
	// Should have exactly the same number of objects
	if ((!self.is24hClock && self.times.count != self.periods.count)) {
		return;
	}
	
	// Times appearance
	UIFont *timeFont = [UIFont systemFontOfSize:FONT_SIZE];
	UIColor *timeColor = self.hourColor ? self.hourColor : [UIColor colorWithWhite:143/255. alpha:1];
	
	// Periods appearance
	UIFont *periodFont = [UIFont systemFontOfSize:AM_SIZE];
	UIColor *periodColor = self.hourColor ? self.hourColor : [UIColor colorWithWhite:143/255. alpha:1];
	
	// Draw each times string
	for (NSInteger i=0; i<self.times.count; i++) {
		
		
		[timeColor set];
		CGRect timeRect = CGRectMake(2.0, i * VERTICAL_DIFF + VERTICAL_INSET - 9, 20.0 + (self.is24hClock?22:0), FONT_SIZE + 2.0);
		
		
		if([self.times[i] length] > 2){
			
			timeRect.size.width = LEFT_INSET - timeRect.origin.x - 10;
			[self.times[i] drawInRect:timeRect withFont:timeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];

		}else{
			[self.times[i] drawInRect:timeRect withFont:timeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];

		}
		
		
		
		if (!self.is24hClock && i != 24/2) {
			[periodColor set];
			CGRect r = CGRectMake(2.0f + 20.0, i * VERTICAL_DIFF + VERTICAL_INSET - 7, 22.0, AM_SIZE + 2.0);
			[self.periods[i] drawInRect:r withFont:periodFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
		}
		
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(context, kCGInterpolationNone);
		CGContextSaveGState(context);
		CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
		CGContextSetLineWidth(context, 0.5);
		CGContextTranslateCTM(context, 0, 0.5);
		
		CGFloat x = 53.0f;
		CGFloat y = VERTICAL_INSET + i * VERTICAL_DIFF;
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, self.bounds.size.width, y);
		CGContextStrokePath(context);
		
		if (i != self.times.count-1) {
			
			y = ceilf(VERTICAL_INSET + i * VERTICAL_DIFF + (VERTICAL_DIFF / 2.0f));
			
			
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, x, y);
			CGContextAddLineToPoint(context, self.bounds.size.width, y);
			CGFloat dash1[] = {3.0, 1.0};
			CGContextSetLineDash(context, 0.0, dash1, 2);
			CGContextStrokePath(context);
		}
		
		CGContextRestoreGState(context);
		
		
		
	}
}

#pragma mark Setup
- (NSArray *) times{
	if(_times) return _times;
	
	// Setup array consisting of string
	// representing time aka 12 (12 am), 1 (1 am) ... 25 x
	if (self.is24hClock) 
		_times = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",
			 @"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"00:00"];
	else
		_times = @[@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",
			 @"Noon",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
	return _times;
}
- (NSArray *) periods{
	if (self.is24hClock) return nil;
	if(_periods) return _periods;
	
	// Setup array consisting of string
	// representing time periods aka AM or PM
	// Matching the array of times 25 x


	_periods = @[@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"AM",@"",
			  @"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"PM",@"AM"];
	
	return _periods;
}

@end