//
//  TKCalendarMonthView.m
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
#import "TKCalendarMonthView.h"
#import "NSDateAdditions.h"
#import "TKGlobal.h"


@implementation TKCalendarMonthView
@synthesize lines,weekdayOfFirst,delegate,dateOfFirst;

- (void) buildGrid{
	
	
	for(UIView *v in dayTiles){
		[v removeFromSuperview];
	}
	
	[dayTiles release];
	dayTiles = nil;
	
	dayTiles = [[NSMutableArray alloc] init];
	

	
	int position = weekdayOfFirst;
	int line = 0;
	
	

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:dateOfFirst];
	[comp setDay:1];
	[comp setMonth:comp.month-1];
	int daysInPreviousMonth = [[gregorian dateFromComponents:comp] daysInMonth];
	[gregorian release];
	
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
		
		[dayView setMarked:[[marks objectAtIndex:i-1] boolValue]];
		
		if(isCurrentMonth && i==todayNumber)
			[dayView setToday:YES];
		else
			[dayView setToday:NO];
		
		dayView.str = [NSString stringWithFormat:@"%d",i];
		
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

/*- (void) setDate:(NSDate*)firstOfMonth today:(int)dayOfDate marked:(NSArray*)marksArray{
	todayNumber = dayOfDate;
	
	[marks release];
	marks = [marksArray retain];
	
	[dateOfFirst release];
	dateOfFirst = [firstOfMonth retain];
	
	[self buildGrid];
}*/
- (id) initWithFrame:(CGRect)frame startDate:(NSDate*)theDate today:(NSInteger)todayDay marked:(NSArray*)marksArray{
	if (self = [self initWithFrame:frame]) {
		
        dateOfFirst = [theDate retain];
		
		// Calendar starting on Monday instead of Sunday (Australia, Europe against US american calendar)
		weekdayOfFirst = [dateOfFirst weekdayMondayFirst];
		
		todayNumber = todayDay;
		marks = [marksArray retain];
		

		[self buildGrid];
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


/*
- (id) initWithFrame:(CGRect)frame startDate:(NSDate*)theDate today:(NSInteger)todayDay{
	if (self = [self initWithFrame:frame startDate:theDate today:todayDay marked:nil]) {
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame startDate:(NSDate*)day{
	if (self = [self initWithFrame:frame startDate:day today:-1]) {

    }
    return self;
}
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}
*/

 - (void) drawRect:(CGRect)rect {
    // Drawing code
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
	[delegate calendarMonth:self dateWasSelected:[selectedDay.str intValue]];
}
- (void) selectDayView:(UITouch*)touch{
	

	CGPoint p = [touch locationInView:self];
	int index = ((int)p.y / 44) * 7 + ((int)p.x / 46);

	if(index > [dayTiles count]) return;
	
	
	
	TKCalendarDayView *selected = [dayTiles objectAtIndex:index];
	
	if(selected == selectedDay) return;
	
	if(![selected active]){
		if([selected.str intValue] > 15){
			[delegate calendarMonth:self previousMonthDayWasSelected:[selected.str intValue]];
		}else{
			[delegate calendarMonth:self nextMonthDayWasSelected:[selected.str intValue]];
		}
		return;
	}
	[selectedDay setSelected:NO];
	[self bringSubviewToFront:selected];
	[selected setSelected:YES];
	selectedDay = selected;
		
	[delegate calendarMonth:self dateWasSelected:[selected.str intValue]];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	[self selectDayView:[touches anyObject]];
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event];
	[self selectDayView:[touches anyObject]];
}

- (void)dealloc {
	[dayTiles release];
	[dateOfFirst release];
	[marks release];
    [super dealloc];
}


@end




@implementation TKCalendarDayView
@synthesize selected,active,today,marked,str;

- (id)initWithFrame:(CGRect)frame {
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
