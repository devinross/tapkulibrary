//
//  TKCalendarMonthView.m
//  Created by Devin Ross on 6/9/10.
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

#import "TKCalendarMonthTiles.h"
#import "NSDate+TKCategory.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"

#define dotFontSize 18.0
#define dateFontSize 22.0


@interface TKCalendarMonthTiles (private)

@property (readonly) UIImageView *selectedImageView;
@property (readonly) UILabel *currentDay;
@property (readonly) UILabel *dot;
@end

@implementation TKCalendarMonthTiles
@synthesize monthDate;

+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday{
	
	NSDate *firstDate, *lastDate;
	
	TKDateInformation info = [date dateInformation];
	info.day = 1;
	NSDate *d = [NSDate dateFromDateInformation:info];
	info = [d dateInformation];
	
	if(info.weekday > 1){
		TKDateInformation info2 = info;
		

		info2.month--;
		if(info2.month<1) { info2.month = 12; info2.year--; }
		NSDate *previousMonth = [NSDate dateFromDateInformation:info2];
		int preDayCnt = [previousMonth daysInMonth];		
		info2.day = preDayCnt - info.weekday+2;
		
		firstDate = [NSDate dateFromDateInformation:info2];
		
		
		
	}else{
		firstDate = d;
	}
	
	
	
	
	int daysInMonth = [d daysInMonth];
	info.day = daysInMonth;
	NSDate *lastInMonth = [NSDate dateFromDateInformation:info];
	info = [lastInMonth dateInformation];
	if(info.weekday < 7){
		info.day = 7 - info.weekday;
		info.month++;
		if(info.month>12){
			info.month = 1;
			info.year++;
		}
		lastDate = [NSDate dateFromDateInformation:info];
	}else{
		lastDate = lastInMonth;
	}
	
	return [NSArray arrayWithObjects:firstDate,lastDate,nil];
}

- (id) initWithMonth:(NSDate*)date marks:(NSArray*)markArray startDayOnSunday:(BOOL)sunday{
	
	firstOfPrev = -1;
	marks = [markArray retain];
	monthDate = [date retain];
	startOnSunday = sunday;
		
	TKDateInformation dateInfo = [monthDate dateInformation];
	firstWeekday = dateInfo.weekday;
	daysInMonth = [date daysInMonth]; 
	int row = (daysInMonth + dateInfo.weekday - 1);
	row = (row / 7) + ((row % 7 == 0) ? 0:1);
	float h = 44 * row;
	
	TKDateInformation todayInfo = [[NSDate date] dateInformation];
	today = dateInfo.month == todayInfo.month && dateInfo.year == todayInfo.year ? todayInfo.day : 0;
	
	
	if(firstWeekday>1){
		dateInfo.month--;
		if(dateInfo.month<1) {
			dateInfo.month = 12;
			dateInfo.year--;
		}
		NSDate *previousMonth = [NSDate dateFromDateInformation:dateInfo];
		int preDayCnt = [previousMonth daysInMonth];		
		firstOfPrev = preDayCnt - firstWeekday+2;
		lastOfPrev = preDayCnt;
	}
	
	if(![super initWithFrame:CGRectMake(0, 1, 320, h+1)]) return nil;
	
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
	  lineBreakMode: UILineBreakModeWordWrap 
		  alignment: UITextAlignmentCenter];
	
	if(mark){
		r.size.height = 10;
		r.origin.y += 18;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: UILineBreakModeWordWrap 
			   alignment: UITextAlignmentCenter];
	}
	
	
}
- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage *tile = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile.png")];
	CGRect r = CGRectMake(0, 0, 46, 44);
	CGContextDrawTiledImage(context, r, tile.CGImage);
	
	if(today > 0){
		int pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		int index = today +  pre-1;
		CGRect r =[self rectForCellAtIndex:index];
		r.origin.y -= 7;
		[[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Tile.png")] drawInRect:r];
	}
	
	int index = 0;
	
	UIFont *font = [UIFont boldSystemFontOfSize:dateFontSize];
	UIFont *font2 =[UIFont boldSystemFontOfSize:dotFontSize];
	UIColor *color = [UIColor grayColor];
	
	if(firstOfPrev>0){
		[color set];
		for(int i = firstOfPrev;i<= lastOfPrev;i++){
			r = [self rectForCellAtIndex:index] ;
			[self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue] font:font font2:font2];
			index++;
		}
	}
	

	color = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	[color set];
	for(int i=1; i <= daysInMonth; i++){
		
		r = [self rectForCellAtIndex:index];
		if(today == i) [[UIColor whiteColor] set];
	
		[self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue] font:font font2:font2];
		if(today == i) [color set];
		index++;
	}
	
	[[UIColor grayColor] set];
	int i = 1;
	while(index % 7 != 0){
		r = [self rectForCellAtIndex:index] ;
		[self drawTileInRect:r day:i mark:[[marks objectAtIndex:index] boolValue] font:font font2:font2];
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
		self.selectedImageView.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		
		self.selectedImageView.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected.png")];
		markWasOnToday = NO;
	}
	
	
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	if([[marks objectAtIndex: row * 7 + column ] boolValue]){
		[self.selectedImageView addSubview:self.dot];
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
	
	TKDateInformation info = [monthDate dateInformation];
	info.day = selectedDay;
	return [NSDate dateFromDateInformation:info];
	
	
}



- (void) reactToTouch:(UITouch*)touch down:(BOOL)down{
	
	CGPoint p = [touch locationInView:self];
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	int column = p.x / 46, row = p.y / 44;
	int day = 1, portion = 0;
	
	if(row == (int) (self.bounds.size.height / 44)) row --;
	
	
	if(row==0 && column < firstWeekday-1){
		day = firstOfPrev + column;
	}else{
		portion = 1;
		day = row * 7 + column  - firstWeekday+2;
	}
	if(portion > 0 && day > daysInMonth){
		portion = 2;
		day = day - daysInMonth;
	}
	
	if(portion != 1){
		self.selectedImageView.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Gray.png")];
		markWasOnToday = YES;
	}else if(portion==1 && day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Today Selected Tile.png")];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected.png")];
		markWasOnToday = NO;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
	if([[marks objectAtIndex: row * 7 + column] boolValue])
		[self.selectedImageView addSubview:self.dot];
	else
		[self.dot removeFromSuperview];
	
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	if(day == selectedDay && selectedPortion == portion) return;
	
	
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
		[target performSelector:action withObject:[NSArray arrayWithObject:[NSNumber numberWithInt:day]]];

	}
	else if(down){
		[target performSelector:action withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:day],[NSNumber numberWithInt:portion],nil]];
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

- (UILabel *) currentDay{
	if(currentDay==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y -= 2;
		currentDay = [[UILabel alloc] initWithFrame:r];
		currentDay.text = @"1";
		currentDay.textColor = [UIColor whiteColor];
		currentDay.backgroundColor = [UIColor clearColor];
		currentDay.font = [UIFont boldSystemFontOfSize:dateFontSize];
		currentDay.textAlignment = UITextAlignmentCenter;
		currentDay.shadowColor = [UIColor darkGrayColor];
		currentDay.shadowOffset = CGSizeMake(0, -1);
	}
	return currentDay;
}
- (UILabel *) dot{
	if(dot==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y += 29;
		r.size.height -= 31;
		dot = [[UILabel alloc] initWithFrame:r];
		
		dot.text = @"•";
		dot.textColor = [UIColor whiteColor];
		dot.backgroundColor = [UIColor clearColor];
		dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
		dot.textAlignment = UITextAlignmentCenter;
		dot.shadowColor = [UIColor darkGrayColor];
		dot.shadowOffset = CGSizeMake(0, -1);
	}
	return dot;
}
- (UIImageView *) selectedImageView{
	if(selectedImageView==nil){
		selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/calendar/Month Calendar Date Tile Selected"]];
	}
	return selectedImageView;
}

- (void)dealloc {
	[currentDay release];
	[dot release];
	[selectedImageView release];
	[marks release];
	[monthDate release];
    [super dealloc];
}


@end
