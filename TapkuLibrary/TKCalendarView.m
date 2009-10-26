//
//  TKCalendarView.m
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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
#import "TKCalendarView.h"
#import "NSDateAdditions.h"
#import "TKCalendarMonthView.h"
#import "TKGlobal.h"


@interface TKCalendarView (PrivateMethods)

- (void) moveCalendarMonthsDownAnimated:(BOOL)animated;
- (void) moveCalendarMonthsUpAnimated:(BOOL)animated;

@end

@implementation TKCalendarView
@synthesize delegate,monthString,selectedMonth;


- (void) setMonthString:(NSString*)str{
	monthString = [str copy];
	[self setNeedsDisplay];
}


- (void) initialLoad{
	

	TKCalendarMonthView *currentMonthView = [[TKCalendarMonthView alloc] initWithFrame:CGRectMake( 0, 0, 320, 320) 
																			 startDate:currentMonth 
																				 today:[[[NSDate date] dayNumber] intValue] 
																				marked:[delegate calendarView:self itemsForDaysInMonth:currentMonth]];

	
	[currentMonthView setDelegate:self];
	
	
	// --------- SETTING UP FRAMES
	CGRect r = scrollView.frame;
	r.size.height = (currentMonthView.lines+1)*44;
	scrollView.frame=r;
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height  +44);
	
	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	// --------- SETTING UP FRAMES
	 
	
	UIView *next = [[UIView alloc] initWithFrame:CGRectMake(0, currentMonthView.lines * 44, 320, 20)];
	UIView *prev = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
	[scrollView addSubview:currentMonthView];
	[deck addObjectsFromArray:[NSArray arrayWithObjects:prev,currentMonthView,next,nil]];
	
	[next release];
	[prev release];
	[currentMonth release];


	
	
}
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

- (id) initWithFrame:(CGRect)frame delegate:(id)del{
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.delegate = del;
		currentMonth = [[NSDate firstOfCurrentMonth] retain];
		self.monthString = [currentMonth monthYearString];
		self.selectedMonth = currentMonth;
		[self loadButtons];


		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44)];
		scrollView.contentSize = CGSizeMake(320,260);
		[self addSubview:scrollView];
		scrollView.scrollEnabled = NO;
		scrollView.backgroundColor =[UIColor colorWithRed:222/255.0 green:222/255.0 blue:225/255.0 alpha:1];

		shadow = [[UIImageView alloc] initWithImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/shadow.png")]];
		
		deck = [[NSMutableArray alloc] initWithCapacity:3];
		[self initialLoad];
		
		
		[self addSubview:shadow];
		
    }
    return self;
}

- (void) reloadMarks
{
	if (deck && deck.count > 1) {
		// Get the current month view
		TKCalendarMonthView* current = [deck objectAtIndex:1];
		// Ask the delegate for the new items
		current.marks = [delegate calendarView:self itemsForDaysInMonth:current.dateOfFirst];
		// Refresh the calendar
		[current resetMarks];
	}
}

- (void) selectDate:(NSDate *)date
{
	if (deck && deck.count > 1) {
		// Get the new month view
		TKCalendarMonthView* current = [deck objectAtIndex:1];
		NSInteger difference = [[date monthlessDate] differenceInMonthsTo:[current.dateOfFirst monthlessDate]];
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
		[current selectDay:[[date dayNumber]integerValue]];
	}
}

#pragma mark MONTH VIEW DELEGATE METHODS
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth dateWasSelected:(NSInteger)integer{
	[delegate calendarView:self dateWasSelected:integer ofMonth:calendarMonth.dateOfFirst];
}
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth previousMonthDayWasSelected:(NSInteger)day{
	[self moveCalendarMonthsDownAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:day];
	// selectDay: is in charge of informing the delegate when a dateWasSelected
	// If uncomment this, delegate will be informed twice
	//[delegate calendarView:self  dateWasSelected:day ofMonth:[[deck objectAtIndex:1] dateOfFirst]];
	return;
}
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth nextMonthDayWasSelected:(NSInteger)day{
	[self moveCalendarMonthsUpAnimated:TRUE];
	[[deck objectAtIndex:1] selectDay:day];
	// selectDay: is in charge of informing the delegate when a dateWasSelected
	// If uncomment this, delegate will be informed twice
	//[delegate calendarView:self  dateWasSelected:day ofMonth:[[deck objectAtIndex:1] dateOfFirst]];
	return;
}




#pragma mark MOVING THE CALENDAR UP AND DOWN TO NEW MONTH
- (void) moveCalendarMonthsDownAnimated:(BOOL)animated{
	
	
	[self setUserInteractionEnabled:NO];
	
	UIView *prev = [deck objectAtIndex:0];
	UIView *current = [deck objectAtIndex:1];
	UIView *next = [deck objectAtIndex:2];
	
	[scrollView bringSubviewToFront:prev];
	[scrollView bringSubviewToFront:current];
	[scrollView sendSubviewToBack:next];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[(TKCalendarMonthView*)current dateOfFirst]];
	[comp setMonth:comp.month-1];
	
	NSDate *newDate = [gregorian dateFromComponents:comp];
	self.monthString = [newDate monthYearString];
	self.selectedMonth = newDate;
	[gregorian release];
	
	NSArray *ar = [delegate calendarView:self itemsForDaysInMonth:newDate];
	
	int todayNumber = -1;
	if([[[NSDate date] monthYearString] isEqualToString:[newDate monthYearString]])
		todayNumber = [[[NSDate date] dayNumber] intValue];
	
	
	
	[deck removeObject:prev];
	prev = nil;
	prev = [[TKCalendarMonthView alloc] initWithFrame:CGRectMake( 0, 0, 320, 320) 
											startDate:newDate 
												today:todayNumber
											   marked:ar];
	[(TKCalendarMonthView*)prev setDelegate:self];
	[deck insertObject:prev atIndex:0];
	[prev release];
	[scrollView addSubview:prev];
	[scrollView sendSubviewToBack:prev];
	
	
	[next retain];
	[deck removeObject:next];
	[deck insertObject:next atIndex:0];
	[next release];
	
	CGRect r = prev.frame;
	
	r.origin.y = 0 - [(TKCalendarMonthView*)prev lines] *  44;
	if([(TKCalendarMonthView*)current weekdayOfFirst] == 1)
		r.origin.y -= 44;
	prev.frame = r;
	float scrol = prev.frame.origin.y;
	
	if (animated) {	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelay:0.1];
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
	r.size.height = ([(TKCalendarMonthView*)prev lines] +1)*44;
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
	
	[delegate calendarView:self willShowMonth:[(TKCalendarMonthView*)prev dateOfFirst]];
}
- (void) moveCalendarMonthsUpAnimated:(BOOL)animated{
	
	[self setUserInteractionEnabled:NO];
	
	UIView *prev = [deck objectAtIndex:0];
	UIView *current = [deck objectAtIndex:1];
	UIView *next = [deck objectAtIndex:2];
	
	[scrollView bringSubviewToFront:next];
	[scrollView bringSubviewToFront:current];
	[scrollView sendSubviewToBack:prev];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[(TKCalendarMonthView*)current dateOfFirst]];
	[comp setMonth:comp.month+1];
	
	NSDate *newDate = [gregorian dateFromComponents:comp];
	self.monthString = [newDate monthYearString];
	self.selectedMonth = newDate;
	[gregorian release];
	
	NSArray *ar = [delegate calendarView:self itemsForDaysInMonth:newDate];
	int todayNumber = -1;
	
	if([[[NSDate date] monthYearString] isEqualToString:[newDate monthYearString]])
		todayNumber = [[[NSDate date] dayNumber] intValue];

	
	
	

	[deck removeObjectAtIndex:2];
	next = [[TKCalendarMonthView alloc] initWithFrame:CGRectMake( 0, 0, 320, 320) 
											startDate:newDate 
												today:todayNumber
											   marked:ar];
	
	[(TKCalendarMonthView*)next setDelegate:self];
	[deck addObject:next];
	[next release];
	[scrollView addSubview:next];
	[scrollView sendSubviewToBack:next];
		

	[prev retain];
	[deck removeObject:prev];
	[deck addObject:prev];
	[prev release];
	
	CGRect r = next.frame;
	
	r.origin.y = [(TKCalendarMonthView*)current lines] *  44;
	if([(TKCalendarMonthView*)next weekdayOfFirst] == 1)
		r.origin.y += 44;
	next.frame = r;
	
	if (animated) {	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelay:0.1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationStopped:)];		
	} else {
		[self performSelector:@selector(animationStopped:) withObject:self];
	}
	
	float scrol = next.frame.origin.y;
	
	for(UIView *m in deck){
		CGPoint c = m.center;
		c.y -= scrol;
		m.center = c;
		
	}
	
	r = scrollView.frame;
	r.size.height = ([(TKCalendarMonthView*)next lines] +1)*44;
	scrollView.frame=r;
	
	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	
	
	current.alpha = 0;
	[UIView commitAnimations];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height +44);
	[self setNeedsDisplay];
	
	[delegate calendarView:self willShowMonth:[(TKCalendarMonthView*)next dateOfFirst]];
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


- (void)drawRect:(CGRect)rect {
    // Drawing code

	[[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/topbar.png")] drawAtPoint:CGPointMake(0,0)];
	
	
	
	
	NSArray *days = nil;
	
	// Calendar starting on Monday instead of Sunday (Australia, Europe agains US american calendar)
	CFCalendarRef currentCalendar = CFCalendarCopyCurrent();
	if (CFCalendarGetFirstWeekday(currentCalendar) == 2) {
		days = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",nil];
	} else {
		days = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
	}
	CFRelease(currentCalendar);
	
	UIFont *f = [UIFont boldSystemFontOfSize:10];
	[[UIColor darkGrayColor] set];
	
	// Retrieve the graphics context 
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Save the context state 
	CGContextSaveGState(context);

	// Set shadow
	CGContextSetShadowWithColor(context,  CGSizeMake(0.0, -1.0), 0.5, [[UIColor whiteColor]CGColor]);
	
	int i = 0;
	for(NSString *str in days){
		
		[str drawInRect:CGRectMake(i * 46, 44-12, 45, 10) withFont:f lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

		i++;
	}
	
	
	if(self.monthString != nil){
		CGRect r = CGRectInset(self.frame, 55, 8);
		r.size.height=42;
		NSLog(@"MONTH %@",monthString);
		[[UIColor colorWithRed:75.0/255.0 green:92/255.0 blue:111/255.0 alpha:1] set];
		f = [UIFont boldSystemFontOfSize:20.0];
		[monthString drawInRect:r withFont:f lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
		
	}
	
	// Restore the context state
	CGContextRestoreGState(context);
	
	
}


- (void)dealloc {
	[selectedMonth release];
	
    [super dealloc];
}


@end
