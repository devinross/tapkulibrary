//
//  RootViewController.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 12/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "LabelViewController.h"
#import "FastTableViewController.h"
#import "HUDViewController.h"
#import "MapViewController.h"
#import "OverviewController.h"
#import "EmptyViewController.h"
#import "GraphController.h"
#import "DemoCalendarMonth.h"
#import "CoverflowViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Tapku Library";
	
	data = [[NSMutableArray alloc] init];
	
	NSArray *rows;
	NSDictionary *d;
	
	
	
	rows = [NSArray arrayWithObjects:@"Coverflow",@"Graph",@"Overview Tableview",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Views",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Empty Sign",@"Loading HUD",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"UI Elements",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Month",@"Day",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Calendar",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Place Pins",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Maps",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Label Cells",@"Fast Scrolling Cells",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Cells",@"title",nil];
	[data addObject:d];
	
	
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[data objectAtIndex:section] objectForKey:@"rows"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [[[data objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
	
	
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController *vc;
	int s = indexPath.section, r = indexPath.row;
	
	if(s==0 && r < 2){
		
		if(r==0)
			vc = [[CoverflowViewController alloc] init];
		else 
			vc = [[GraphController alloc] init];
		
		[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:vc animated:YES];
		[vc release];
		return;
	}
	
	else if(s==0 && r==2)
		vc = [[OverviewController alloc] init];
	
	else if(s==1 && r==0)
		vc = [[EmptyViewController alloc] init];
	
	else if(s==1 && r==1)
		vc = [[HUDViewController alloc] init];
	
	
	
	else if(s==2 && r==0)
		vc = [[DemoCalendarMonth alloc] init];
	else if(s==2 && r==1)
		vc = [[ODCalendarDayViewController alloc] init];
	
	
	else if(s==3 && r==0)
		vc = [[MapViewController alloc] init];
	
	
	else if(s==4 && r==0)
		vc = [[LabelViewController alloc] initWithStyle:UITableViewStyleGrouped];
	else if(s==4 && r==1)
		vc = [[FastTableViewController alloc] initWithStyle:UITableViewStylePlain];
	
	
	
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[data objectAtIndex:section] objectForKey:@"title"];
}


- (void)dealloc {
	[data release];
    [super dealloc];
}


@end

