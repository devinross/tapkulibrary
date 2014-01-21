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
#import "SlideToUnlockViewController.h"
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

- (id) initWithStyle:(UITableViewStyle)s{
	if(!(self = [super initWithStyle:s])) return nil;
	self.title = @"Tapku Library";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	return self;
}
- (NSUInteger) supportedInterfaceOrientations{
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? YES : UIInterfaceOrientationIsPortrait(interfaceOrientation) ;
}


#pragma mark View Lifecycle
- (void) viewDidLoad{
	[super viewDidLoad];

	self.data = @[
  @{@"rows" : @[@"Coverflow",@"Month Grid Calendar",@"Day Calendar"], @"title" : @"Views"},
  @{@"rows" : @[@"Empty Sign",@"Loading HUD",@"Alerts",@"Slide to Unlock",@"Buttons"], @"title" : @"UI Elements"},
  @{@"rows" : @[@"Label Cells",@"More Cells"], @"title" : @"Table View Cells"},
  @{@"rows" : @[@"Image Cache",@"HTTP Request Progress",@"Web ViewController"], @"title" : @"Network"}];
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
	
	UIViewController *vc;
	NSInteger s = indexPath.section, r = indexPath.row;
	
	if(s==0 && r == 0){
		vc = [[CoverflowViewController alloc] init];
		
		if(self.detailViewController)
			[self.detailViewController setupWithMainController:vc];
		else{
			[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
			[self presentViewController:vc animated:YES completion:nil];
		}

		return;
	}else if(s==0 && r==1)
		vc = [[CalendarMonthViewController alloc] initWithSunday:YES];
	
	else if(s==0 && r==2)
		vc = [[CalendarDayViewController alloc] init];
	
	else if(s==1 && r==0)
		vc = [[EmptyViewController alloc] init];
	else if(s==1 && r==1)
		vc = [[IndicatorsViewController alloc] init];
	else if(s==1 && r==2)
		vc = [[AlertsViewController alloc] init];
	else if(s==1 && r==3)
		vc = [[SlideToUnlockViewController alloc] init];
	else if(s==1 && r==4)
		vc = [[ButtonViewController alloc] init];
	
	else if(s==2 && r==0)
		vc = [[LabelViewController alloc] init];
	else if(s==2 && r==1)
		vc = [[MoreCellsViewController alloc] init];
	
	else if(s==3 && r==0)
		vc = [[ImageCenterViewController alloc] init];
	else if(s==3 && r==1)
		vc = [[NetworkRequestProgressViewController alloc] init];
	else
		vc = [[TKWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://apple.com"]];
	
	
	if(self.detailViewController && !(s==0))
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