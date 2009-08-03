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

- (void) moveCalendarMonthsDown;
- (void) moveCalendarMonthsUp;


@end

@implementation TKCalendarView
@synthesize delegate,monthString;


- (void) setMonthString:(NSString*)str{
	//[monthString release];
	monthString = [str copy];
	[self setNeedsDisplay];
}



- (void) initialLoad{
	
	// ----------------------------
	

	TKCalendarMonthView *currentMonthView = [[TKCalendarMonthView alloc] initWithFrame:CGRectMake( 0, 0, 320, 320) 
																			 startDate:currentMonth 
																				 today:[[[NSDate date] dayNumber] intValue] 
																				marked:[delegate calendarView:self daysOfMonthIsMarked:currentMonth]];

	
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
		monthString = [currentMonth monthYearString];
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


- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth dateWasSelected:(NSInteger)integer{
	
	[delegate calendarView:self dateWasSelected:integer ofMonth:calendarMonth.dateOfFirst];
	
	
}
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth previousMonthDayWasSelected:(NSInteger)day{
	[self moveCalendarMonthsDown];
	[[deck objectAtIndex:1] selectDay:day];
	[delegate calendarView:self  dateWasSelected:day ofMonth:[[deck objectAtIndex:1] dateOfFirst]];
	return;
}
- (void) calendarMonth:(TKCalendarMonthView*)calendarMonth nextMonthDayWasSelected:(NSInteger)day{
	[self moveCalendarMonthsUp];
	[[deck objectAtIndex:1] selectDay:day];
	[delegate calendarView:self  dateWasSelected:day ofMonth:[[deck objectAtIndex:1] dateOfFirst]];
	return;
}


- (void) printMonthDeck{
	for(TKCalendarMonthView *m in deck){
		NSLog(@"%@", [m.dateOfFirst monthYearString]);
	}
}


- (void) moveCalendarMonthsDown{
	
	
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
	
	NSArray *ar = [delegate calendarView:self daysOfMonthIsMarked:newDate];
	
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
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStopped:)];
	
	
	
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
	[UIView commitAnimations];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height +44);
	[self setNeedsDisplay];
	
	[delegate calendarView:self movedToMonth:[(TKCalendarMonthView*)prev dateOfFirst]];
	
	
	/*
	TKCalendarMonthView *top = [deck objectAtIndex:4];
	TKCalendarMonthView *current = [deck objectAtIndex:2];
	TKCalendarMonthView *m = [deck objectAtIndex:1];
	TKCalendarMonthView *n = [deck objectAtIndex:0];
	
	
	monthLabel.text = [m.dateOfFirst monthYearString];
	
	
	[deck removeObject:top];
	
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:n.date];
	[comp setMonth:comp.month-1];
	
	
	NSArray *ar = [delegate calendarView:self daysOfMonthIsMarked:[gregorian dateFromComponents:comp]];
	
	if([[[NSDate date] monthYearString] isEqualToString:[[gregorian dateFromComponents:comp] monthYearString]])
		
		[top setDate:[gregorian dateFromComponents:comp] today:[[[NSDate date] dayNumber] intValue] marked:ar];
	else
		[top setDate:[gregorian dateFromComponents:comp] today:-1 marked:ar];
	
	[deck insertObject:top atIndex:0];
	CGRect r = top.frame;
	r.origin.y =  current.frame.origin.y - (m.lines * 44) - (n.lines * 44) - top.lines * 44;
	if(m.weekday==7) r.origin.y -= 44;
	if(n.weekday==7) r.origin.y -= 44;
	if(top.lines==7) r.origin.y -= 44;
		
	top.frame=r;
	
	
	n.alpha = 1;
	
	[scrollView sendSubviewToBack:n];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStopped:)];
	
	float scrol = 300 - m.frame.origin.y;
	
	for(TKCalendarMonthView *mr in deck){
		CGPoint c = mr.center;
		c.y += scrol;
		mr.center = c;
		
	}
	
	r = scrollView.frame;
	r.size.height = (m.lines+1)*44;

	scrollView.frame=r;

	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	
	
	current.alpha = 0;
	
	[self setUserInteractionEnabled:NO];
	
	[UIView commitAnimations];
	
	[gregorian release];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height +44);
	[self setNeedsDisplay];
	
	
	[delegate calendarView:self movedToMonth:m.date];
	
	//[self printMonthDeck];
	 */
}
- (void) moveCalendarMonthsUp{
	
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
	
	NSArray *ar = [delegate calendarView:self daysOfMonthIsMarked:newDate];
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
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStopped:)];
	
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
	
	[delegate calendarView:self movedToMonth:[(TKCalendarMonthView*)next dateOfFirst]];
	
	
	/*

	TKCalendarMonthView *top = [deck objectAtIndex:0];
	TKCalendarMonthView *current = [deck objectAtIndex:2];
	TKCalendarMonthView *m = [deck objectAtIndex:3];
	TKCalendarMonthView *n = [deck objectAtIndex:4];
	
	
	monthLabel.text = [m.date monthYearString];
	
	
	[deck removeObject:top];
	

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:n.date];
	[comp setMonth:comp.month+1];
	//[top setDate:[gregorian dateFromComponents:comp]];
	
	NSArray *ar = [delegate calendarView:self daysOfMonthIsMarked:[gregorian dateFromComponents:comp]];
	
	if([[[NSDate date] monthYearString] isEqualToString:[[gregorian dateFromComponents:comp] monthYearString]])
		[top setDate:[gregorian dateFromComponents:comp] today:[[[NSDate date] dayNumber] intValue] marked:ar];
	else
		[top setDate:[gregorian dateFromComponents:comp] today:-1 marked:ar];
	
	[deck addObject:top];
	CGRect r = top.frame;
	r.origin.y = current.lines*44+ m.lines*44 + n.lines*44 + 300;
	if(current.lastday ==1)
		r.origin.y += 44;
	if(m.lastday==1 )
		r.origin.y += 44;
	if(n.lastday==1)
		r.origin.y += 44;
	top.frame=r;
	
	
	n.alpha = 1;
	
	[scrollView sendSubviewToBack:n];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStopped:)];
	
	float scrol = m.frame.origin.y - 300;

	for(TKCalendarMonthView *m in deck){
		CGPoint c = m.center;
		c.y -= scrol;
		m.center = c;
		
	}
	
	r = scrollView.frame;
	r.size.height = (m.lines+1)*44;
	scrollView.frame=r;
	
	
	CGRect imgrect = shadow.frame;
	imgrect.origin.y = r.size.height-132;
	shadow.frame = imgrect;
	
	
	current.alpha = 0;
	[self setUserInteractionEnabled:NO];
	[UIView commitAnimations];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height +44);
	[self setNeedsDisplay];
	
	[gregorian release];
	//[self printMonthDeck];
	[delegate calendarView:self movedToMonth:m.date];
	 
	 */
}

- (void) animationStopped:(id)sender{
	[scrollView bringSubviewToFront:[deck objectAtIndex:1]];
	[[deck objectAtIndex:0] setAlpha:1];
	[[deck objectAtIndex:2] setAlpha:1];
	[[deck objectAtIndex:0] removeFromSuperview];
	[[deck objectAtIndex:2] removeFromSuperview];
	[self setUserInteractionEnabled:YES];
}

- (void) leftButtonTapped{
	[self moveCalendarMonthsDown];
	[[deck objectAtIndex:1] selectDay:1];
}
- (void) rightButtonTapped{
	[self moveCalendarMonthsUp];
	[[deck objectAtIndex:1] selectDay:1];
	
	
}



- (void)drawRect:(CGRect)rect {
    // Drawing code

	[[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/calendar/topbar.png")] drawAtPoint:CGPointMake(0,0)];
	
	
	NSArray *days = [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
	
	UIFont *f = [UIFont systemFontOfSize:10];
	[[UIColor grayColor] set];
	
	int i = 0;
	for(NSString *str in days){
		
		[str drawInRect:CGRectMake(i * 46, 44-12, 45, 10) withFont:f lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

		i++;
	}
	
	if(monthString != nil){
		CGRect r = CGRectInset(self.frame, 55, 8);
		r.size.height=42;
		
		[[UIColor colorWithRed:75.0/255.0 green:92/255.0 blue:111/255.0 alpha:1] set];
		f = [UIFont boldSystemFontOfSize:20.0];
		[monthString drawInRect:r withFont:f lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
		
	}
	

	
	
}


- (void)dealloc {
    [super dealloc];
}


@end
