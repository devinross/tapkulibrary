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


@interface TKCalendarMonthViewController () 
@property (nonatomic,strong) NSTimeZone *timeZone;
@property (nonatomic,assign) BOOL sundayFirst;
@end

@implementation TKCalendarMonthViewController

- (id) init{
	self = [self initWithSunday:YES];
	return self;
}
- (id) initWithSunday:(BOOL)sundayFirst{
	self = [self initWithSunday:sundayFirst timeZone:[NSTimeZone defaultTimeZone]];
	return self;
}
- (id) initWithTimeZone:(NSTimeZone *)timeZone{
	self = [self initWithSunday:YES timeZone:self.timeZone];
	return self;
}
- (id) initWithSunday:(BOOL)sundayFirst timeZone:(NSTimeZone *)timeZone{
	if(!(self = [super init])) return nil;
	self.timeZone = timeZone;
	self.sundayFirst = sundayFirst;
	return self;
}
- (id) initWithCoder:(NSCoder *)decoder {
    if(!(self=[super initWithCoder:decoder])) return nil;
	self.timeZone = [NSTimeZone defaultTimeZone];
	self.sundayFirst = YES;
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
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:self.sundayFirst timeZone:self.timeZone];
	self.monthView.dataSource = self;
	self.monthView.delegate = self;
	[self.view addSubview:self.monthView];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}


@end
