//
//  TKCalendarView.m
//  Created by Devin Ross on 7/28/09.
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
#import "NSDateAdditions.h"
#import "TKCalendarMonthView.h"
#import "TKGlobal.h"
#import "UIViewAdditions.h"
#import "UIImageAdditions.h"



#pragma mark TKMonthGridView
@interface TKMonthGridView : UIView {
	
	id delegate;
	
	TKCalendarDayView *selectedDay;
	NSMutableArray *dayTiles;
	NSMutableArray *graveYard;
	
	NSArray *marks;
	
	NSDate *dateOfFirst;
	
	
	int weekdayOfFirst;
	int lines;
	
	int todayNumber;
	
	
}

@property (assign, nonatomic) id delegate;

@property (readonly,nonatomic) int lines;
@property (readonly,nonatomic) int weekdayOfFirst;
@property (readonly,nonatomic) NSDate* dateOfFirst;
@property (nonatomic, retain) NSArray *marks;

- (id) initWithStartDate:(NSDate*)theDate today:(NSInteger)todayDay marks:(NSArray*)marksArray;
- (void) selectDay:(int)theDayNumber;
- (void) resetMarks;
- (void) setStartDate:(NSDate*)theDate today:(NSInteger)todayDay marks:(NSArray*)marksArray;

@end

#pragma mark TKCalendarDayView
@interface TKCalendarDayView : UIView {
	NSString *str;
	BOOL selected;
	BOOL active;
	BOOL today;
	BOOL marked;
}

- (id) initWithFrame:(CGRect)frame string:(NSString*)string selected:(BOOL)sel active:(BOOL)act today:(BOOL)tdy marked:(BOOL)mark;
- (void) setString:(NSString*)string selected:(BOOL)sel active:(BOOL)act today:(BOOL)tdy marked:(BOOL)mark;

@property (copy,nonatomic) NSString *str;
@property (assign,nonatomic) BOOL selected;
@property (assign,nonatomic) BOOL active;
@property (assign,nonatomic) BOOL today;
@property (assign,nonatomic) BOOL marked;

@end


#pragma mark TKCalendarMonthView
@interface TKCalendarMonthView (PrivateMethods)
- (void) loadButtons;
- (void) loadInitialGrids;
- (NSArray*) getMarksDataWithDate:(NSDate*)date;
- (void) drawMonthLabel:(CGRect)rect;
- (void) drawDayLabels:(CGRect)rect;
- (void) moveCalendarMonthsDownAnimated:(BOOL)animated;
- (void) moveCalendarMonthsUpAnimated:(BOOL)animated;
- (void) setCurrentMonth:(NSDate*)d;
- (void) setSelectedMonth:(NSDate*)d;
@end
@implementation TKCalendarMonthView

@synthesize delegate,dataSource;
@synthesize monthYear;


// public
- (id) init{
	
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 400)]){
		self.backgroundColor = [UIColor clearColor];
		
		TKDateInformation info = [[NSDate date] dateInformation];
		info.second = info.minute = info.hour = 0;
		info.day = 1;
		[self setCurrentMonth:[NSDate dateFromDateInformation:info]];
		
		monthYear = [[NSString stringWithFormat:@"%@ %@",[currentMonth month],[currentMonth year]] copy];
		[self setSelectedMonth:currentMonth];
		
		[self loadButtons];
		
		
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44)];
		scrollView.contentSize = CGSizeMake(320,260);
		[self addSubview:scrollView];
		scrollView.scrollEnabled = NO;
		scrollView.backgroundColor =[UIColor colorWithRed:222/255.0 green:222/255.0 blue:225/255.0 alpha:1];
		
		shadow = [[UIImageView alloc] initWithImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/shadow.png")]];
		deck = [[NSMutableArray alloc] initWithCapacity:3];
		
		[self addSubview:shadow];
		[self loadInitialGrids];
	}
	return self;
}

// private: init functions
- (void) loadButtons{
	
	left = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[left addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[left setImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/leftarrow.png")] forState:0];
	[self addSubview:left];
	left.frame = CGRectMake(10, 0, 44, 42);
	
	right = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[right setImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/rightarrow.png")] forState:0];
	[right addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:right];
	right.frame = CGRectMake(320-56, 0, 44, 42);
}
- (void) loadInitialGrids{

	
	NSArray *ar = [self getMarksDataWithDate:currentMonth];

	
	
	TKMonthGridView *currentGrid = [[TKMonthGridView alloc] initWithStartDate:currentMonth 
																		today:[[NSDate date] dateInformation].day 
																		marks:ar];
	
	[currentGrid setDelegate:self];
	
	
	// --------- SETTING UP FRAMES
	CGRect r = scrollView.frame;
	r.size.height = (currentGrid.lines+1)*44;
	scrollView.frame=r;
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height  +44);
	
	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	// --------- SETTING UP FRAMES
	
	
	UIView *next = [[UIView alloc] initWithFrame:CGRectMake(0, currentGrid.lines * 44, 320, 20)];
	UIView *prev = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
	[scrollView addSubview:currentGrid];
	[deck addObjectsFromArray:[NSArray arrayWithObjects:prev,currentGrid,next,nil]];
	
	[next release];
	[prev release];
	[currentGrid release];
	[ar release];

}


// public
- (void) reload{
	if (deck && deck.count > 1) {
		
		TKMonthGridView* current = [deck objectAtIndex:1];
		current.marks = [self getMarksDataWithDate:current.dateOfFirst];
		[current resetMarks];
	}
}

// private: gets delegate data for specified month
- (NSArray*) getMarksDataWithDate:(NSDate*)date{
	
	int days = [date daysInMonth];
	
	TKDateInformation info = [date dateInformation];
	
	NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:days];
	for(int i = 1; i <= days; i++){
		info.day = i;
		if(dataSource!=nil)
			[ar addObject:[NSNumber numberWithBool:[dataSource calendarMonthView:self markForDay:[NSDate dateFromDateInformation:info]]]];
		else
			[ar addObject:[NSNumber numberWithBool:NO]];
	}
	
	NSArray *array = [NSArray arrayWithArray:ar];
	[ar release];
	
	return array;
	
}


// public
- (void) selectDate:(NSDate *)date{
	if (deck && deck.count > 1) {
		// Get the new month view
		TKMonthGridView* current = [deck objectAtIndex:1];
		
		TKDateInformation info1 = [date dateInformation];
		info1.hour = info1.minute = info1.second = 0;
		
		TKDateInformation info2 = [current.dateOfFirst dateInformation];
		info1.hour = info1.minute = info1.second = 0;
		
		NSInteger difference = [[NSDate dateFromDateInformation:info1] differenceInMonthsTo:[NSDate dateFromDateInformation:info2]];
		if (difference == 0) {
			// Month is already selected 
			// Do nothing
		} else if (difference < 0) {
			// Going up
			for (NSInteger i=0; i > difference; i--) {
				[self moveCalendarMonthsUpAnimated:FALSE];
			}
		} else {
			// Going down
			for (NSInteger i=0; i < difference; i++) {
				[self moveCalendarMonthsDownAnimated:FALSE];
			}
		}
		current = [deck objectAtIndex:1];
		// Select Date
		[current selectDay:info1.day];
	}
}
- (NSDate*) monthDate{
	return currentMonth;
}


// private setter functions
- (void) setMonthYear:(NSString*)str{
	[monthYear release];
	monthYear = [str copy];
}
- (void) setSelectedMonth:(NSDate*)d{
	[selectedMonth release];
	selectedMonth = [d retain];
}
- (void) setCurrentMonth:(NSDate*)d{
	[currentMonth release];
	currentMonth = [d retain];
}


#pragma mark MONTH VIEW DELEGATE METHODS
- (void) previousMonthDayWasSelected:(NSString*)day{
	[self moveCalendarMonthsDownAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:day.intValue];
}
- (void) nextMonthDayWasSelected:(NSString*)day{
	[self moveCalendarMonthsUpAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:day.intValue];
}
- (void) dateWasSelected:(NSArray*)array{
	TKMonthGridView *calendarMonth = [array objectAtIndex:0];
	NSString *dayNumber = [array objectAtIndex:1];
	NSDate *date = calendarMonth.dateOfFirst;
	TKDateInformation info = [date dateInformation];
	info.day = dayNumber.intValue;
	
	if([delegate respondsToSelector:@selector(calendarMonthView:dateWasSelected:)])
		[delegate calendarMonthView:self dateWasSelected:[NSDate dateFromDateInformation:info]];
}



// private animate to next/prev month
- (void) moveCalendarAnimated:(BOOL)animated upwards:(BOOL)up{
	
	[self setUserInteractionEnabled:NO];
	UIView *prev = [deck objectAtIndex:0];
	UIView *current = [deck objectAtIndex:1];
	UIView *next = [deck objectAtIndex:2];
	
	if(!up){
		[scrollView bringSubviewToFront:prev];
		[scrollView bringSubviewToFront:current];
		[scrollView sendSubviewToBack:next];
	}else{
		[scrollView bringSubviewToFront:next];
		[scrollView bringSubviewToFront:current];
		[scrollView sendSubviewToBack:prev];
	}
	
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[(TKMonthGridView*)current dateOfFirst]];
	[comp setMonth:up ? comp.month + 1 : comp.month - 1];
	NSDate *newDate = [gregorian dateFromComponents:comp];
	[gregorian release];
	

	[self setMonthYear: [NSString stringWithFormat:@"%@ %@",[newDate month],[newDate year]]];
	[self setSelectedMonth:newDate];

	NSArray *ar = [self getMarksDataWithDate:selectedMonth];
	int todayNumber = -1;
	TKDateInformation info1 = [[NSDate date] dateInformation];
	TKDateInformation info2 = [newDate dateInformation];
	if(info1.month == info2.month && info1.year == info2.year) todayNumber = info1.day;
		
	
	NSObject *obj;
	if(up) obj = next;
	else obj = prev;
	
	[obj retain];	
	[deck removeObject:obj];

	if([obj isMemberOfClass:[TKMonthGridView class]]){
		//NSLog(@"RESUE");
		[(TKMonthGridView*)obj setStartDate:newDate today:todayNumber marks:ar];
		
	}else{
		[obj release];
		//NSLog(@"HIT");
		obj = [[TKMonthGridView alloc] initWithStartDate:newDate today:todayNumber marks:ar];
	}
	
	
	[(TKMonthGridView*)obj setDelegate:self];
	
	if(up){
		next = (TKMonthGridView*)obj;
		[deck insertObject:obj atIndex:1];
	} 
	else{
		 prev = (TKMonthGridView*)obj;
		[deck insertObject:obj atIndex:0];
	}

	

	[scrollView addSubview:(UIView*)obj];
	[scrollView sendSubviewToBack:(UIView*)obj];
	[obj release];
	
	
	if(up) obj = prev;
	else obj= next;
	
	[obj retain];
	[deck removeObject:obj];
	[deck insertObject:obj atIndex:0];
	[obj release];
	[ar release];
	
	CGRect r;
	if(up){
		r = next.frame;
		r.origin.y = [(TKMonthGridView*)current lines] *  44;
	} else {
		r = prev.frame;
		r.origin.y = 0 - [(TKMonthGridView*)prev lines] *  44;
	} 
	
	
	if(up && [next isMemberOfClass:[TKMonthGridView class]] &&  [(TKMonthGridView*)next weekdayOfFirst] == 1) r.origin.y += 44;
	else if(!up && [next isMemberOfClass:[TKMonthGridView class]] && [(TKMonthGridView*)current weekdayOfFirst] == 1) r.origin.y -= 44;
	
	float scrol;
	if(up){
		next.frame = r;
		scrol = next.frame.origin.y;
	}else{
		prev.frame = r;
		scrol = prev.frame.origin.y;
	}
	
	
	if (animated) {	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationStopped:)];
	} else {
		[self performSelector:@selector(animationStopped:) withObject:self];
	}
	
	
	for(UIView *m in deck){
		CGPoint c = m.center;
		c.y -= scrol;
		m.center = c;
		
	}
	r = scrollView.frame;
	if(up)
		r.size.height = ([(TKMonthGridView*)next lines] +1)*44;
	else
		r.size.height = ([(TKMonthGridView*)prev lines] +1)*44;
	scrollView.frame=r;
	
	
	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	
	
	current.alpha = 0;
	if (animated) {	
		[UIView commitAnimations];
	}
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height +44);
	[self setNeedsDisplay];
	
	if ([delegate respondsToSelector:@selector(calendarMonthView:monthWillAppear:)]){
		if(up) [delegate calendarMonthView:self monthWillAppear:[(TKMonthGridView*)next dateOfFirst]];
		else [delegate calendarMonthView:self monthWillAppear:[(TKMonthGridView*)prev dateOfFirst]];
	}
		
	
}
- (void) moveCalendarMonthsDownAnimated:(BOOL)animated{
	[self moveCalendarAnimated:YES upwards:NO];
}
- (void) moveCalendarMonthsUpAnimated:(BOOL)animated{
	[self moveCalendarAnimated:YES upwards:YES];
}
- (void) animationStopped:(id)sender{
	
	[scrollView bringSubviewToFront:[deck objectAtIndex:1]];
	[[deck objectAtIndex:0] setAlpha:1];
	[[deck objectAtIndex:2] setAlpha:1];
	[[deck objectAtIndex:0] removeFromSuperview];
	[[deck objectAtIndex:2] removeFromSuperview];
	
	[self setUserInteractionEnabled:YES];
}


#pragma mark LEFT & RIGHT BUTTON ACTIONS
- (void) leftButtonTapped{
	[self moveCalendarMonthsDownAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:1];
}
- (void) rightButtonTapped{
	[self moveCalendarMonthsUpAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:1];
	
	
}


- (void) drawRect:(CGRect)rect {
    // Drawing code

	//[self reload];

	
	[[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/topbar.png")] drawAtPoint:CGPointMake(0,0)];
	
	
	[self drawDayLabels:rect];
	[self drawMonthLabel:rect];

	
}
- (void) drawMonthLabel:(CGRect)rect{
	
	if(monthYear != nil){
		CGRect r = CGRectInset(self.frame, 55, 8);
		r.size.height=42;
		[[UIColor colorWithRed:75.0/255.0 green:92/255.0 blue:111/255.0 alpha:1] set];
		[monthYear drawInRect:r 
					 withFont:[UIFont boldSystemFontOfSize:20.0] 
				lineBreakMode:UILineBreakModeWordWrap 
					alignment:UITextAlignmentCenter];
	}
}
- (void) drawDayLabels:(CGRect)rect{
	
	
	// Calendar starting on Monday instead of Sunday (Australia, Europe agains US american calendar)
	NSArray *days;
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	if (CFCalendarGetFirstWeekday(currentCalendar) == 2) 
		days = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",nil];
	else 
		days = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
	CFRelease(currentCalendar); 
	
	
	UIFont *f = [UIFont boldSystemFontOfSize:10];
	[[UIColor darkGrayColor] set];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
	
	
	int i = 0;
	for(NSString *str in days){
		[str drawInRect:CGRectMake(i * 46, 44-12, 45, 10) withFont:f lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
		i++;
	}
	CGContextRestoreGState(context);
}

- (void)dealloc {
	[selectedMonth release];
	[currentMonth release];
	[deck release];
	
	[shadow release];
	[scrollView release];
	
	[left release];
	[monthYear release];
	[right release];
	
    [super dealloc];
}


@end


#pragma mark TKMonthGridView
@interface TKMonthGridView (PrivateMethods)
- (void) buildGrid;
//- (void) setStartDate:(NSDate*)theDate today:(NSInteger)todayDay marks:(NSArray*)marksArray;
@end
@implementation TKMonthGridView
@synthesize lines,weekdayOfFirst,delegate,dateOfFirst,marks;



// private methods

- (int) daysInPreviousMonth{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:dateOfFirst];
	[comp setDay:1];
	[comp setMonth:comp.month-1];
	int daysInPreviousMonth = [[gregorian dateFromComponents:comp] daysInMonth];
	[gregorian release];
	return daysInPreviousMonth;
}


// END OF PRIVATE


- (id) initWithStartDate:(NSDate*)theDate today:(NSInteger)todayDay marks:(NSArray*)marksArray{
	if (self = [self initWithFrame:CGRectMake(0, 0, 320, 320)]) {
		
		[self setStartDate:theDate today:todayDay marks:marksArray];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void) drawRect:(CGRect)rect {
    // Drawing code
}
- (void) buildGrid{
	
	dayTiles = [[NSMutableArray alloc] init];
	
	int position = weekdayOfFirst;
	int line = 0;
	
	int daysInPreviousMonth = [self daysInPreviousMonth];
	int daysInMonth = [dateOfFirst daysInMonth];
	int lead = daysInPreviousMonth - (position - 2);
	
	
	
	for(int i=1;i<position;i++){
		TKCalendarDayView *dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectMake((i - 1) * 46 - 1, 0, 47, 45)];
		[dayView setActive:NO];
		dayView.str = [NSString stringWithFormat:@"%d",lead];
		[self addSubview:dayView];
		[dayTiles addObject:dayView];
		[dayView release];
		lead++;
	}
	
	BOOL isCurrentMonth = NO;
	if(todayNumber > 0)
		isCurrentMonth = YES;
	
	for(int i=1;i<=daysInMonth;i++){
		
		TKCalendarDayView *dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectMake((position - 1) * 46 - 1, line * 44, 47, 45)];
		
		[dayView setMarked:[[self.marks objectAtIndex:i-1] boolValue]];
		
		if(isCurrentMonth && i==todayNumber)
			[dayView setToday:YES];
		else
			[dayView setToday:NO];
		
		dayView.str = [NSString stringWithFormat:@"%d",i];
		
		// Set the tag as the day view
		// Will be used in order to reseet marks
		// Each day view is easily accessible using viewWithTag
		dayView.tag	= i;
		
		[self addSubview:dayView];
		[dayTiles addObject:dayView];
		[dayView release];
		
		if(position == 7){
			position = 1;
			line++;
		}else{
			position++;
		}
		
		
		
	}
	
	if(position != 1){
		int counter = 1;
		for(int i=position;i< 8;i++){
			TKCalendarDayView *dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectMake((i - 1) * 46 - 1, line * 44, 47, 45)];
			dayView.str = [NSString stringWithFormat:@"%d",counter];
			[dayView setActive:NO];
			
			[self addSubview:dayView];
			[dayTiles addObject:dayView];
			[dayView release];
			counter++;
		}
	}
	
	CGRect r = self.frame;
	r.size.height = (line+1) * 44;
	self.frame = r;
	
	
	
	lines = line;
	if(position==1)
		lines--;
	
	
	
	
}
- (void) resetMarks{
	for (NSInteger i=1; i<=self.marks.count; i++) {
		TKCalendarDayView *dayView = (TKCalendarDayView *)[self viewWithTag:i];
		
		[dayView setMarked:[[self.marks objectAtIndex:i-1] boolValue]];
	}
	[self setNeedsDisplay];
}


- (TKCalendarDayView*) oldDayTile{
	if([graveYard count] > 0){
		TKCalendarDayView *d = [[graveYard objectAtIndex:0] retain];
		[graveYard removeObjectAtIndex:0];
		return [d autorelease];
	}
	return nil;
}

- (void) build{
	
	[graveYard addObjectsFromArray:dayTiles];
	//NSLog(@"%d Graveyard: %d",[dayTiles count],[graveYard count]);
	[dayTiles release];
	dayTiles = [[NSMutableArray alloc] init];
	
	int position = weekdayOfFirst;
	int line = 0;
	
	int daysInPreviousMonth = [self daysInPreviousMonth];
	int daysInMonth = [dateOfFirst daysInMonth];
	int lead = daysInPreviousMonth - (position - 2);
	
	TKCalendarDayView  *dayView;
	
	for(int i=1;i<position;i++){
		
		dayView = [[self oldDayTile] retain];
		if(dayView == nil){
			dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectZero];
			//NSLog(@"--Hit");
		} 
		dayView.frame = CGRectMake((i - 1) * 46 - 1, 0, 47, 45);
		[dayView setString:[NSString stringWithFormat:@"%d",lead] selected:NO active:NO today:NO marked:NO];

		[self addSubview:dayView];
		[dayTiles addObject:dayView];
		
		[dayView release];
		lead++;
	}
	
	BOOL isCurrentMonth = NO;
	if(todayNumber > 0)
		isCurrentMonth = YES;
	
	for(int i=1;i<=daysInMonth;i++){
				
		dayView = [[self oldDayTile] retain];
		if(dayView == nil){
			dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectZero];
			//NSLog(@"--Hit");
		} 

		
		dayView.frame = CGRectMake((position - 1) * 46 - 1, line * 44, 47, 45);
		
		BOOL today = isCurrentMonth && i==todayNumber ? YES : NO;
		
		[dayView setString:[NSString stringWithFormat:@"%d",i] selected:NO active:YES today:today marked:[[self.marks objectAtIndex:i-1] boolValue]];

		
		// Set the tag as the day view
		// Will be used in order to reseet marks
		// Each day view is easily accessible using viewWithTag
		dayView.tag	= i;
		
		[self addSubview:dayView];
		[dayTiles addObject:dayView];
		[dayView release];
		
		if(position == 7){
			position = 1;
			line++;
		}else{
			position++;
		}
		
		
		
	}
	
	if(position != 1){
		int counter = 1;
		for(int i=position;i< 8;i++){
			
			dayView = [[self oldDayTile] retain];
			if(dayView == nil) dayView = [[TKCalendarDayView alloc] initWithFrame:CGRectZero];

			dayView.frame = CGRectMake((i - 1) * 46 - 1, line * 44, 47, 45);
			[dayView setString:[NSString stringWithFormat:@"%d",counter] selected:NO active:NO today:NO marked:NO];
			
			[self addSubview:dayView];
			[dayTiles addObject:dayView];
			[dayView release];
			counter++;
		}
	}
	
	CGRect r = self.frame;
	r.size.height = (line+1) * 44;
	self.frame = r;
	
	
	
	lines = line;
	if(position==1)
		lines--;
	
	
}

- (void) selectDay:(int)theDayNumber{
	int i = 0;
	while(i < [dayTiles count]){
		if([[[dayTiles objectAtIndex:i] str] intValue] == 1)
			break;
		i++;
	}
	[selectedDay setSelected:NO];
	selectedDay = [dayTiles objectAtIndex:i + theDayNumber - 1];
	[[dayTiles objectAtIndex:i + theDayNumber - 1] setSelected:YES];
	
	
	[self bringSubviewToFront:selectedDay];
	[delegate performSelector:@selector(dateWasSelected:) withObject:[NSArray arrayWithObjects:self,selectedDay.str,nil]];
	//[delegate calendarMonth:self dateWasSelected:[selectedDay.str intValue]];
}
- (void) selectDayView:(UITouch*)touch{
	
	
	CGPoint p = [touch locationInView:self];
	int index = ((int)p.y / 44) * 7 + ((int)p.x / 46);
	
	if(index > [dayTiles count]) return;
	
	
	
	TKCalendarDayView *selected = [dayTiles objectAtIndex:index];
	
	if(selected == selectedDay) return;
	
	if(![selected active]){
		if([selected.str intValue] > 15){
			[delegate performSelector:@selector(previousMonthDayWasSelected:) withObject:selected.str];
			//[delegate calendarMonth:self previousMonthDayWasSelected:[selected.str intValue]];
		}else{
			[delegate performSelector:@selector(nextMonthDayWasSelected:) withObject:selected.str];
			//[delegate calendarMonth:self nextMonthDayWasSelected:[selected.str intValue]];
		}
		return;
	}
	[selectedDay setSelected:NO];
	[self bringSubviewToFront:selected];
	[selected setSelected:YES];
	selectedDay = selected;
	
	[delegate performSelector:@selector(dateWasSelected:) withObject:[NSArray arrayWithObjects:self,selected.str,nil]];
	//[delegate calendarMonth:self dateWasSelected:[selected.str intValue]];
	
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	[self selectDayView:[touches anyObject]];
	
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event];
	[self selectDayView:[touches anyObject]];
}


- (void) setStartDate:(NSDate*)theDate today:(NSInteger)todayDay marks:(NSArray*)marksArray{
	
	
	
	
	[dateOfFirst release];
	dateOfFirst = [theDate retain];
	
	// Calendar starting on Monday instead of Sunday (Australia, Europe against US american calendar)
	weekdayOfFirst = [dateOfFirst weekdayWithMondayFirst];
	todayNumber = todayDay;
	self.marks = [marksArray retain];
	
	if(dayTiles==nil){
		dayTiles = [[NSMutableArray alloc] init];
		graveYard = [[NSMutableArray alloc] init];
	}
	
	[self build];
	

}


- (void)dealloc {
	[dayTiles release];
	[dateOfFirst release];
	[marks release];
    [super dealloc];
}

@end


#pragma mark TKCalendarDayView
@implementation TKCalendarDayView
@synthesize selected,active,today,marked,str;

- (id) initWithFrame:(CGRect)frame string:(NSString*)string selected:(BOOL)sel active:(BOOL)act today:(BOOL)tdy marked:(BOOL)mark{
	
	if(self = [super initWithFrame:frame]){
		[self setString:(NSString*)string selected:(BOOL)sel active:(BOOL)act today:(BOOL)tdy marked:(BOOL)mark];
	}
	return self;

}
- (void) setString:(NSString*)string selected:(BOOL)sel active:(BOOL)act today:(BOOL)tdy marked:(BOOL)mark{
	[str release];
	str = [string copy];
	selected = sel;
	active = act;
	today = tdy;
	marked = mark;
	[self setNeedsDisplay];
}




- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		active = YES;
		today = NO;
		marked = NO;
		selected = NO;
		self.opaque = YES;
    }
    return self;
}
- (void) drawRect:(CGRect)rect {
    // Drawing code
	
	UIImage *d;
	UIColor *color;
	
	if(!active){
		//color = [UIColor colorWithRed:36.0/255.0 green:49/255.0 blue:64/255.0 alpha:1];
		color = [UIColor grayColor];
		d = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/datecell.png")];
	}else if(today && selected){
		color = [UIColor whiteColor];
		d = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/todayselected.png")];
	}else if (today){
		color = [UIColor whiteColor];
		d = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/today.png")];
	}else if(selected){
		color = [UIColor whiteColor];
		d = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/datecellselected.png")];
	} else {
		color = [UIColor colorWithRed:75.0/255.0 green:92/255.0 blue:111/255.0 alpha:1];
		d = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/datecell.png")];
	}
	
	[d drawAtPoint:CGPointMake(0,0)];
	
	
	[color set];
	
	[str drawInRect: CGRectInset(self.bounds, 4, 9) 
		   withFont: [UIFont boldSystemFontOfSize:22] 
	  lineBreakMode: UILineBreakModeWordWrap 
		  alignment: UITextAlignmentCenter];
	
	if(marked){
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(selected || today)
			CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
		else
			CGContextSetRGBFillColor(context, 75.0/255.0, 92/255.0, 111/255.0, 1.0);
		
		CGContextSetLineWidth(context, 0.0);
		CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/2 - 2, 45 - 10, 4, 4));
		CGContextFillPath(context);
	}
	
	
	
}


- (void)dealloc {
	[str release];
    [super dealloc];
}

- (void) setSelected:(BOOL)select{
	selected = select;
	[self setNeedsDisplay];
}
- (void) setToday:(BOOL)tdy{
	if(tdy == today) return;
	today = !today;
	[self setNeedsDisplay];
}
- (void) setActive:(BOOL) act{
	if(active == act)return;
	active = act;
	[self setNeedsDisplay];
}
- (void) setMarked:(BOOL)mark{
	if(marked == mark) return;
	marked = !marked;
	[self setNeedsDisplay];
	
}

@end