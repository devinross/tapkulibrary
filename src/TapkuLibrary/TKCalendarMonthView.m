//
//  TKCalendarMonthView.m
//  Created by Devin Ross on 6/10/10.
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

#import "TKCalendarMonthView.h"
#import "NSDate+TKCategory.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"
#import "NSDate+CalendarGrid.h"


#pragma mark - TKCalendarMonthTiles
@interface TKCalendarMonthTiles : UIView {
	
	id target;
	SEL action;
	
	int firstOfPrev,lastOfPrev;
	NSArray *marks;
	int today;
	BOOL markWasOnToday;
	
	int selectedDay,selectedPortion;
	int firstWeekday, daysInMonth;
	BOOL startOnSunday;
}

@property (nonatomic,strong) NSDate *monthDate;
@property (nonatomic,strong) NSMutableArray *accessibleElements;

- (id) initWithMonth:(NSDate*)date marks:(NSArray*)marks startDayOnSunday:(BOOL)sunday timeZone:(NSTimeZone*)timeZone;
- (void) setTarget:(id)target action:(SEL)action;

- (void) selectDay:(int)day;
- (NSDate*) dateSelected;

+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday timeZone:(NSTimeZone*)timeZone;


@property (nonatomic,strong) UIImageView *selectedImageView;
@property (nonatomic,strong) UILabel *currentDay;
@property (nonatomic,strong) UILabel *dot;
@property (nonatomic,strong) NSArray *datesArray;
@property (nonatomic,strong) NSTimeZone *timeZone;

@end


#pragma mark - TKCalendarMonthTiles
@implementation TKCalendarMonthTiles


#define dotFontSize 18.0
#define dateFontSize 22.0

#pragma mark Accessibility Container methods
- (BOOL) isAccessibilityElement{
    return NO;
}
- (NSArray *) accessibleElements{
    if (_accessibleElements!=nil) return _accessibleElements;

    _accessibleElements = [[NSMutableArray alloc] init];
	
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	[formatter setTimeZone:self.timeZone];
	
	NSDate *firstDate = [self.datesArray objectAtIndex:0];
	
	for(int i=0;i<marks.count;i++){
		UIAccessibilityElement *element = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
		
		NSDate *day = [NSDate dateWithTimeIntervalSinceReferenceDate:[firstDate timeIntervalSinceReferenceDate]+(24*60*60*i)+5];
		element.accessibilityLabel = [formatter stringForObjectValue:day];
		
		CGRect r = [self convertRect:[self rectForCellAtIndex:i] toView:self.window];
		r.origin.y -= 6;
		
		element.accessibilityFrame = r;
		element.accessibilityTraits = UIAccessibilityTraitButton;
		element.accessibilityValue = [[marks objectAtIndex:i] boolValue] ? @"Has Events" : @"No Events";
		[_accessibleElements addObject:element];
		
	}
	
	
	
    return _accessibleElements;
}
- (NSInteger) accessibilityElementCount{
    return [self accessibleElements].count;
}
- (id) accessibilityElementAtIndex:(NSInteger)index{
    return [self accessibleElements][index];
}
- (NSInteger) indexOfAccessibilityElement:(id)element{
    return [[self accessibleElements] indexOfObject:element];
}

#pragma mark Init & Friends
+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday timeZone:(NSTimeZone*)timeZone{
	
	NSDate *firstDate, *lastDate;
	
	NSDateComponents *info = [date dateComponentsWithTimeZone:timeZone];
	
	info.day = 1;
	info.hour = info.minute = info.second = 0;
	
	NSDate *currentMonth = [NSDate dateWithDateComponents:info];
	info = [currentMonth dateComponentsWithTimeZone:timeZone];
	
	
	NSDate *previousMonth = [currentMonth previousMonthWithTimeZone:timeZone];
	NSDate *nextMonth = [currentMonth nextMonthWithTimeZone:timeZone];
	
	if(info.weekday > 1 && sunday){
		
		NSDateComponents *info2 = [previousMonth dateComponentsWithTimeZone:timeZone];
		
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];		
		info2.day = preDayCnt - info.weekday + 2;
		firstDate = [NSDate dateWithDateComponents:info2];
		
		
	}else if(!sunday && info.weekday != 2){
		
		NSDateComponents *info2 = [previousMonth dateComponentsWithTimeZone:timeZone];
		int preDayCnt = [previousMonth daysBetweenDate:currentMonth];
		if(info.weekday==1){
			info2.day = preDayCnt - 5;
		}else{
			info2.day = preDayCnt - info.weekday + 3;
		}
		firstDate = [NSDate dateWithDateComponents:info2];
		
		
		
	}else{
		firstDate = currentMonth;
	}
	
	
	
	int daysInMonth = [currentMonth daysBetweenDate:nextMonth];		
	info.day = daysInMonth;
	NSDate *lastInMonth = [NSDate dateWithDateComponents:info];
	NSDateComponents *lastDateInfo = [lastInMonth dateComponentsWithTimeZone:timeZone];

	
	
	if(lastDateInfo.weekday < 7 && sunday){
		
		lastDateInfo.day = 7 - lastDateInfo.weekday;
		lastDateInfo.month++;
		lastDateInfo.weekday = 0;
		if(lastDateInfo.month>12){
			lastDateInfo.month = 1;
			lastDateInfo.year++;
		}
		lastDate = [NSDate dateWithDateComponents:lastDateInfo];
	
	}else if(!sunday && lastDateInfo.weekday != 1){
		
		
		lastDateInfo.day = 8 - lastDateInfo.weekday;
		lastDateInfo.month++;
		if(lastDateInfo.month>12){ lastDateInfo.month = 1; lastDateInfo.year++; }

		
		lastDate = [NSDate dateWithDateComponents:lastDateInfo];

	}else{
		lastDate = lastInMonth;
	}
	
	
	
	return @[firstDate,lastDate];
}




- (id) initWithMonth:(NSDate*)date marks:(NSArray*)markArray startDayOnSunday:(BOOL)sunday timeZone:(NSTimeZone*)timeZone{
	if(!(self=[super initWithFrame:CGRectZero])) return nil;

	
	self.timeZone = timeZone;
	
	firstOfPrev = -1;
	marks = markArray;
	_monthDate = date;
	startOnSunday = sunday;
	
	NSDateComponents *dateInfo = [_monthDate dateComponentsWithTimeZone:self.timeZone];
	firstWeekday = dateInfo.weekday;
	
	
	NSDate *prev = [_monthDate previousMonthWithTimeZone:self.timeZone];
	daysInMonth = [[_monthDate nextMonthWithTimeZone:self.timeZone] daysBetweenDate:_monthDate];
	
	
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:date startOnSunday:sunday timeZone:self.timeZone];
	self.datesArray = dates;
	NSUInteger numberOfDaysBetween = [dates[0] daysBetweenDate:[dates lastObject]];
	NSUInteger scale = (numberOfDaysBetween / 7) + 1;
	CGFloat h = 44.0f * scale;
	
	
	NSDateComponents *todayInfo = [[NSDate date] dateComponentsWithTimeZone:self.timeZone];
	today = dateInfo.month == todayInfo.month && dateInfo.year == todayInfo.year ? todayInfo.day : -5;
	
	int preDayCnt = [prev daysBetweenDate:_monthDate];
	if(firstWeekday>1 && sunday){
		firstOfPrev = preDayCnt - firstWeekday+2;
		lastOfPrev = preDayCnt;
	}else if(!sunday && firstWeekday != 2){
		
		if(firstWeekday ==1){
			firstOfPrev = preDayCnt - 5;
		}else{
			firstOfPrev = preDayCnt - firstWeekday+3;
		}
		lastOfPrev = preDayCnt;
	}
	
	
	self.frame = CGRectMake(0, 1.0, 320.0f, h+1);
	
	[self.selectedImageView addSubview:self.currentDay];
	[self.selectedImageView addSubview:self.dot];
	self.multipleTouchEnabled = NO;


	return self;
}
- (void) setTarget:(id)t action:(SEL)a{
	target = t;
	action = a;
}


- (CGRect) rectForCellAtIndex:(int)index{
	
	int row = index / 7;
	int col = index % 7;
	
	return CGRectMake(col*46, row*44+6, 47, 45);
}
- (void) drawTileInRect:(CGRect)r day:(int)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2{
	
	NSString *str = [NSString stringWithFormat:@"%d",day];
	
	
	r.size.height -= 2;
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: NSLineBreakByWordWrapping
		  alignment: NSTextAlignmentCenter];
	
	if(mark){
		r.size.height = 10;
		r.origin.y += 18;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: NSLineBreakByWordWrapping 
			   alignment: NSTextAlignmentCenter];
	}
	


}
- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage *tile = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Date Tile.png")];
	CGRect r = CGRectMake(0, 0, 46, 44);
	CGContextDrawTiledImage(context, r, tile.CGImage);
	
	if(today > 0){
		int pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		int index = today +  pre-1;
		CGRect r =[self rectForCellAtIndex:index];
		r.origin.y -= 7;
		[[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Today Tile.png")] drawInRect:r];
	}
	
	int index = 0;
	
	UIFont *font = [UIFont boldSystemFontOfSize:dateFontSize];
	UIFont *font2 =[UIFont boldSystemFontOfSize:dotFontSize];
	UIColor *color = [UIColor grayColor];
	
	if(firstOfPrev>0){
		[color set];
		for(int i = firstOfPrev;i<= lastOfPrev;i++){
			r = [self rectForCellAtIndex:index];
			if ([marks count] > 0)
				[self drawTileInRect:r day:i mark:[marks[index] boolValue] font:font font2:font2];
			else
				[self drawTileInRect:r day:i mark:NO font:font font2:font2];
			index++;
		}
	}
	
	
	color = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	[color set];
	for(int i=1; i <= daysInMonth; i++){
		
		r = [self rectForCellAtIndex:index];
		if(today == i) [[UIColor whiteColor] set];
		
		if ([marks count] > 0) 
			[self drawTileInRect:r day:i mark:[marks[index] boolValue] font:font font2:font2];
		else
			[self drawTileInRect:r day:i mark:NO font:font font2:font2];
		if(today == i) [color set];
		index++;
	}
	
	[[UIColor grayColor] set];
	int i = 1;
	while(index % 7 != 0){
		r = [self rectForCellAtIndex:index];
		if ([marks count] > 0 && index < marks.count)
			[self drawTileInRect:r day:i mark:[marks[index] boolValue] font:font font2:font2];
		else
			[self drawTileInRect:r day:i mark:NO font:font font2:font2];
		i++;
		index++;
	}
	
	
}

- (void) selectDay:(int)day{
	
	int pre = firstOfPrev < 0 ?  0 : lastOfPrev - firstOfPrev + 1;
	
	int tot = day + pre;
	int row = tot / 7;
	int column = (tot % 7)-1;
	
	selectedDay = day;
	selectedPortion = 1;
	
	
	if(day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		
		

		NSString *path = TKBUNDLE(@"calendar/Month Calendar Date Tile Selected.png");
		self.selectedImageView.image = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
		markWasOnToday = NO;
	}
	
	
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
	if ([marks count] > 0) {
		
		if([marks[row * 7 + column] boolValue]){
			[self.selectedImageView addSubview:self.dot];
		}else{
			[self.dot removeFromSuperview];
		}
		
		
	}else{
		[self.dot removeFromSuperview];
	}
	
	if(column < 0){
		column = 6;
		row--;
	}
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	
	
	
}
- (NSDate*) dateSelected{
	if(selectedDay < 1 || selectedPortion != 1) return nil;
	
	NSDateComponents *info = [_monthDate dateComponentsWithTimeZone:self.timeZone];
	info.hour = 0;
	info.minute = 0;
	info.second = 0;
	info.day = selectedDay;
	NSDate *d = [NSDate dateWithDateComponents:info];
	
		
	
	return d;
	
}

#pragma mark Touches
- (void) reactToTouch:(UITouch*)touch down:(BOOL)down{
	
	CGPoint p = [touch locationInView:self];
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	int column = p.x / 46, row = p.y / 44;
	int day = 1, portion = 0;
	
	if(row == (int) (self.bounds.size.height / 44)) row --;
	
	int fir = firstWeekday - 1;
	if(!startOnSunday && fir == 0) fir = 7;
	if(!startOnSunday) fir--;
	
	
	if(row==0 && column < fir){
		day = firstOfPrev + column;
	}else{
		portion = 1;
		day = row * 7 + column  - firstWeekday+2;
		if(!startOnSunday) day++;
		if(!startOnSunday && fir==6) day -= 7;

	}
	if(portion > 0 && day > daysInMonth){
		portion = 2;
		day = day - daysInMonth;
	}
	
	
	if(portion != 1){
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Date Tile Gray.png")];
		markWasOnToday = YES;
	}else if(portion==1 && day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		
		
		NSString *path = TKBUNDLE(@"calendar/Month Calendar Date Tile Selected.png");
		self.selectedImageView.image = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
		
		markWasOnToday = NO;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
	if ([marks count] > 0) {
		if([marks[row * 7 + column] boolValue])
			[self.selectedImageView addSubview:self.dot];
		else
			[self.dot removeFromSuperview];
	}else{
		[self.dot removeFromSuperview];
	}
	

	
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	if(day == selectedDay && selectedPortion == portion) return;
	
	
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
		[target performSelector:action withObject:@[@(day)]];
		
	}else if(down){
		[target performSelector:action withObject:@[@(day),@(portion)]];
		selectedDay = day;
		selectedPortion = portion;
	}
	
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//[super touchesBegan:touches withEvent:event];
	[self reactToTouch:[touches anyObject] down:NO];
} 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:NO];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:YES];
}

#pragma mark Properties
- (UILabel *) currentDay{
	if(_currentDay) return _currentDay;

	CGRect r = self.selectedImageView.bounds;
	r.origin.y -= 2;
	_currentDay = [[UILabel alloc] initWithFrame:r];
	_currentDay.text = @"1";
	_currentDay.textColor = [UIColor whiteColor];
	_currentDay.backgroundColor = [UIColor clearColor];
	_currentDay.font = [UIFont boldSystemFontOfSize:dateFontSize];
	_currentDay.textAlignment = NSTextAlignmentCenter;
	_currentDay.shadowColor = [UIColor darkGrayColor];
	_currentDay.shadowOffset = CGSizeMake(0, -1);
	return _currentDay;
}
- (UILabel *) dot{
	if(_dot) return _dot;
	
	CGRect r = self.selectedImageView.bounds;
	r.origin.y += 29;
	r.size.height -= 31;
	_dot = [[UILabel alloc] initWithFrame:r];
	_dot.text = @"•";
	_dot.textColor = [UIColor whiteColor];
	_dot.backgroundColor = [UIColor clearColor];
	_dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
	_dot.textAlignment = NSTextAlignmentCenter;
	_dot.shadowColor = [UIColor darkGrayColor];
	_dot.shadowOffset = CGSizeMake(0, -1);
	return _dot;
}
- (UIImageView *) selectedImageView{
	if(_selectedImageView) return _selectedImageView;
	
	NSString *path = TKBUNDLE(@"calendar/Month Calendar Date Tile Selected.png");
	UIImage *img = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	_selectedImageView = [[UIImageView alloc] initWithImage:img];
	_selectedImageView.frame = CGRectMake(0, 0, 47, 45);
	return _selectedImageView;
}

@end



#pragma mark - TKCalendarMonthView
@interface TKCalendarMonthView () {
	
	TKCalendarMonthTiles *currentTile,*oldTile;
	BOOL sunday;
	
}

@property (nonatomic,strong) UIView *tileBox;
@property (nonatomic,strong) UIImageView *topBackground;
@property (nonatomic,strong) UILabel *monthYear;
@property (nonatomic,strong) UIButton *leftArrow;
@property (nonatomic,strong) UIButton *rightArrow;
@property (nonatomic,strong) UIImageView *shadow;

@end

@implementation TKCalendarMonthView

- (id) initWithSundayAsFirst:(BOOL)s timeZone:(NSTimeZone*)timeZone{
	if (!(self = [super initWithFrame:CGRectZero])) return nil;
	self.backgroundColor = [UIColor grayColor];
	
	self.timeZone = timeZone;
	
	sunday = s;
	currentTile = [[TKCalendarMonthTiles alloc] initWithMonth:[[NSDate date] firstOfMonthWithTimeZone:timeZone] marks:nil startDayOnSunday:sunday timeZone:timeZone];
	[currentTile setTarget:self action:@selector(tile:)];
	
	CGRect r = CGRectMake(0, 0, self.tileBox.bounds.size.width, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y);
	self.frame = r;
	
	[self addSubview:self.topBackground];
	self.topBackground.frame = CGRectMake(0, 0, self.bounds.size.width, self.topBackground.frame.size.height);
	[self.tileBox addSubview:currentTile];
	[self addSubview:self.tileBox];
	
	NSDate *date = [NSDate date];
	self.monthYear.text = [date monthYearStringWithTimeZone:self.timeZone];
	[self addSubview:self.monthYear];
	
	
	[self addSubview:self.leftArrow];
	[self addSubview:self.rightArrow];
	[self addSubview:self.shadow];
	self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.bounds.size.width, self.shadow.frame.size.height);
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"eee"];
	dateFormat.timeZone = self.timeZone;
	
	
	NSDateComponents *sund = [[NSDateComponents alloc] init];
	sund.day = 5;
	sund.month = 12;
	sund.year = 2010;
	sund.hour = sund.minute = sund.second = sund.weekday = 0;
	sund.timeZone = self.timeZone;
	
	
	NSString * sun = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 6;
	NSString *mon = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 7;
	NSString *tue = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 8;
	NSString *wed = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 9;
	NSString *thu = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 10;
	NSString *fri = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	sund.day = 11;
	NSString *sat = [dateFormat stringFromDate:[NSDate dateWithDateComponents:sund]];
	
	NSArray *ar;
	if(sunday) ar = @[sun,mon,tue,wed,thu,fri,sat];
	else ar = @[mon,tue,wed,thu,fri,sat,sun];
	
	int i = 0;
	for(NSString *s in ar){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(46 * i, 29, 46, 15)];
		[self addSubview:label];
        
        // Added Accessibility Labels
        if ([s isEqualToString:@"Sun"]) {
            label.accessibilityLabel = @"Sunday";
        } else if ([s isEqualToString:@"Mon"]) {
            label.accessibilityLabel = @"Monday";
        } else if ([s isEqualToString:@"Tue"]) {
            label.accessibilityLabel = @"Tuesday";
        } else if ([s isEqualToString:@"Wed"]) {
            label.accessibilityLabel = @"Wednesday";
        } else if ([s isEqualToString:@"Thu"]) {
            label.accessibilityLabel = @"Thursday";
        } else if ([s isEqualToString:@"Fri"]) {
            label.accessibilityLabel = @"Friday";
        } else if ([s isEqualToString:@"Sat"]) {
            label.accessibilityLabel = @"Saturday";
        }
        
		label.text = s;
		label.textAlignment = NSTextAlignmentCenter;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.font = [UIFont systemFontOfSize:11];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
		i++;
	}
	
	return self;
}
- (id) initWithTimeZone:(NSTimeZone*)timeZone{
	self = [self initWithSundayAsFirst:YES timeZone:[NSTimeZone defaultTimeZone]];
	return self;
}
- (id) initWithSundayAsFirst:(BOOL)s{
	self = [self initWithSundayAsFirst:YES timeZone:[NSTimeZone defaultTimeZone]];
	return self;
}
- (id) init{
	self = [self initWithSundayAsFirst:YES];
	return self;
}

- (void) didMoveToWindow{
	if (self.window)
		[self reloadData];
}

- (NSDate*) dateForMonthChange:(UIView*)sender {
	BOOL isNext = (sender.tag == 1);
	NSDate *nextMonth = isNext ? [currentTile.monthDate nextMonthWithTimeZone:self.timeZone] : [currentTile.monthDate previousMonthWithTimeZone:self.timeZone];
	
	NSDateComponents *nextInfo = [nextMonth dateComponentsWithTimeZone:self.timeZone];
	NSDate *localNextMonth = [NSDate dateWithDateComponents:nextInfo];
	
	return localNextMonth;
}

- (void) changeMonthAnimation:(UIView*)sender{
	
	BOOL isNext = (sender.tag == 1);
	NSDate *nextMonth = isNext ? [currentTile.monthDate nextMonthWithTimeZone:self.timeZone] : [currentTile.monthDate previousMonthWithTimeZone:self.timeZone];
	
	NSDateComponents *nextInfo = [nextMonth dateComponentsWithTimeZone:self.timeZone];
	NSDate *localNextMonth = [NSDate dateWithDateComponents:nextInfo];
	
	
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:nextMonth startOnSunday:sunday timeZone:self.timeZone];
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
	TKCalendarMonthTiles *newTile = [[TKCalendarMonthTiles alloc] initWithMonth:nextMonth marks:ar startDayOnSunday:sunday timeZone:self.timeZone];
	[newTile setTarget:self action:@selector(tile:)];
	
	
	
	int overlap =  0;
	
	if(isNext){
		overlap = [newTile.monthDate isEqualToDate:dates[0]] ? 0 : 44;
	}else{
		overlap = [currentTile.monthDate compare:[dates lastObject]] !=  NSOrderedDescending ? 44 : 0;
	}
	
	float y = isNext ? currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap +2;
	
	newTile.frame = CGRectMake(0, y, newTile.frame.size.width, newTile.frame.size.height);
	newTile.alpha = 0;
	[self.tileBox addSubview:newTile];
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	newTile.alpha = 1;

	[UIView commitAnimations];
	
	
	
	self.userInteractionEnabled = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.4];
	
	
	
	if(isNext){
		
		currentTile.frame = CGRectMake(0, -1 * currentTile.bounds.size.height + overlap + 2, currentTile.frame.size.width, currentTile.frame.size.height);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMakeWithPoint(self.frame.origin, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
		
	}else{
		
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMakeWithPoint(self.tileBox.frame.origin, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		currentTile.frame = CGRectMake(0,  newTile.frame.size.height - overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
	}
	
	
	[UIView commitAnimations];
	
	oldTile = currentTile;
	currentTile = newTile;
	
	
	
	_monthYear.text = [localNextMonth monthYearStringWithTimeZone:self.timeZone];
	
	

}
- (void) changeMonth:(UIButton *)sender{
	
	NSDate *newDate = [self dateForMonthChange:sender];
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:newDate animated:YES] ) 
		return;
	
	
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ) 
		[self.delegate calendarMonthView:self monthWillChange:newDate animated:YES];
	

	
	
	[self changeMonthAnimation:sender];
	if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
		[self.delegate calendarMonthView:self monthDidChange:currentTile.monthDate animated:YES];

}
- (void) animationEnded{
	self.userInteractionEnabled = YES;
	[oldTile removeFromSuperview];
	oldTile = nil;
}

- (NSDate*) dateSelected{
	return [currentTile dateSelected];
}
- (NSDate*) monthDate{
	return [currentTile monthDate];
}
- (void) selectDate:(NSDate*)date{
	NSDateComponents *info = [date dateComponentsWithTimeZone:self.timeZone];
	NSDate *month = [date firstOfMonthWithTimeZone:self.timeZone];
	
	if([month isEqualToDate:[currentTile monthDate]]){
		[currentTile selectDay:info.day];
		return;
	}else {
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:month animated:YES] )
			return;
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] )
			[self.delegate calendarMonthView:self monthWillChange:month animated:YES];
		
		
		NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:month startOnSunday:sunday timeZone:self.timeZone];
		NSArray *data = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
		TKCalendarMonthTiles *newTile = [[TKCalendarMonthTiles alloc] initWithMonth:month 
																			  marks:data 
																   startDayOnSunday:sunday timeZone:self.timeZone];
		[newTile setTarget:self action:@selector(tile:)];
		[currentTile removeFromSuperview];
		currentTile = newTile;
		[self.tileBox addSubview:currentTile];
		self.tileBox.frame = CGRectMake(0, 44, newTile.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);

		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		self.monthYear.text = [date monthYearStringWithTimeZone:self.timeZone];
		[currentTile selectDay:info.day];
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
			[self.delegate calendarMonthView:self monthDidChange:date animated:NO];
		
		
	}
}
- (void) reloadData{
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:[currentTile monthDate] startOnSunday:sunday timeZone:self.timeZone];
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
	
	TKCalendarMonthTiles *refresh = [[TKCalendarMonthTiles alloc] initWithMonth:[currentTile monthDate] marks:ar startDayOnSunday:sunday timeZone:self.timeZone];
	[refresh setTarget:self action:@selector(tile:)];
	
	[self.tileBox addSubview:refresh];
	[currentTile removeFromSuperview];
	currentTile = refresh;
	
}

- (void) tile:(NSArray*)ar{
	
	if([ar count] < 2){
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
			[self.delegate calendarMonthView:self didSelectDate:[self dateSelected]];
	
	}else{
		
		int direction = [[ar lastObject] intValue];
		UIButton *b = direction > 1 ? self.rightArrow : self.leftArrow;
		
		NSDate* newMonth = [self dateForMonthChange:b];
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:newMonth animated:YES])
			return;
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)])					
			[self.delegate calendarMonthView:self monthWillChange:newMonth animated:YES];
		
		
		
		[self changeMonthAnimation:b];
		
		int day = [ar[0] intValue];

	
		NSDateComponents *info = [[currentTile monthDate] dateComponentsWithTimeZone:self.timeZone];
		info.day = day;
        
        NSDate *dateForMonth = [NSDate dateWithDateComponents:info];
		[currentTile selectDay:day];
		
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
			[self.delegate calendarMonthView:self didSelectDate:dateForMonth];
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
			[self.delegate calendarMonthView:self monthDidChange:dateForMonth animated:YES];

		
	}
	
}

#pragma mark Properties
- (UIImageView *) topBackground{
	if(_topBackground) return _topBackground;
	
	_topBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Grid Top Bar.png")]];
	return _topBackground;
}
- (UILabel *) monthYear{
	if(_monthYear) return _monthYear;

	_monthYear = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, self.tileBox.frame.size.width, 38), 40, 6)];
	_monthYear.textAlignment = NSTextAlignmentCenter;
	_monthYear.backgroundColor = [UIColor clearColor];
	_monthYear.font = [UIFont boldSystemFontOfSize:22];
	_monthYear.textColor = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	return _monthYear;
}
- (UIButton *) leftArrow{
	if(_leftArrow) return _leftArrow;

	_leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	_leftArrow.tag = 0;
	_leftArrow.frame = CGRectMake(0, 0, 48, 38);
	_leftArrow.accessibilityLabel = @"Previous Month";
	[_leftArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
	[_leftArrow setImage:[UIImage imageNamedTK:@"calendar/Month Calendar Left Arrow"] forState:0];
	return _leftArrow;
}
- (UIButton *) rightArrow{
	if(_rightArrow) return _rightArrow;

	_rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightArrow.tag = 1;
	_rightArrow.frame = CGRectMake(320-45, 0, 48, 38);
	_rightArrow.accessibilityLabel = @"Next Month";
	[_rightArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
	[_rightArrow setImage:[UIImage imageNamedTK:@"calendar/Month Calendar Right Arrow"] forState:0];
	return _rightArrow;
}
- (UIView *) tileBox{
	if(_tileBox) return _tileBox;
	
	_tileBox = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, currentTile.frame.size.height)];
	_tileBox.clipsToBounds = YES;
	return _tileBox;
}
- (UIImageView *) shadow{
	if(_shadow) return _shadow;

	
	_shadow = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Shadow.png")]];
	return _shadow;
}

@end