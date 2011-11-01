//
//  RootViewController.m
//  Created by Devin Ross on 12/2/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
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

#import "RootViewController.h"

#import "LabelViewController.h"
#import "FastTableViewController.h"
#import "HUDViewController.h"
#import "MapViewController.h"
#import "EmptyViewController.h"
#import "DemoCalendarMonth.h"
#import "CoverflowViewController.h"
#import "MoreCellsViewController.h"
#import "AlertsViewController.h"
#import "ImageCenterViewController.h"
#import "NetworkRequestViewController.h"

@implementation RootViewController

- (id) initWithStyle:(UITableViewStyle)s{
	if(!(self = [super initWithStyle:s])) return nil;
	
	self.title = @"Tapku Library";
	

	
	return self;
}
- (void) dealloc {
	[data release];
    [super dealloc];
}

- (void) setupCellData{
	NSArray *rows;
	NSDictionary *d;
	
	
	[data release];
	
	NSMutableArray *tmp = [NSMutableArray array];
	
	
	rows = [NSArray arrayWithObjects:@"Coverflow",@"Month Grid Calendar",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Views",@"title",nil];
	[tmp addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Empty Sign",@"Loading HUD",@"Alerts",@"Place Pins",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"UI Elements",@"title",nil];
	[tmp addObject:d];
	
	//rows = [NSArray arrayWithObjects:@"Month",nil];
	//d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Calendar",@"title",nil];
	//[data addObject:d];
	
	
	rows = [NSArray arrayWithObjects:@"Label Cells",@"More Cells",@"Indicator Cells",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Table View Cells",@"title",@"",@"footer",nil];
	[tmp addObject:d];
	
	rows = [NSArray arrayWithObjects:@"Image Cache",@"HTTP Request",nil];
	d = [NSDictionary dictionaryWithObjectsAndKeys:rows,@"rows",@"Network",@"title",@"",@"footer",nil];
	[tmp addObject:d];
	
	data = [[NSArray alloc] initWithArray:tmp];
}
- (void) viewDidLoad{
	[super viewDidLoad];
	[self setupCellData];
}



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[data objectAtIndex:section] objectForKey:@"rows"] count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[[data objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
	
	
	
}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	
	UIViewController *vc;
	int s = indexPath.section, r = indexPath.row;
	
	if(s==0 && r < 1){
		
		//if(r==0)
		vc = [[CoverflowViewController alloc] init];

		[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:vc animated:YES];
		[vc release];
		return;
	}
	
	if(s==0&&r==1)
		vc = [[DemoCalendarMonth alloc] initWithSunday:NO];

	
	
	
	else if(s==1 && r==0)
		vc = [[EmptyViewController alloc] init];
	
	else if(s==1 && r==1)
		vc = [[HUDViewController alloc] init];
	else if(s==1 && r==2)
		vc = [[AlertsViewController alloc] init];
	else if(s==1 && r==3)
		vc = [[MapViewController alloc] init];
	
	
	/*
	else if(s==2 && r==0)
		vc = [[DemoCalendarMonth alloc] initWithSunday:YES];
	else if(s==2 && r==1)
		vc = [[TKCalendarDayViewController alloc] init];
	*/
	
	else if(s==2 && r==0)
		vc = [[LabelViewController alloc] initWithStyle:UITableViewStyleGrouped];
	else if(s==2 && r==1)
		vc = [[MoreCellsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	else if(s==2 && r==2)
		vc = [[FastTableViewController alloc] init];
	else if(s==3 && r==0)
		vc = [[ImageCenterViewController alloc] init];
	else
		vc = [[NetworkRequestViewController alloc] init];
	
	
	
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
	
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[data objectAtIndex:section] objectForKey:@"title"];
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return [[data objectAtIndex:section] objectForKey:@"footer"];
}

@end