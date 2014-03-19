//
//  TKCalendarDayView.m
//  Created by Devin Ross on 7/28/09.
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

#import "TKCalendarDayView.h"
#import "NSDate+TKCategory.h"
#import "UIImage+TKCategory.h"
#import "TKGlobal.h"
#import "TKGradientView.h"
#import "UIColor+TKCategory.h"
#import "UIImageView+TKCategory.h"
#import "UIView+TKCategory.h"
#import "UIScreen+TKCategory.h"

#define NOB_SIZE 6.0f
#define TOP_BAR_HEIGHT 84.0
#define EVENT_SAME_HOUR 3.0
#define HORIZONTAL_PAD 5.0f
#define RIGHT_EVENT_INSET 10.0
#define LEFT_INSET 53.0f
#define VERTICAL_INSET 10.0f
#define FONT_SIZE 11.0f
#define AM_SIZE 11.0f
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1]
#define VERTICAL_DIFF 45.0
#define TIMELINE_HEIGHT VERTICAL_INSET * 2 + 24 * (VERTICAL_DIFF)
#define DAY_FONT_SIZE 18
#define WEEKEND_TEXT_COLOR [UIColor colorWithWhite:167/255. alpha:1]


#pragma mark - TKNowView
@interface TKNowView : UIView
@property (nonatomic,strong) UILabel *timeLabel;
- (void) updateTime;
@end

#pragma mark - TKDateLabel
@interface TKDateLabel : UILabel
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,assign) BOOL today;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL weekend;
@end


#pragma mark - TKTimelineView
@interface TKTimelineView : UIView
@property (nonatomic,strong) NSMutableArray *events;
@property (nonatomic,assign) CGFloat startY;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSArray *times;
@property (nonatomic,strong) UIColor *hourColor;
@property (nonatomic,assign) BOOL is24hClock;
@end

@interface TKWeekdaysView : UIView
@property (nonatomic,strong) NSArray *weekdayLabels;
@end


#pragma mark - TKCalendarDayView
@interface TKCalendarDayView ()

@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) NSMutableArray *pages;
@property (nonatomic,strong) UIScrollView *horizontalScrollView;

@property (nonatomic,strong) NSMutableArray *weekdayPages;
@property (nonatomic,strong) UIScrollView *daysScrollView;

@property (nonatomic,strong) NSDate *currentDay;
@property (nonatomic,strong) NSMutableArray *eventGraveYard;
@property (nonatomic,strong) UILabel *monthYearLabel;
@property (nonatomic,strong) TKNowView *nowLineView;
@property (nonatomic,assign) NSInteger indexOfCurrentDay;

@end


@implementation TKCalendarDayView

#pragma mark Init & Friends
- (id) initWithFrame:(CGRect)frame calendar:(NSCalendar*)calendar{
	if(!(self=[super initWithFrame:frame])) return nil;
	self.calendar = calendar;
    [self _setupView];
    return self;
}
- (id) initWithFrame:(CGRect)frame timeZone:(NSTimeZone*)timeZone{
	
	NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
	cal.timeZone = timeZone;
	
	self = [self initWithFrame:frame calendar:cal];
    return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [self initWithFrame:frame calendar:[NSCalendar autoupdatingCurrentCalendar]];
    return self;
}
- (id) initWithCoder:(NSCoder *)decoder {
    if(!(self=[super initWithCoder:decoder])) return nil;
	self.calendar = [NSCalendar autoupdatingCurrentCalendar];
    [self _setupView];
    return self;
}
- (void) _setupView{
	
	self.nowLineView = [[TKNowView alloc] init];
	
	NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:self.calendar.timeZone];
	info.hour = info.minute = info.second = 0;
	
	self.formatter = [[NSDateFormatter alloc] init];
	self.formatter.timeZone = self.calendar.timeZone;
	
	self.eventGraveYard = [NSMutableArray array];
	self.backgroundColor = [UIColor whiteColor];
	self.clipsToBounds = YES;
	self.pages = [NSMutableArray arrayWithCapacity:3];
	self.weekdayPages = [NSMutableArray arrayWithCapacity:3];
	[self addSubview:self.horizontalScrollView];
	
	
	info.day -= 1;
	
	for(NSInteger i=0;i<3;i++){
		
		NSDate *date = [NSDate dateWithDateComponents:info];
		
		CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
		r.origin.x = CGRectGetWidth(self.horizontalScrollView.frame) * i + HORIZONTAL_PAD;
		r.origin.y = 0;
		
		CGRect rr = r;
		rr.origin.x = 0;
		
		UIScrollView *sv = [[UIScrollView alloc] initWithFrame:r];
		sv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		sv.clipsToBounds = NO;
		sv.tag = i;
		sv.contentSize = CGSizeMake(0, TIMELINE_HEIGHT);
		sv.alwaysBounceVertical = TRUE;
		sv.backgroundColor = [UIColor whiteColor];
		[self.horizontalScrollView addSubview:sv];
		
		TKTimelineView *timelineView = [[TKTimelineView alloc] initWithFrame:sv.bounds];
		timelineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[sv addSubview:timelineView];
		timelineView.date = date;
		[self.pages addObject:sv];
		
		info.day += 1;
	}
	
	self.currentDay = [self _timelineAtIndex:1].date;
	[self _updateDateLabel];
	[self addSubview:self.daysBackgroundView];
	[self addSubview:self.monthYearLabel];
	
	
	NSInteger cnt = 0;
	NSArray *daySymbols = [[NSCalendar currentCalendar] shortWeekdaySymbols];
	CGFloat wid = CGRectGetWidth(self.frame);
	CGFloat xmargin = 20;
	wid -= 8;
	
	for(NSString *str in daySymbols){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xmargin + cnt* wid/daySymbols.count, 0, 40, 20)];
		label.font = [UIFont systemFontOfSize:10];
		label.text = [str substringToIndex:1];
		label.textColor = cnt == 0 || cnt == 6 ? WEEKEND_TEXT_COLOR : [UIColor blackColor];
		label.textAlignment = NSTextAlignmentCenter;
		[label sizeToFit];
		label.userInteractionEnabled = NO;
		[self.daysBackgroundView addSubview:label];
		cnt++;
	}
	


	[self.daysBackgroundView addSubviewToBack:self.daysScrollView];
	
	UIView *dayContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.daysScrollView.contentSize.width, CGRectGetHeight(self.daysScrollView.frame))];
	[self.daysScrollView addSubview:dayContainerView];
	
	CGRect weekFrame = self.daysScrollView.frame;
	weekFrame.origin = CGPointZero;
	for(NSInteger i=0;i<3;i++){
		
		weekFrame.origin.x = CGRectGetWidth(weekFrame) * i;
		TKWeekdaysView *weekdayView = [[TKWeekdaysView alloc] initWithFrame:weekFrame];
		
		for(UILabel *label in weekdayView.weekdayLabels){
			label.userInteractionEnabled = YES;
			[label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWeekdayLabel:)]];
		}
		[dayContainerView addSubviewToBack:weekdayView];
		[self.weekdayPages addObject:weekdayView];
	}
	
}


#pragma mark Button Actions
- (void) nextDay:(id)sender {
	[self _movePagesToIndex:2 animated:NO];
}
- (void) previousDay:(id)sender {
	[self _movePagesToIndex:0 animated:NO];
}
- (void) scrollViewWasTapped:(UITapGestureRecognizer*)gesture{
	if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:eventViewWasSelected:)])
		[self.delegate calendarDayTimelineView:self eventViewWasSelected:(TKCalendarDayEventView*)gesture.view];
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


#pragma mark Private Methods
- (void) _realignPages{
	
	CGFloat w = CGRectGetWidth([self.pages[1] frame]);
	CGFloat scrollWidth = CGRectGetWidth(self.horizontalScrollView.frame);
	
	self.horizontalScrollView.frame = CGRectInset(CGRectMake(0, TOP_BAR_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - TOP_BAR_HEIGHT), -HORIZONTAL_PAD, 0);
	self.horizontalScrollView.contentSize = CGSizeMake(scrollWidth*3.0, 0);
	self.horizontalScrollView.contentOffset = CGPointMake(scrollWidth, 0);
	
	NSInteger i = 0;
	for(UIScrollView *sv in self.pages){
		CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
		r.origin = CGPointMake(scrollWidth * i + HORIZONTAL_PAD,0);
		if(CGRectGetWidth(r) != w){
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
	
	NSDateComponents *info = [self.currentDay dateComponentsWithTimeZone:self.calendar.timeZone];
	info.day += nowPage < 1 ? -1 : 1;
	[self _timelineWithScrollView:needsUpdating].date = [NSDate dateWithDateComponents:info];
	[self _updateDateLabel];

	
	NSInteger i = 0;
	for(UIScrollView *sv in self.pages){
		CGRect r = sv.frame;
		r.origin.x = HORIZONTAL_PAD + CGRectGetWidth(self.horizontalScrollView.frame) * i;
		sv.frame = r;
		i++;
	}

	self.horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.horizontalScrollView.frame), 0);
	needsUpdating.contentOffset = CGPointZero;
	[self _refreshDataWithPageAtIndex:updateIndex];

	if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
		[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
	
	self.indexOfCurrentDay = nowPage > 1 ? self.indexOfCurrentDay+1 : self.indexOfCurrentDay-1;
	
	
	BOOL moveDayView = NO;
	NSInteger day = self.indexOfCurrentDay;
	if(self.indexOfCurrentDay < 0 || self.indexOfCurrentDay > 6){
		self.userInteractionEnabled = NO;
		moveDayView = YES;
		
		day = self.indexOfCurrentDay < 0 ? 6 : 0;
		
		
		[UIView animateWithDuration:0.3 animations:^{
			self.daysScrollView.contentOffset = self.indexOfCurrentDay > 6 ? CGPointMake(CGRectGetWidth(self.daysScrollView.frame)*2, 0) : CGPointZero;
		}completion:^(BOOL finished){
			[self _resetWeekdayOrderByMoving:self.indexOfCurrentDay > 0];
			self.userInteractionEnabled = YES;
			self.indexOfCurrentDay = day;
		}];
		
	}
	
	
	
	[UIView transitionWithView:self.daysScrollView.subviews.firstObject duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self _updateSelectedWeekdayAtIndex:self.indexOfCurrentDay+7];
	}completion:nil];
	

	

	[self _scrollToTopEvent:animated];

}
- (void) _scrollToTopEvent:(BOOL)animated{
	UIScrollView *sv = self.pages[1];
	TKTimelineView *timeline = [self _timelineAtIndex:1];
	
	CGFloat y = -VERTICAL_INSET + timeline.startY;
	if(sv == self.nowLineView.superview)
		y = CGRectGetMinY(self.nowLineView.frame) - 20;
	y = MIN(sv.contentSize.height - CGRectGetHeight(sv.bounds), y);
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
	CGFloat w = CGRectGetWidth(self.horizontalScrollView.frame);
	CGFloat x = self.horizontalScrollView.contentOffset.x + (w/2.0f);
	return x / w;
}
- (NSInteger) _currentScrolledWeek{
	CGFloat w = CGRectGetWidth(self.daysScrollView.frame);
	CGFloat x = self.daysScrollView.contentOffset.x + (w/2.0f);
	return x / w;
}
- (void) _updateDateLabel{
	self.formatter.dateFormat = @"EEEE MMMM d, yyyy";
	self.formatter.timeZone = self.calendar.timeZone;
	self.monthYearLabel.text = [self.formatter stringFromDate:self.currentDay];
}



#pragma mark UIScrollViewDelegate
- (void) _checkForPageChange{
	NSInteger page = [self _currentScrolledPage];
	if(page!=1) [self _movePagesToIndex:page animated:YES];
}
- (void) _checkForAdvancingWeek{
	NSInteger page = [self _currentScrolledWeek];
	if(page!=1) [self _advanceWeekToIndex:page animated:YES];
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(decelerate) return;

	if(scrollView == self.horizontalScrollView){
		[self _checkForPageChange];
	}else if(scrollView == self.daysScrollView){
		[self _checkForAdvancingWeek];
	}
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if(scrollView == self.horizontalScrollView){
		[self _checkForPageChange];
	}else if(scrollView == self.daysScrollView){
		[self _checkForAdvancingWeek];
	}
}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	if(scrollView == self.horizontalScrollView){
		[self _checkForPageChange];
	}else if(scrollView == self.daysScrollView){
		[self _checkForAdvancingWeek];
	}
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
	[self _setupDaysView];
	[self _scrollToTopEvent:NO];
	[self.nowLineView updateTime];
}
- (void) _refreshDataWithPageAtIndex:(NSInteger)index{
	
	UIScrollView *sv = self.pages[index];
	TKTimelineView *timeline = [self _timelineAtIndex:index];
	
	
	CGRect r = CGRectInset(self.horizontalScrollView.bounds, HORIZONTAL_PAD, 0);
	r.origin.x = CGRectGetWidth(self.horizontalScrollView.frame) * index + HORIZONTAL_PAD;
	sv.frame = r;
	

	
	timeline.startY = VERTICAL_INSET;
	
	for (UIView* view in sv.subviews) {
		if ([view isKindOfClass:[TKCalendarDayEventView class]]){
			[self.eventGraveYard addObject:view];
			[view removeFromSuperview];
		}
	}
	
	if(self.nowLineView.superview == sv) [self.nowLineView removeFromSuperview];
	if([timeline.date isTodayWithTimeZone:self.calendar.timeZone]){
		
		NSDate *date = [NSDate date];
		NSDateComponents *comp = [date dateComponentsWithTimeZone:self.calendar.timeZone];
		
		NSInteger hourStart = comp.hour;
		CGFloat hourStartPosition = hourStart * VERTICAL_DIFF + VERTICAL_INSET;
		
		NSInteger minuteStart = round(comp.minute / 5.0) * 5;
		CGFloat minuteStartPosition = roundf((CGFloat)minuteStart / 60.0f * VERTICAL_DIFF);
		
		
		CGRect eventFrame = CGRectMake(CGRectGetMinX(self.nowLineView.frame), hourStartPosition + minuteStartPosition - 5,  CGRectGetWidth(self.frame), 14);
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
	
	
	CGFloat topOrigin = -1;
	
	for (TKCalendarDayEventView *event in timeline.events) {
		
		
		if(event.gestureRecognizers.count<1){
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWasTapped:)];
			[event addGestureRecognizer:tap];
		}
		
		
		BOOL startSameDay = [event.startDate isSameDay:timeline.date timeZone:self.calendar.timeZone];
		
		if(!startSameDay && (([event.startDate compare:timeline.date] == NSOrderedAscending && [event.endDate compare:timeline.date] == NSOrderedAscending) || ([event.startDate compare:timeline.date] == NSOrderedDescending))) continue;

		BOOL endSameDay = [event.endDate isSameDay:timeline.date timeZone:self.calendar.timeZone];
		NSDateComponents *startComp = [event.startDate dateComponentsWithTimeZone:self.calendar.timeZone];
		NSDateComponents *endComp = [event.endDate dateComponentsWithTimeZone:self.calendar.timeZone];

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
		

		
		
		
		CGFloat eventWidth = (CGRectGetWidth(self.bounds)  - LEFT_INSET - RIGHT_EVENT_INSET)/(repeatNumber+1);
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
		
	}
	
	if(topOrigin>0)
		timeline.startY = topOrigin;
	if(sv == self.nowLineView.superview)
		[sv bringSubviewToFront:self.nowLineView];
	
}


#pragma mark WeekDay
- (void) _advanceWeekToIndex:(NSInteger)index animated:(BOOL)animated{
	self.userInteractionEnabled = NO;

	BOOL moveRight = index > 1 ? YES : NO;
	NSInteger pageToUpdate = moveRight ? 2 : 0;

	TKWeekdaysView *weekView = self.weekdayPages[pageToUpdate];
	TKDateLabel *currentLabel = weekView.weekdayLabels[self.indexOfCurrentDay];
	NSDate *theNewDate = currentLabel.date;
	[self _resetWeekdayOrderByMoving:moveRight];
	[self _timelineAtIndex:pageToUpdate].date = theNewDate;
	[self _refreshDataWithPageAtIndex:pageToUpdate];
	
	
	[UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
		
		self.horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.horizontalScrollView.frame) * pageToUpdate, 0);

	}completion:^(BOOL finished){
		
		
		UIScrollView *needsUpdating = nil;
		NSInteger updateIndex = 1;
		
		if(pageToUpdate<1){
			UIScrollView *sv = [self.pages lastObject];
			[self.pages insertObject:sv atIndex:0];
			[self.pages removeLastObject];
			needsUpdating = sv;
			updateIndex = 0;
		}else if(pageToUpdate>1){
			UIScrollView *sv = self.pages[0];
			[self.pages addObject:sv];
			[self.pages removeObjectAtIndex:0];
			needsUpdating = sv;
			updateIndex = 2;
		}
		
		self.currentDay = theNewDate;
		[self _updateDateLabel];
		
		NSDateComponents *info = [self.currentDay dateComponentsWithTimeZone:self.calendar.timeZone];
		info.day += pageToUpdate < 1 ? -1 : 1;
		[self _timelineWithScrollView:needsUpdating].date = [NSDate dateWithDateComponents:info];
		
		
		NSInteger i = 0;
		for(UIScrollView *sv in self.pages){
			CGRect r = sv.frame;
			r.origin.x = HORIZONTAL_PAD + CGRectGetWidth(self.horizontalScrollView.frame) * i;
			sv.frame = r;
			i++;
		}
		self.horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.horizontalScrollView.frame), 0);
		
		NSArray *allLabels = [self _allDayLabels];
		[self _timelineAtIndex:0].date = [allLabels[self.indexOfCurrentDay+7-1] date];
		[self _timelineAtIndex:2].date = [allLabels[self.indexOfCurrentDay+7+1] date];
		((UIScrollView*)self.pages[0]).contentOffset = CGPointZero;
		((UIScrollView*)self.pages[2]).contentOffset = CGPointZero;
		[self _refreshDataWithPageAtIndex:0];
		[self _refreshDataWithPageAtIndex:2];
		
		needsUpdating.contentOffset = CGPointZero;
		[self _refreshDataWithPageAtIndex:updateIndex];
		
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
			[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
		
		[self _scrollToTopEvent:YES];
		
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
			[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
		

		[UIView transitionWithView:self.daysScrollView.subviews.firstObject duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			[self _updateSelectedWeekdayAtIndex:self.indexOfCurrentDay+7];
		}completion:nil];
		
		[self _scrollToTopEvent:animated];
		self.userInteractionEnabled = YES;

		
	}];
	
	
	
}
- (void) _resetWeekdayOrderByMoving:(BOOL)forwards{
	
	if(forwards){
		TKWeekdaysView *weekView = [self.weekdayPages firstObject];
		[self.weekdayPages addObject:weekView];
		[self.weekdayPages removeObjectAtIndex:0];
		
		
		
		TKWeekdaysView *currentWeekView = self.weekdayPages[1];
		TKDateLabel *currentPageLabel  = currentWeekView.weekdayLabels.lastObject;
		
		NSDateComponents *mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:currentPageLabel.date];
		mutedCom.day++;
		for(TKDateLabel *label in weekView.weekdayLabels){
			
			NSDate *aDate = [self.calendar dateFromComponents:mutedCom];
			mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:aDate];
			label.text = [NSString stringWithFormat:@"%@",@(mutedCom.day)];
			label.date = aDate;
			label.today = [aDate isTodayWithTimeZone:self.calendar.timeZone];
			label.selected = [aDate isSameDay:self.currentDay timeZone:self.calendar.timeZone];
			mutedCom.day++;
			
		}
		
	}else{
		TKWeekdaysView *weekView = [self.weekdayPages lastObject];
		[self.weekdayPages insertObject:weekView atIndex:0];
		[self.weekdayPages removeLastObject];
		
		
		
		
		TKWeekdaysView *currentWeekView = self.weekdayPages[1];
		TKDateLabel *currentPageLabel  = currentWeekView.weekdayLabels.firstObject;
		
		NSDateComponents *mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:currentPageLabel.date];
		mutedCom.day --;
		for(TKDateLabel *label in weekView.weekdayLabels.reverseObjectEnumerator){
			
			NSDate *aDate = [self.calendar dateFromComponents:mutedCom];
			mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:aDate];
			label.text = [NSString stringWithFormat:@"%@",@(mutedCom.day)];
			label.date = aDate;
			label.today = [aDate isTodayWithTimeZone:self.calendar.timeZone];
			label.selected = [aDate isSameDay:self.currentDay timeZone:self.calendar.timeZone];
			mutedCom.day --;
			
		}
		
		
	}
	
	
	NSInteger i = 0;
	for(TKWeekdaysView *sv in self.weekdayPages){
		CGRect r = sv.frame;
		r.origin.x = CGRectGetWidth(self.daysScrollView.frame) * i;
		sv.frame = r;
		i++;
	}
	self.daysScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.daysScrollView.frame), 0);
	
}
- (void) _updateSelectedWeekdayAtIndex:(NSInteger)allLabelsIndex{
	
	NSArray *allLabel = [self _allDayLabels];
	
	NSInteger index = allLabelsIndex;
	NSInteger i=0;
	for(TKDateLabel *label in allLabel){
		label.selected = i == index;
		i++;
	}
	
	
}
- (void) didTapWeekdayLabel:(UITapGestureRecognizer*)sender{
	
	NSArray *allLabels = [self _allDayLabels];
	NSInteger indexOfSelectedLabel = [allLabels indexOfObject:sender.view];
	
	if(indexOfSelectedLabel == NSNotFound) return;
	
	TKDateLabel *label = allLabels[indexOfSelectedLabel];
	NSDate *theNewDate = label.date;
	
	if([label.date isSameDay:self.currentDay timeZone:self.calendar.timeZone]) return;
	
	BOOL moveRight = [label.date compare:self.currentDay] == NSOrderedDescending;
	NSInteger pageToUpdate = moveRight ? 2 : 0;
	
	self.userInteractionEnabled = NO;
	
	[self _timelineAtIndex:pageToUpdate].date = label.date;
	[self _refreshDataWithPageAtIndex:pageToUpdate];
	
	
	[UIView transitionWithView:self.daysScrollView.subviews.firstObject duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self _updateSelectedWeekdayAtIndex:indexOfSelectedLabel];
	}completion:nil];
	
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.horizontalScrollView.frame) * pageToUpdate, 0);
	}completion:^(BOOL finished){
		
		
		UIScrollView *needsUpdating = nil;
		NSInteger updateIndex = 1;
		
		if(pageToUpdate<1){
			UIScrollView *sv = [self.pages lastObject];
			[self.pages insertObject:sv atIndex:0];
			[self.pages removeLastObject];
			needsUpdating = sv;
			updateIndex = 0;
		}else if(pageToUpdate>1){
			UIScrollView *sv = self.pages[0];
			[self.pages addObject:sv];
			[self.pages removeObjectAtIndex:0];
			needsUpdating = sv;
			updateIndex = 2;
		}
		
		self.currentDay = theNewDate;
		[self _updateDateLabel];
		
		NSDateComponents *info = [self.currentDay dateComponentsWithTimeZone:self.calendar.timeZone];
		info.day += pageToUpdate < 1 ? -1 : 1;
		[self _timelineWithScrollView:needsUpdating].date = [NSDate dateWithDateComponents:info];
		
		
		NSInteger i = 0;
		for(UIScrollView *sv in self.pages){
			CGRect r = sv.frame;
			r.origin.x = HORIZONTAL_PAD + CGRectGetWidth(self.horizontalScrollView.frame) * i;
			sv.frame = r;
			i++;
		}
		self.horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.horizontalScrollView.frame), 0);
		
		
		[self _timelineAtIndex:0].date = [allLabels[indexOfSelectedLabel-1] date];
		[self _timelineAtIndex:2].date = [allLabels[indexOfSelectedLabel+1] date];
		((UIScrollView*)self.pages[0]).contentOffset = CGPointZero;
		((UIScrollView*)self.pages[2]).contentOffset = CGPointZero;
		[self _refreshDataWithPageAtIndex:0];
		[self _refreshDataWithPageAtIndex:2];
		
		needsUpdating.contentOffset = CGPointZero;
		[self _refreshDataWithPageAtIndex:updateIndex];
		
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
			[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
		
		[self _scrollToTopEvent:YES];
		
		self.userInteractionEnabled = YES;
		self.indexOfCurrentDay = indexOfSelectedLabel - 7;
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(calendarDayTimelineView:didMoveToDate:)])
			[self.delegate calendarDayTimelineView:self didMoveToDate:self.currentDay];
	}];
	
	
	
	
	
}
- (void) _setupDaysView{
	
	NSArray *labels =  [self _allDayLabels];
	NSDateComponents *comp = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitWeekday fromDate:self.currentDay];
	NSDateComponents *mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:self.currentDay];
	for(NSInteger cnt= comp.weekday + 6;cnt>=0;cnt--){
		NSDate *aDate = [self.calendar dateFromComponents:mutedCom];
		mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:aDate];
		TKDateLabel *label = labels[cnt];
		label.text = [NSString stringWithFormat:@"%@",@(mutedCom.day)];
		label.date = aDate;
		label.today = [aDate isTodayWithTimeZone:self.calendar.timeZone];
		label.selected = [aDate isSameDay:self.currentDay timeZone:self.calendar.timeZone];
		mutedCom.day --;
	}
	
	mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:self.currentDay];
	
	for(NSInteger cnt= comp.weekday + 6;cnt<labels.count;cnt++){
		
		NSDate *aDate = [self.calendar dateFromComponents:mutedCom];
		mutedCom = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra fromDate:aDate];
		TKDateLabel *label = labels[cnt];
		label.text = [NSString stringWithFormat:@"%@",@(mutedCom.day)];
		label.date = aDate;
		label.today = [aDate isTodayWithTimeZone:self.calendar.timeZone];
		label.selected = [aDate isSameDay:self.currentDay timeZone:self.calendar.timeZone];
		mutedCom.day ++;
		
	}
	
	self.indexOfCurrentDay = comp.weekday-1;
}
- (NSArray*) _allDayLabels{
	NSMutableArray *labels = [NSMutableArray array];
	for(TKWeekdaysView *page in self.weekdayPages){
		[labels addObjectsFromArray:page.weekdayLabels];
	}
	return labels.copy;
}


- (void) tintColorDidChange{
	[super tintColorDidChange];
	self.nowLineView.tintColor = self.tintColor;
	
	for(TKDateLabel *label in [self _allDayLabels])
		label.tintColor = self.tintColor;
	
}

#pragma mark Properties & Public Functions
- (UILabel *) monthYearLabel{
	if(_monthYearLabel) return _monthYearLabel;
	
	_monthYearLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, CGRectGetHeight(self.daysBackgroundView.frame) - 24 - 6, CGRectGetWidth(self.daysBackgroundView.frame), 24), 40, 0)];
	_monthYearLabel.textAlignment = NSTextAlignmentCenter;
	_monthYearLabel.backgroundColor = [UIColor clearColor];
	_monthYearLabel.font = [UIFont systemFontOfSize:16.0f];
	_monthYearLabel.textColor = [UIColor blackColor];
	_monthYearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	return _monthYearLabel;
}
- (UIView *) daysBackgroundView{
	if(_daysBackgroundView) return _daysBackgroundView;
		
	_daysBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TOP_BAR_HEIGHT)];
	_daysBackgroundView.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
	_daysBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
	_daysBackgroundView.layer.shadowOffset = CGSizeZero;
	_daysBackgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_daysBackgroundView.bounds].CGPath;
	_daysBackgroundView.layer.shadowRadius = 1;
	_daysBackgroundView.layer.shadowOpacity = 0.2;
	
	UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT - [UIScreen mainScreen].onePixelSize, CGRectGetWidth(self.frame),[UIScreen mainScreen].onePixelSize)];
	div.backgroundColor = [UIColor colorWithHex:0xd7d7d7];
	[_daysBackgroundView addSubview:div];
	return _daysBackgroundView;
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
	

	NSDateComponents *comp = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra | NSCalendarUnitWeekday fromDate:date];
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
- (UIScrollView*) horizontalScrollView{
	if(_horizontalScrollView) return _horizontalScrollView;
	CGRect r = CGRectInset(CGRectMake(0, TOP_BAR_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - TOP_BAR_HEIGHT), -HORIZONTAL_PAD, 0);
	_horizontalScrollView = [[UIScrollView alloc] initWithFrame:r];
	_horizontalScrollView.pagingEnabled = YES;
	_horizontalScrollView.delegate = self;
	_horizontalScrollView.contentSize = CGSizeMake(CGRectGetWidth(r)*3.0, 0);
	_horizontalScrollView.contentOffset = CGPointMake(CGRectGetWidth(r), 0);
	_horizontalScrollView.showsHorizontalScrollIndicator = NO;
	return _horizontalScrollView;
}
- (UIScrollView*) daysScrollView{
	if(_daysScrollView) return _daysScrollView;
	_daysScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMinY(self.monthYearLabel.frame))];
	_daysScrollView.pagingEnabled = YES;
	_daysScrollView.delegate = self;
	_daysScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.daysScrollView.frame)*3.0, 0);
	_daysScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.daysScrollView.frame), 0);
	_daysScrollView.showsHorizontalScrollIndicator = NO;
	return _daysScrollView;
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
	// Times appearance
	UIFont *timeFont = [UIFont systemFontOfSize:FONT_SIZE];
	UIColor *timeColor = [UIColor blackColor];
	UIColor *lineColor = [UIColor colorWithHex:0xd7d7d7];

	// Draw each times string
	for (NSInteger i=0; i<self.times.count; i++) {
		
		[timeColor set];
		CGRect timeRect = CGRectMake(2.0, i * VERTICAL_DIFF + VERTICAL_INSET - 7, LEFT_INSET - 2.0f - 6, FONT_SIZE + 2.0);

		[self.times[i] drawInRect:timeRect withFont:timeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(context, kCGInterpolationNone);
		CGContextSaveGState(context);
		CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
		CGContextSetLineWidth(context,[UIScreen mainScreen].onePixelSize);
		CGContextTranslateCTM(context, 0, 0.5);
		CGFloat x = 53.0f, y = VERTICAL_INSET + i * VERTICAL_DIFF;
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), y);
		CGContextStrokePath(context);
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

@end



#define DAY_LABEL_WIDTH 35.0f
@implementation TKWeekdaysView
- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	
	
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:7];
	for(NSInteger i=0;i<7;i++){
		TKDateLabel *label = [[TKDateLabel alloc] initWithFrame:CGRectMake(8+(DAY_LABEL_WIDTH+9)*i, 16, DAY_LABEL_WIDTH, DAY_LABEL_WIDTH)];
		label.weekend = i % 6 == 0;
		[self addSubviewToBack:label];
		[labels addObject:label];
	}
	
	
	self.weekdayLabels = labels.copy;
	
    return self;
}
@end


#pragma mark - TKDateLabel
@implementation TKDateLabel


- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	self.textAlignment = NSTextAlignmentCenter;
	self.layer.cornerRadius = DAY_LABEL_WIDTH / 2.0f;
	self.clipsToBounds = YES;
	[self _updateLabelColorState];
    return self;
}


- (void) tintColorDidChange{
	[self _updateLabelColorState];
}

- (void) _updateLabelColorState{
	
	if(self.selected){
		self.backgroundColor = self.today ? self.tintColor : [UIColor blackColor];
		self.textColor = [UIColor whiteColor];
		self.font = [UIFont boldSystemFontOfSize:DAY_FONT_SIZE];
	}else{
		UIColor *clr = self.weekend ? WEEKEND_TEXT_COLOR : [UIColor blackColor];
		self.textColor = self.today ? self.tintColor : clr;
		self.backgroundColor = [UIColor clearColor];
		self.font = [UIFont systemFontOfSize:DAY_FONT_SIZE];
	}
	self.tag = self.today ? 1 : 0;
}

- (void) setSelected:(BOOL)selected{
	if(selected == _selected) return;
	
	_selected = selected;
	[self _updateLabelColorState];
}
- (void) setToday:(BOOL)today{
	if(_today == today) return;
	_today = today;
	[self _updateLabelColorState];
}
- (void) setWeekend:(BOOL)weekend{
	_weekend = weekend;
	[self _updateLabelColorState];
}

@end

#pragma mark - TKNowView
@implementation TKNowView
- (id) init{
	if(!(self=[super initWithFrame:CGRectMake(0, 0, 320, 14)])) return nil;
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, LEFT_INSET-2, CGRectGetHeight(self.frame))];
	self.timeLabel.textColor = self.tintColor;
	self.timeLabel.font = [UIFont boldSystemFontOfSize:10];
	[self addSubview:self.timeLabel];
	

	
	UIView *nob = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSET + 1, 3, 6, 6)];
	nob.backgroundColor = self.tintColor;
	nob.tag = 7;
	nob.layer.cornerRadius = CGRectGetWidth(nob.frame)/2.0f;
	[self addSubview:nob];
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSET-5, 5.5, 5, 1)];
	line.backgroundColor = self.tintColor;
	line.tag = 6;
	[self addSubview:line];
	
	line = [[UIView alloc] initWithFrame:CGRectMake(LEFT_INSET + 8, 5.5, CGRectGetWidth(self.frame) - NOB_SIZE, 1)];
	line.backgroundColor = self.tintColor;
	line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	line.tag = 5;
	[self addSubview:line];
	
	self.clipsToBounds = YES;
	
	[self updateTime];
	
	
	return self;
}

- (void) updateTime{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	self.timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
	
}

- (void) tintColorDidChange{
	[super tintColorDidChange];
	self.timeLabel.textColor = self.tintColor;
	[self viewWithTag:5].backgroundColor = self.tintColor;
	[self viewWithTag:6].backgroundColor = self.tintColor;
	[self viewWithTag:7].backgroundColor = self.tintColor;
}

@end