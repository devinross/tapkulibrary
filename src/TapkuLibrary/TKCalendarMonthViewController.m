//
//  DaterViewController.m
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
#import "TKCalendarMonthViewController.h"
#import "TKCalendarMonthView.h"


@interface TKCalendarMonthViewController () {
	BOOL _sundayFirst;
}

@end

@implementation TKCalendarMonthViewController
@synthesize monthView = _monthView;

- (id) init{
	return [self initWithSunday:YES];
}
- (id) initWithSunday:(BOOL)sundayFirst{
	if(!(self = [super init])) return nil;
	_sundayFirst = sundayFirst;
	return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void) viewDidUnload {
	self.monthView = nil;
}


- (void) loadView{
	[super loadView];
	
	_monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:_sundayFirst];
	_monthView.delegate = self;
	_monthView.dataSource = self;
	[self.view addSubview:_monthView];
	[_monthView reload];
	
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}


@end
