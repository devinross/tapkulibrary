//
//  RootViewController.m
//  Created by Devin Ross on 7/1/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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
#import "OverviewController.h"
#import "EmptyViewController.h"
#import "GraphController.h"

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"TapkuLibrary";
	
	titles = [[NSMutableArray alloc] init];
	[titles addObject:@"Label Cells"];
	[titles addObject:@"Fast Scrolling Cells"];
	[titles addObject:@"Loading HUD"];
	[titles addObject:@"Place Pin MapView"];
	[titles addObject:@"Overview TableView Controller"];
	[titles addObject:@"Empty TableView Filler"];
	[titles addObject:@"Graph"];
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*//*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*//*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*//*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/






#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [titles objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
	
	

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row ==0){
		LabelViewController *anotherViewController = [[LabelViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[self.navigationController pushViewController:anotherViewController animated:YES];
		[anotherViewController release];
	}else if(indexPath.row == 1) {
		FastTableViewController *fast = [[FastTableViewController alloc] initWithStyle:UITableViewStylePlain];
		[self.navigationController pushViewController:fast animated:YES];
		[fast release];
	}else if(indexPath.row == 2) {
		HUDViewController *hud = [[HUDViewController alloc] init];
		[self.navigationController pushViewController:hud animated:YES];
		[hud release];
	}else if(indexPath.row==3){
		MapViewController *mvc = [[MapViewController alloc] init];
		[self.navigationController pushViewController:mvc animated:YES];
		[mvc release];
	}else if(indexPath.row==4){
		OverviewController *mvc = [[OverviewController alloc] init];
		[self.navigationController pushViewController:mvc animated:YES];
		[mvc release];
	}else if(indexPath.row==5){
		EmptyViewController *e = [[EmptyViewController alloc] init];
		[self.navigationController pushViewController:e animated:YES];
		[e release];
	}else{
		GraphController *graph = [[GraphController alloc] init];
		[graph setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:graph animated:YES];
		[graph release];
	}

}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*//*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*//*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*//*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}


@end

