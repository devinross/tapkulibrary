//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "DemoCalendarMonth.h"


@implementation DemoCalendarMonth


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	//NSLog(@"%@ %@",start,end);
	
	[dataArray release];
	[dataDictionary release];
	dataArray = [[NSMutableArray alloc] init];
	dataDictionary = [[NSMutableDictionary alloc] init];
	
	NSDate *d = start;
	
	while(YES){
		
		int r = rand();
		if(r % 3==1){
			[dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil] forKey:d];
			[dataArray addObject:[NSNumber numberWithBool:YES]];
		}else if(r%4==1){
			[dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",nil] forKey:d];
			[dataArray addObject:[NSNumber numberWithBool:YES]];
		}else{
			[dataArray addObject:[NSNumber numberWithBool:NO]];
		}
		
		TKDateInformation info = [d dateInformation];
		info.day++;
		d = [NSDate dateFromDateInformation:info];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
	

	

}

- (void) viewDidLoad{
	
	srand([[NSDate date] timeIntervalSince1970]);
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate date]];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	
	[self generateRandomDataForStartDate:startDate endDate:lastDate];
	return dataArray;
	
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d{
	
	NSLog(@"%@",d);
	
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d{
	[super calendarMonthView:mv monthDidChange:d];
	[self.tableView reloadData];
	NSLog(@"Month Did Change: %@ %@",d,[monthView dateSelected]);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	
	NSArray *ar = [dataDictionary objectForKey:[monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
	

	
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    
    
	NSArray *ar = [dataDictionary objectForKey:[monthView dateSelected]];
	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
	
    return cell;
	
}


@end
