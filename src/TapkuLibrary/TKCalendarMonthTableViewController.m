//
//  TKCalendarMonthTableViewController.m
//  TapkuLibrary
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKCalendarMonthTableViewController.h"
#import "NSDateAdditions.h"

@implementation TKCalendarMonthTableViewController
@synthesize tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - y;
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, 320, height) style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	[self.view sendSubviewToBack:tableView];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthWillAppear:(NSDate*)month{
	float y = mv.frame.origin.y + mv.frame.size.height;
	float height = self.view.frame.size.height - y;
	tableView.frame = CGRectMake(0, y, 320, height);
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
    
    
	// Configure the cell.
	
    return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.monthView reload];
}


- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{

	return NO;
}



- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
