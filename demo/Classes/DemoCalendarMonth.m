//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "DemoCalendarMonth.h"

@implementation DemoCalendarMonth


- (void) generateRandomData{
	
	[currentMonthData removeAllObjects];
	
	for(int cnt=0;cnt<31;cnt++){
		int r = rand();
		if(r % 3==1){
			[currentMonthData addObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil]];
		}else if(r%4==1){
			[currentMonthData addObject:[NSArray arrayWithObjects:@"Item one",nil]];
		}else{
			[currentMonthData addObject:[NSNull null]];
		}
		
	}
}

- (void) viewDidLoad{
	
	srand([[NSDate date] timeIntervalSince1970]);
	
	
	currentMonthData = [[NSMutableArray alloc] init];

	[self generateRandomData];

	[super viewDidLoad];
	currentDate = [[NSDate date] dateInformation];
	[self.monthView selectDate:[NSDate date]];
}

- (BOOL) calendarMonthView:(TKCalendarMonthView*)monthView markForDay:(NSDate*)date{
	NSObject *obj = [currentMonthData objectAtIndex:[date dateInformation].day-1];
	if((NSNull *)obj == [NSNull null]) return NO;
	return YES;
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthWillAppear:(NSDate*)month{
	[super calendarMonthView:mv monthWillAppear:month];
	[self generateRandomData];
	[self.monthView reload];
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView dateWasSelected:(NSDate*)date{
	currentDate = [date dateInformation];
	[self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	
	NSObject *obj = [currentMonthData objectAtIndex:currentDate.day-1];
	if((NSNull *)obj == [NSNull null]) return 0;
	return [(NSArray*)obj count];
	
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[currentMonthData objectAtIndex:currentDate.day-1] objectAtIndex:indexPath.row];
    
	// Configure the cell.
	
    return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.monthView reload];
}



@end
