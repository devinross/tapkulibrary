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
#import "TKGradientView.h"
#import "UIColor+TKCategory.h"
#import "UIImageView+TKCategory.h"
#import "UIView+TKCategory.h"

static UIColor *gradientColor;
static UIColor *grayGradientColor;
static NSNumberFormatter *numberFormatter = nil;
static UIImage *tileImage;

#define TEXT_COLOR [UIColor colorWithWhite:84/255. alpha:1]
#define TOP_BAR_HEIGHT 45.0f
#define DOT_FONT_SIZE 18.0f
#define DATE_FONT_SIZE 24.0f
#define VIEW_WIDTH 320.0f

#pragma mark - TKCalendarMonthTiles
@interface TKCalendarMonthTiles : UIView {
	NSInteger firstOfPrev,lastOfPrev, today;
	NSInteger selectedDay,selectedPortion;
	NSInteger firstWeekday, daysInMonth;
	BOOL markWasOnToday,startOnSunday;
}

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@property (nonatomic,strong) NSDate *monthDate;
@property (nonatomic,strong) NSMutableArray *accessibleElements;

@property (nonatomic,strong) UIImageView *selectedImageView;
@property (nonatomic,strong) UILabel *currentDay;
@property (nonatomic,strong) UILabel *dot;
@property (nonatomic,strong) NSArray *datesArray;
@property (nonatomic,strong) NSTimeZone *timeZone;
@property (nonatomic,strong) NSArray *marks;


@end


#pragma mark -
@implementation TKCalendarMonthTiles

+ (void) initialize{
    if (self == [TKCalendarMonthTiles class]){
        tileImage = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Date Tile.png")];
    }
}

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
	
	NSDate *firstDate = (self.datesArray)[0];
	
	for(NSInteger i=0;i<self.marks.count;i++){
		UIAccessibilityElement *element = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
		
		NSDate *day = [NSDate dateWithTimeIntervalSinceReferenceDate:[firstDate timeIntervalSinceReferenceDate]+(24*60*60*i)+5];
		element.accessibilityLabel = [formatter stringForObjectValue:day];
		
		CGRect r = [self convertRect:[self rectForCellAtIndex:i] toView:self.window];
		r.origin.y -= 6;
		
		element.accessibilityFrame = r;
		element.accessibilityTraits = UIAccessibilityTraitButton;
		element.accessibilityValue = [(self.marks)[i] boolValue] ? @"Has Events" : @"No Events";
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
		
		NSInteger preDayCnt = [previousMonth daysBetweenDate:currentMonth];		
		info2.day = preDayCnt - info.weekday + 2;
		firstDate = [NSDate dateWithDateComponents:info2];
		
		
	}else if(!sunday && info.weekday != 2){
		
		NSDateComponents *info2 = [previousMonth dateComponentsWithTimeZone:timeZone];
		NSInteger preDayCnt = [previousMonth daysBetweenDate:currentMonth];
		if(info.weekday==1){
			info2.day = preDayCnt - 5;
		}else{
			info2.day = preDayCnt - info.weekday + 3;
		}
		firstDate = [NSDate dateWithDateComponents:info2];
		
		
		
	}else{
		firstDate = currentMonth;
	}
	
	
	
	NSInteger daysInMonth = [currentMonth daysBetweenDate:nextMonth];		
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
	self.marks = markArray;
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
	
	NSInteger preDayCnt = [prev daysBetweenDate:_monthDate];
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
	
	
	self.frame = CGRectMake(0, 1.0, VIEW_WIDTH, h+1);
	
	[self.selectedImageView addSubview:self.currentDay];
	[self.selectedImageView addSubview:self.dot];
	self.multipleTouchEnabled = NO;


	return self;
}
- (void) setTarget:(id)t action:(SEL)a{
	self.target = t;
	self.action = a;
}


- (CGRect) rectForCellAtIndex:(NSInteger)index{
	
	NSInteger row = index / 7;
	NSInteger col = index % 7;
	
	return CGRectMake(col*46-1, row*44+6, 46, 44);
}
- (void) drawTileInRect:(CGRect)r day:(NSInteger)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2 context:(CGContextRef)context{

    NSString *str = [numberFormatter stringFromNumber:@(day)];
	r.size.height -= 2;
	
	CGContextSetPatternPhase(context, CGSizeMake(r.origin.x, r.origin.y - 2));

	
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: NSLineBreakByWordWrapping
		  alignment: NSTextAlignmentCenter];
	
	if(mark){
		r.size.height = 10;
		r.origin.y += 19;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: NSLineBreakByWordWrapping 
			   alignment: NSTextAlignmentCenter];
	}
	


}
- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage *tile = tileImage;
	CGRect r = CGRectMake(-1, 0, 46, 44);
	
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	CGContextDrawTiledImage(context, r, tile.CGImage);
	
	if(today > 0){
		NSInteger pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		NSInteger index = today +  pre-1;
		CGRect r = [self rectForCellAtIndex:index];
		r.origin.y -= 6;
		[[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Today Tile.png")] drawInRect:r];
	}
	
	
	
	float myColorValues[] = {1, 1, 1, .8};
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef whiteColor = CGColorCreate(myColorSpace, myColorValues);
	CGContextSetShadowWithColor(context, CGSizeMake(0,1), 0, whiteColor);

	float darkColorValues[] = {0, 0, 0, .5};
    CGColorRef darkColor = CGColorCreate(myColorSpace, darkColorValues);
	

	NSInteger index = 0, mc = self.marks.count;
	
	
	UIFont *font = [UIFont boldSystemFontOfSize:DATE_FONT_SIZE];
	UIFont *font2 =[UIFont boldSystemFontOfSize:DOT_FONT_SIZE];
	UIColor *color = grayGradientColor;
	
	if(firstOfPrev>0){
		[color set];
		for(NSInteger i = firstOfPrev;i<= lastOfPrev;i++){
			r = [self rectForCellAtIndex:index];
			
			BOOL mark = mc > 0 && index < mc ? [self.marks[index] boolValue] : NO;
			[self drawTileInRect:r day:i mark:mark font:font font2:font2 context:context];

			index++;
		}
	}
	
	
	color = gradientColor;
	[color set];
	

	
	
	for(NSInteger i=1; i <= daysInMonth; i++){
		
		r = [self rectForCellAtIndex:index];
		if(today == i){
			CGContextSetShadowWithColor(context, CGSizeMake(0,-1), 0, darkColor);
			[[UIColor whiteColor] set];
			r.origin.y += 1;
		}
		
		BOOL mark = mc > 0 && index < mc ? [self.marks[index] boolValue] : NO;
		[self drawTileInRect:r day:i mark:mark font:font font2:font2 context:context];
		
		if(today == i){
			CGContextSetShadowWithColor(context, CGSizeMake(0,1), 0, whiteColor);
			[color set];
		}
		index++;
	}
	
	CGColorRelease(darkColor);
	CGColorRelease(whiteColor);
	CGColorSpaceRelease(myColorSpace);
	
	[grayGradientColor set];
	NSInteger i = 1;
	while(index % 7 != 0){
		r = [self rectForCellAtIndex:index];
		BOOL mark = mc > 0 && index < mc ? [self.marks[index] boolValue] : NO;
		[self drawTileInRect:r day:i mark:mark font:font font2:font2 context:context];
		i++;
		index++;
	}
	
	
}

- (BOOL) selectDay:(NSInteger)day{
	NSInteger pre = firstOfPrev < 0 ?  0 : lastOfPrev - firstOfPrev + 1;
	
	NSInteger tot = day + pre;
	NSInteger row = tot / 7;
	NSInteger column = (tot % 7)-1;
	
	selectedDay = day;
	selectedPortion = 1;
	self.currentDay.font = [UIFont boldSystemFontOfSize:DATE_FONT_SIZE];

	
	BOOL hasDot = NO;
	
	if(day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
		
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		NSString *path = TKBUNDLE(@"calendar/Month Calendar Date Tile Selected.png");
		self.selectedImageView.image = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
		markWasOnToday = NO;
	}
	
		
	self.currentDay.text = [numberFormatter stringFromNumber:@(day)];
	
	if (self.marks.count > 0) {
		
		if([self.marks[row * 7 + column] boolValue]){
			hasDot = YES;
			[self.selectedImageView addSubview:self.dot];
		}else
			[self.dot removeFromSuperview];
		
	}else [self.dot removeFromSuperview];
	
	if(column < 0){
		column = 6;
		row--;
	}

	self.selectedImageView.frame = CGRectMakeWithSize((column*46)-1, (row*44)-1, self.selectedImageView.frame.size);
	[self addSubview:self.selectedImageView];
	
	
	return hasDot;
	
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
	/*
	 When a UIViewController allocated and pushViewController it in delegate.- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)date.
	 p.x is over self.bounds.size.width(a cause -- unknown).
	 And column becomes 7 or more.
	 It is if it is the 4th [ or more ] row, App will crash (e.g. select 2012/07/29).
	 So I added check range of p.x.
	 */
	if(p.x > self.bounds.size.width || p.x < 0) return;
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	NSInteger column = p.x / 46, row = p.y / 44;
	NSInteger day = 1, portion = 0;
	
	if(row == (int) (self.bounds.size.height / 44)) row --;
	
	NSInteger fir = firstWeekday - 1;
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
	
	self.currentDay.font = [UIFont boldSystemFontOfSize:DATE_FONT_SIZE];
	self.currentDay.hidden = NO;
	self.dot.hidden = NO;
	
	if(portion != 1){
		markWasOnToday = YES;
		self.selectedImageView.image = nil;
		self.selectedImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
		self.currentDay.hidden = YES;
		self.dot.hidden = YES;
		
	}else if(portion==1 && day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.dot.shadowOffset = CGSizeMake(0, -1);
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
	
	if (self.marks.count > 0) {
		if([self.marks[row * 7 + column] boolValue])
			[self.selectedImageView addSubview:self.dot];
		else
			[self.dot removeFromSuperview];
	}else{
		[self.dot removeFromSuperview];
	}
	

	
	
	self.selectedImageView.frame = CGRectMakeWithSize((column*46)-1, (row*44)-1, self.selectedImageView.frame.size);
	
	if(day == selectedDay && selectedPortion == portion) return;
	
	
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
		[self.target performSelector:self.action withObject:@[@(day)]];
		
	}else if(down){
		[self.target performSelector:self.action withObject:@[@(day),@(portion)]];
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
	r.origin.y -= 1;
	_currentDay = [[UILabel alloc] initWithFrame:r];
	_currentDay.text = @"1";
	_currentDay.textColor = [UIColor whiteColor];
	_currentDay.backgroundColor = [UIColor clearColor];
	_currentDay.font = [UIFont boldSystemFontOfSize:DATE_FONT_SIZE];
	_currentDay.textAlignment = NSTextAlignmentCenter;
	_currentDay.shadowColor = [UIColor darkGrayColor];
	_currentDay.shadowOffset = CGSizeMake(0, -1);
	return _currentDay;
}
- (UILabel *) dot{
	if(_dot) return _dot;
	
	CGRect r = self.selectedImageView.bounds;
	r.origin.y += 30;
	r.size.height -= 31;
	_dot = [[UILabel alloc] initWithFrame:r];
	_dot.text = @"•";
	_dot.textColor = [UIColor whiteColor];
	_dot.backgroundColor = [UIColor clearColor];
	_dot.font = [UIFont boldSystemFontOfSize:DOT_FONT_SIZE];
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
	_selectedImageView.layer.magnificationFilter = kCAFilterNearest;
	_selectedImageView.frame = CGRectMake(0, 0, 47, 45);
	return _selectedImageView;
}

@end



#pragma mark - TKCalendarMonthView
@interface TKCalendarMonthView ()

@property (nonatomic,strong) TKCalendarMonthTiles *currentTile;
@property (nonatomic,strong) TKCalendarMonthTiles *oldTile;
@property (nonatomic,assign) BOOL sunday;
@property (nonatomic,strong) UIView *tileBox;
@property (nonatomic,strong) UIView *topBackground;
@property (nonatomic,strong) UILabel *monthYear;
@property (nonatomic,strong) UIButton *leftArrow;
@property (nonatomic,strong) UIButton *rightArrow;
@property (nonatomic,strong) UIView *shadow;
@property (nonatomic,strong) UIView *dropshadow;

@end

#pragma mark -
@implementation TKCalendarMonthView

+ (void) initialize{
    if (self == [TKCalendarMonthView class]){
		gradientColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/color_gradient.png")]];
		grayGradientColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:TKBUNDLE(@"calendar/color_gradient_gray.png")]];
		numberFormatter = [[NSNumberFormatter alloc] init];
    }
}
- (id) initWithSundayAsFirst:(BOOL)s timeZone:(NSTimeZone*)timeZone{
	if (!(self = [super initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_WIDTH)])) return nil;
	self.backgroundColor = [UIColor colorWithHex:0xaaaeb6];
	self.timeZone = timeZone;
	self.sunday = s;
	
	[self addSubview:self.dropshadow];
	[self addSubview:self.topBackground];
	[self addSubview:self.leftArrow];
	[self addSubview:self.rightArrow];
	[self addSubview:self.tileBox];
	[self addSubview:self.monthYear];
	[self addSubview:self.shadow];

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	dateFormat.dateFormat = @"eee";
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
	if(self.sunday) ar = @[sun,mon,tue,wed,thu,fri,sat];
	else ar = @[mon,tue,wed,thu,fri,sat,sun];
	
	NSInteger i = 0;
	for(NSString *s in ar){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(46*i + (i==0?0:-1), 30, 45, 15)];
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
		label.font = [UIFont boldSystemFontOfSize:10];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = TEXT_COLOR;
		i++;
	}
	
	return self;
}
- (id) initWithTimeZone:(NSTimeZone*)timeZone{
	self = [self initWithSundayAsFirst:YES timeZone:timeZone];
	return self;
}
- (id) initWithSundayAsFirst:(BOOL)sunday{
	self = [self initWithSundayAsFirst:sunday timeZone:[NSTimeZone defaultTimeZone]];
	return self;
}
- (id) init{
	self = [self initWithSundayAsFirst:YES];
	return self;
}
- (id) initWithFrame:(CGRect)frame{
	self = [self init];
	return self;
}

- (void) didMoveToWindow{
	if (self.window && !self.currentTile)
		[self _setupCurrentTileView:[NSDate date]];
}

#pragma mark Private Methods for setting up tiles
- (void) _setupCurrentTileView:(NSDate*)date{
	if(self.currentTile) return;
	
	NSDate *month = [date firstOfMonthWithTimeZone:self.timeZone];
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:month startOnSunday:self.sunday timeZone:self.timeZone];
	NSArray *data = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
	
	self.currentTile = [[TKCalendarMonthTiles alloc] initWithMonth:month marks:data startDayOnSunday:self.sunday timeZone:self.timeZone];
	[self.currentTile setTarget:self action:@selector(_tileSelectedWithData:)];
	
	[self.tileBox addSubview:self.currentTile];
	
	self.monthYear.text = [date monthYearStringWithTimeZone:self.timeZone];
	[self _updateSubviewFramesWithTile:self.currentTile];
	
}
- (CGRect) _calculatedFrame{
	return CGRectMakeWithPoint(self.frame.origin, VIEW_WIDTH, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y);
}
- (CGRect) _calculatedDropShadowFrame{
	return CGRectMake(0, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y, self.bounds.size.width, 6);
}
- (void) _updateSubviewFramesWithTile:(UIView*)tile{
	self.tileBox.frame = CGRectMake(0, TOP_BAR_HEIGHT-1,VIEW_WIDTH, tile.frame.size.height);
	self.frame = CGRectMakeWithPoint(self.frame.origin, VIEW_WIDTH, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
	self.shadow.frame = self.tileBox.frame;
	self.dropshadow.frame = [self _calculatedDropShadowFrame];
}

#pragma mark Button Action
- (void) changeMonth:(UIButton *)sender{
	
	NSDate *newDate = [self _dateForMonthChange:sender];
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:newDate animated:YES] )
		return;
	
	
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] )
		[self.delegate calendarMonthView:self monthWillChange:newDate animated:YES];
	
	
	[self changeMonthAnimation:sender];
	if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
		[self.delegate calendarMonthView:self monthDidChange:self.currentTile.monthDate animated:YES];
	
}

- (void) animateToNextOrPreviousMonth:(BOOL)next{
	[self changeMonth:next ? self.rightArrow : self.leftArrow];
}

#pragma mark Moving the tiles up and down
- (void) _tileSelectedWithData:(NSArray*)ar{
	
	if(ar.count < 2){
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
			[self.delegate calendarMonthView:self didSelectDate:[self dateSelected]];
		
	}else{
		
		NSInteger direction = [[ar lastObject] intValue];
		UIButton *b = direction > 1 ? self.rightArrow : self.leftArrow;
		
		NSDate* newMonth = [self _dateForMonthChange:b];
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:newMonth animated:YES])
			return;
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)])
			[self.delegate calendarMonthView:self monthWillChange:newMonth animated:YES];
		
		[self changeMonthAnimation:b];
		NSInteger day = [ar[0] intValue];
		
		NSDateComponents *info = [[self.currentTile monthDate] dateComponentsWithTimeZone:self.timeZone];
		info.day = day;
        
        NSDate *dateForMonth = [NSDate dateWithDateComponents:info];
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
			[self.delegate calendarMonthView:self didSelectDate:dateForMonth];
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
			[self.delegate calendarMonthView:self monthDidChange:dateForMonth animated:YES];
		
		[self.currentTile selectDay:day];
		
		
	}
	
}
- (NSDate*) _dateForMonthChange:(UIView*)sender {
	BOOL isNext = (sender.tag == 1);
	NSDate *nextMonth = isNext ? [self.currentTile.monthDate nextMonthWithTimeZone:self.timeZone] : [self.currentTile.monthDate previousMonthWithTimeZone:self.timeZone];
	
	NSDateComponents *nextInfo = [nextMonth dateComponentsWithTimeZone:self.timeZone];
	NSDate *localNextMonth = [NSDate dateWithDateComponents:nextInfo];
	
	return localNextMonth;
}
- (void) changeMonthAnimation:(UIView*)sender{
	
	BOOL isNext = (sender.tag == 1);
	NSDate *nextMonth = isNext ? [self.currentTile.monthDate nextMonthWithTimeZone:self.timeZone] : [self.currentTile.monthDate previousMonthWithTimeZone:self.timeZone];
	
	NSDateComponents *nextInfo = [nextMonth dateComponentsWithTimeZone:self.timeZone];
	NSDate *localNextMonth = [NSDate dateWithDateComponents:nextInfo];
	
	
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:nextMonth startOnSunday:self.sunday timeZone:self.timeZone];
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
	TKCalendarMonthTiles *newTile = [[TKCalendarMonthTiles alloc] initWithMonth:nextMonth marks:ar startDayOnSunday:self.sunday timeZone:self.timeZone];
	[newTile setTarget:self action:@selector(_tileSelectedWithData:)];
	
	
	NSInteger overlap =  0;
	
	if(isNext)
		overlap = [newTile.monthDate isEqualToDate:dates[0]] ? 0 : 44;
	else
		overlap = [self.currentTile.monthDate compare:[dates lastObject]] !=  NSOrderedDescending ? 44 : 0;
	
	
	float y = isNext ? self.currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap +2;
	
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
		self.currentTile.frame = CGRectMakeWithSize(0, -1 * self.currentTile.bounds.size.height + overlap + 2,  self.currentTile.frame.size);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
	}else{
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.currentTile.frame = CGRectMakeWithSize(0,  newTile.frame.size.height - overlap, self.currentTile.frame.size);
	}
	
	[self _updateSubviewFramesWithTile:newTile];

	[UIView commitAnimations];
	
	self.oldTile = self.currentTile;
	self.currentTile = newTile;
	_monthYear.text = [localNextMonth monthYearStringWithTimeZone:self.timeZone];
	

}
- (void) animationEnded{
	self.userInteractionEnabled = YES;
	[self.oldTile removeFromSuperview];
	self.oldTile = nil;
}


#pragma mark Properties & Public Functions
- (UIView *) topBackground{
	if(_topBackground) return _topBackground;
	
	TKGradientView *gradient = [[TKGradientView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TOP_BAR_HEIGHT)];
	gradient.colors = @[[UIColor colorWithHex:0xf4f4f5],[UIColor colorWithHex:0xccccd1]];
	gradient.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, gradient.bounds.size.width, 1)];
	line.backgroundColor = [UIColor colorWithHex:0xaaaeb6];
	line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[gradient addSubview:line];
	
	gradient.userInteractionEnabled = YES;
	_topBackground = gradient;
	return _topBackground;
}
- (UILabel *) monthYear{
	if(_monthYear) return _monthYear;

	_monthYear = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, VIEW_WIDTH, 36), 40, 6)];
	_monthYear.textAlignment = NSTextAlignmentCenter;
	_monthYear.backgroundColor = [UIColor clearColor];
	_monthYear.font = [UIFont boldSystemFontOfSize:22];
	_monthYear.shadowColor = [UIColor whiteColor];
	_monthYear.shadowOffset = CGSizeMake(0,1);
	_monthYear.textColor = gradientColor;
	return _monthYear;
}
- (UIButton *) leftArrow{
	if(_leftArrow) return _leftArrow;

	_leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	_leftArrow.tag = 0;
	_leftArrow.frame = CGRectMake(0, 0, 52, 36);
	_leftArrow.accessibilityLabel = @"Previous Month";
	[_leftArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
	[_leftArrow setImage:[UIImage imageNamedTK:@"calendar/calendar_left_arrow"] forState:0];
	return _leftArrow;
}
- (UIButton *) rightArrow{
	if(_rightArrow) return _rightArrow;

	_rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightArrow.tag = 1;
	_rightArrow.frame = CGRectMake(VIEW_WIDTH-52, 0, 52, 36);
	_rightArrow.accessibilityLabel = @"Next Month";
	[_rightArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
	[_rightArrow setImage:[UIImage imageNamedTK:@"calendar/calendar_right_arrow"] forState:0];
	return _rightArrow;
}
- (UIView *) tileBox{
	if(_tileBox) return _tileBox;
	
	CGFloat h = self.currentTile ? self.currentTile.frame.size.height : 100;
	
	_tileBox = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT-1, VIEW_WIDTH, h)];
	_tileBox.clipsToBounds = YES;
	return _tileBox;
}
- (UIView *) shadow{
	if(_shadow) return _shadow;
	
	TKGradientView *grad  = [[TKGradientView alloc] initWithFrame:CGRectMake(0, 0, 100, self.frame.size.width)];
	grad.colors = @[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:0.0],[UIColor colorWithWhite:0 alpha:0.1]];
	_shadow = grad;
	_shadow.userInteractionEnabled = NO;
	return _shadow;
}
- (UIView *) dropshadow{
	if(_dropshadow) return _dropshadow;
	
	TKGradientView *grad  = [[TKGradientView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
	grad.backgroundColor = [UIColor clearColor];
	grad.colors = @[[UIColor colorWithWhite:0 alpha:0.3],[UIColor colorWithWhite:0 alpha:0.0]];
	_dropshadow = grad;
	_dropshadow.userInteractionEnabled = NO;
	return _dropshadow;
}

- (NSDate*) dateSelected{
	if(self.currentTile==nil) return nil;
	return [self.currentTile dateSelected];
}
- (NSDate*) monthDate{
	if(self.currentTile==nil)
		return [[NSDate date] monthDateWithTimeZone:self.timeZone];
	return [self.currentTile monthDate];
}
- (BOOL) selectDate:(NSDate*)date{
	if(date==nil) return NO;
	
	
	NSDateComponents *info = [date dateComponentsWithTimeZone:self.timeZone];
	NSDate *month = [date firstOfMonthWithTimeZone:self.timeZone];
	
	BOOL ret = NO;
	if([month isEqualToDate:[self.currentTile monthDate]]){
		ret = [self.currentTile selectDay:info.day];
	}else {
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:month animated:YES])
			return NO;
		
		if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] )
			[self.delegate calendarMonthView:self monthWillChange:month animated:YES];
		
		
		[self.currentTile removeFromSuperview];
		self.currentTile = nil;
		
		[self _setupCurrentTileView:date];
		[self.currentTile selectDay:info.day];
		
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
			[self.delegate calendarMonthView:self monthDidChange:date animated:NO];
		
		ret = [self.currentTile selectDay:info.day];
		
	}
	
	if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
		[self.delegate calendarMonthView:self didSelectDate:[self dateSelected]];
	
	return ret;
}
- (void) reloadData{
	
	NSDate *d = self.currentTile.dateSelected;
	[self.currentTile removeFromSuperview];
	
	NSArray *dates = [TKCalendarMonthTiles rangeOfDatesInMonthGrid:[self.currentTile monthDate] startOnSunday:self.sunday timeZone:self.timeZone];
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:dates[0] toDate:[dates lastObject]];
	
	TKCalendarMonthTiles *refresh = [[TKCalendarMonthTiles alloc] initWithMonth:[self.currentTile monthDate] marks:ar startDayOnSunday:self.sunday timeZone:self.timeZone];
	[refresh setTarget:self action:@selector(_tileSelectedWithData:)];
	
	[self.tileBox addSubview:refresh];
	[self.currentTile removeFromSuperview];
	self.currentTile = refresh;
	
	if(d){
		NSDateComponents *c = [d dateComponentsWithTimeZone:self.timeZone];
		[self.currentTile selectDay:c.day];
	}
	
}


@end