//
//  LabelViewController.m
//  Created by Devin Ross on 7/4/09.
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

#import "LabelViewController.h"


@implementation LabelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Label Cells";
	
	static NSString *CellIdentifier = @"Cell";
	
	cells = [[NSMutableArray alloc] init];
	
	TKLabelFieldCell *cell1 = [[TKLabelFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
	cell1.label.text = @"Field";
	cell1.field.text = @"Non Editable Text";
	[cells addObject:cell1];
	[cell1 release];
	
	TKLabelTextViewCell *cell2 = [[TKLabelTextViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
	cell2.label.text = @"Text View";
	cell2.textView.text = @"List of cells:\nTKLabelFieldCell\nTKLabelTextViewCell\nTKLabelTextFieldCell\nTKLabelSwitchCell\n";
	[cells addObject:cell2];
	[cell2 release];
	
	TKLabelTextFieldCell *cell3 = [[TKLabelTextFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
	cell3.label.text = @"Text Field";
	cell3.field.text = @"Press to edit";
	[cells addObject:cell3];
	[cell3 release];
	
	TKLabelSwitchCell *cell4 = [[TKLabelSwitchCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
	cell4.label.text = @"Switch";
	[cells addObject:cell4];
	[cell4 release];
	
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return [cells objectAtIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row == 1){
		return 120.0;
	}
	return 44.0;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[cells release];
    [super dealloc];
}


@end

