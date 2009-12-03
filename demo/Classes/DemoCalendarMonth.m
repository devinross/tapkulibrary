//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "DemoCalendarMonth.h"


@implementation DemoCalendarMonth

- (void) viewDidLoad{
	[super viewDidLoad];
	
	srand([[NSDate date] timeIntervalSince1970]);
}

// data source

- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
	NSLog(@"Mark for day: %@",date);
	return (rand() % 2 == 0) ? YES : NO;
}

// delegate

- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date{
	NSLog(@"%@",date);
	[tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthWillAppear:(NSDate*)month{
	[super calendarMonthView:mv monthWillAppear:month];
	
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rand() % 5;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
	// Configure the cell.
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %d (Tap to reload marks)",indexPath.row];
	
    return cell;
	
}



@end
