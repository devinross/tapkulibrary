//
//  TKCalendarMonthTableViewController.m
//  Created by Devin Ross on 10/31/09.
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
#import "TKCalendarMonthTableViewController.h"
#import "NSDate+TKCategory.h"

@implementation TKCalendarMonthTableViewController
@synthesize tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - y;
	

	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, height) style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	[self.view sendSubviewToBack:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

	
    return cell;
	
}


- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d{
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)d{
	[self updateTableOffset];
}


- (void) updateTableOffset{
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	
	float y = monthView.frame.origin.y + monthView.frame.size.height;
	self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, y, self.tableView.frame.size.width, self.view.frame.size.height - y );
	
	[UIView commitAnimations];
}




- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
