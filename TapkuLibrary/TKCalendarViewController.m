//
//  DaterViewController.m
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
#import "TKCalendarViewController.h"


@implementation TKCalendarViewController
@synthesize calendarView;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	calendarView = [[TKCalendarView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 320, 200) 
												delegate:self];
	[self.view addSubview:calendarView];
	

	
}

- (NSArray*) calendarView:(TKCalendarView*)calendar daysOfMonthIsMarked:(NSDate*)monthDate{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:monthDate];
	
	[comps setMonth:comps.month+1];
	[comps setDay:0];
	
	NSDate *lastDayInMonth = [gregorian dateFromComponents:comps];
	int days = [[gregorian components:NSDayCalendarUnit fromDate:lastDayInMonth] day];
	
	NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:days];
	
	for(int i = 0; i < days; i++){
		if(i %2==0){
			[ar addObject:[NSNumber numberWithBool:YES]];
		}else{
			[ar addObject:[NSNumber numberWithBool:NO]];
		}
	}

	return ar;
}
- (void) calendarView:(TKCalendarView*)calendar dateWasSelected:(NSInteger)integer ofMonth:(NSDate*)monthDate{
	
	NSLog(@"Selected: %d %@",integer,monthDate);
}



- (void) calendarView:(TKCalendarView*)calendar movedToMonth:(NSDate*)monthDate{
	
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}

@end
