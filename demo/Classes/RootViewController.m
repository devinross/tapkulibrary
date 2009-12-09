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

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Tapku Library";
	
	data = [[NSMutableArray alloc] init];
	
	NSArray *rows;
	NSDictionary *d;
	
	rows = [NSArray arrayWithObjects:@"Graph View",@"Empty View",@"Overview TableView",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Views",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Month",@"Day",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Calendar",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Label Cells",@"Fast Scrolling Cells",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Cells",@"title",nil];
	[data addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Place Pin MapView",@"Loading HUD",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Extra",@"title",nil];
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
	
	if(indexPath.section==0 && indexPath.row==0){
		GraphController *graph = [[GraphController alloc] init];
		[graph setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:graph animated:YES];
		[graph release];
		return;
	}else if(indexPath.section==0 && indexPath.row==1)
		vc = [[EmptyViewController alloc] init];
	else if(indexPath.section==0 && indexPath.row==2)
		vc = [[OverviewController alloc] init];
	else if(indexPath.section==1 && indexPath.row==0)
		vc = [[DemoCalendarMonth alloc] init];
	else if(indexPath.section==1 && indexPath.row==1)
		vc = [[ODCalendarDayViewController alloc] init];
	else if(indexPath.section==2 && indexPath.row==0)
		vc = [[LabelViewController alloc] initWithStyle:UITableViewStyleGrouped];
	else if(indexPath.section==2 && indexPath.row==1)
		vc = [[FastTableViewController alloc] initWithStyle:UITableViewStylePlain];
	else if(indexPath.section==3 && indexPath.row==0)
		vc = [[MapViewController alloc] init];
	else if(indexPath.section==3 && indexPath.row==1)
		vc = [[HUDViewController alloc] init];
	
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

