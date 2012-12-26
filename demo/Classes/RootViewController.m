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

#import "DetailViewController.h"

#import "LabelViewController.h"
#import "HUDViewController.h"
#import "EmptyViewController.h"
#import "CalendarMonthViewController.h"
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


#pragma mark - View Lifecycle
- (void) viewDidLoad{
	[super viewDidLoad];

	NSArray *rows;
	NSMutableArray *tmp = [NSMutableArray array];
	
	rows = @[@"Coverflow",@"Month Grid Calendar"];
	[tmp addObject:@{@"rows" : rows, @"title" : @"Views"}];
	
	rows = @[@"Empty Sign",@"Loading HUD",@"Alerts"];
	[tmp addObject:@{@"rows" : rows, @"title" : @"UI Elements"}];
	
	rows = @[@"Label Cells",@"More Cells"];
	[tmp addObject:@{@"rows" : rows, @"title" : @"Table View Cells"}];
	
	rows = @[@"Image Cache",@"HTTP Request"];
	[tmp addObject:@{@"rows" : rows, @"title" : @"Network"}];
	
	self.data = tmp;
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.data objectAtIndex:section] objectForKey:@"rows"] count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [[[self.data objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *vc;
	int s = indexPath.section, r = indexPath.row;
	
	if(s==0 && r < 1){
		vc = [[CoverflowViewController alloc] init];
		
		if(self.detailViewController)
			[self.detailViewController setupWithMainController:vc];
		else{
			[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
			[self presentModalViewController:vc animated:YES];
		}

		return;
	}else if(s==0 && r==1)
		vc = [[CalendarMonthViewController alloc] initWithSunday:YES];
	
	else if(s==1 && r==0)
		vc = [[EmptyViewController alloc] init];
	else if(s==1 && r==1)
		vc = [[HUDViewController alloc] init];
	else if(s==1 && r==2)
		vc = [[AlertsViewController alloc] init];
	
	else if(s==2 && r==0)
		vc = [[LabelViewController alloc] init];
	else if(s==2 && r==1)
		vc = [[MoreCellsViewController alloc] init];
	
	else if(s==3 && r==0)
		vc = [[ImageCenterViewController alloc] init];
	else
		vc = [[NetworkRequestViewController alloc] init];
	
	
	if(self.detailViewController && !(s==0 && r==1))
		[self.detailViewController setupWithMainController:vc];
	else
		[self.navigationController pushViewController:vc animated:YES];
	
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[self.data objectAtIndex:section] objectForKey:@"title"];
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return [[self.data objectAtIndex:section] objectForKey:@"footer"];
}

@end