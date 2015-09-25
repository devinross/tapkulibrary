//
//  RootViewController.m
//  Created by Devin Ross on 12/2/09.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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
#import "IndicatorsViewController.h"
#import "EmptyViewController.h"
#import "CalendarMonthViewController.h"
#import "CoverflowViewController.h"
#import "MoreCellsViewController.h"
#import "AlertsViewController.h"
#import "ImageCenterViewController.h"
#import "NetworkRequestProgressViewController.h"
#import "CalendarDayViewController.h"
#import "ButtonViewController.h"

@interface UINavigationController (Rotation_IOS6)
@end

@implementation UINavigationController (Rotation_IOS6)

- (BOOL) shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}
- (NSUInteger) supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

@implementation RootViewController

- (instancetype) initWithStyle:(UITableViewStyle)s{
	if(!(self = [super initWithStyle:s])) return nil;
	self.title = @"Tapku Library";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	return self;
}
- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? YES : UIInterfaceOrientationIsPortrait(interfaceOrientation) ;
}

#define COVERFLOW NSLocalizedString(@"Coverflow", @"")
#define MONTH_GRID NSLocalizedString(@"Month Grid Calendar", @"")
#define DAY_VIEW NSLocalizedString(@"Day View Calendar", @"")
#define EMPTY_SIGN NSLocalizedString(@"Empty Sign", @"")
#define HUD NSLocalizedString(@"Loading HUD",@"")
#define ALERTS NSLocalizedString(@"Alerts",@"")
#define BUTTONS NSLocalizedString(@"Buttons",@"")
#define LABEL_CELLS NSLocalizedString(@"Label Cells",@"")
#define MORE_CELLS NSLocalizedString(@"More Cells",@"")
#define IMAGE_CACHE NSLocalizedString(@"Image Cache",@"")
#define HTTP_PROGRESS NSLocalizedString(@"HTTP Request Progress",@"")

#pragma mark View Lifecycle
- (void) viewDidLoad{
	[super viewDidLoad];

	self.data = @[
  @{@"rows" : @[DAY_VIEW,MONTH_GRID,COVERFLOW], @"title" : @"Views"},
  @{@"rows" : @[BUTTONS,HUD,EMPTY_SIGN,ALERTS], @"title" : @"UI Elements"},
  @{@"rows" : @[LABEL_CELLS,MORE_CELLS], @"title" : @"Table View Cells"},
  @{@"rows" : @[IMAGE_CACHE,HTTP_PROGRESS], @"title" : @"Network"}];
}


#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.data[section][@"rows"] count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = self.data[indexPath.section][@"rows"][indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
	UIViewController *vc;
	NSString *str = cell.textLabel.text;
	

	
	if([str isEqualToString:COVERFLOW]){
		vc = [[CoverflowViewController alloc] init];
		
		if(self.detailViewController)
			[self.detailViewController setupWithMainController:vc];
		else{
			[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
			[self presentViewController:vc animated:YES completion:nil];
		}

		return;
	}else if([str isEqualToString:MONTH_GRID])
		vc = [[CalendarMonthViewController alloc] initWithSunday:YES];
	
	else if([str isEqualToString:DAY_VIEW])
		vc = CalendarDayViewController.new;
	

	
	else if([str isEqualToString:EMPTY_SIGN])
		vc = EmptyViewController.new;
	else if([str isEqualToString:HUD])
		vc = IndicatorsViewController.new;
	else if([str isEqualToString:ALERTS])
		vc = AlertsViewController.new;

	else if([str isEqualToString:BUTTONS])
		vc = ButtonViewController.new;
	
	

	
	else if([str isEqualToString:LABEL_CELLS])
		vc = LabelViewController.new;
	else if([str isEqualToString:MORE_CELLS])
		vc = MoreCellsViewController.new;
	
	else if([str isEqualToString:IMAGE_CACHE])
		vc = ImageCenterViewController.new;
	else if([str isEqualToString:HTTP_PROGRESS])
		vc = NetworkRequestProgressViewController.new;
	
	
	if(self.detailViewController && ([str isEqualToString:MONTH_GRID] || [str isEqualToString:DAY_VIEW]))
		[self.detailViewController setupWithMainController:vc];
	else
		[self.navigationController pushViewController:vc animated:YES];
	
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return self.data[section][@"title"];
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return self.data[section][@"footer"];
}

@end