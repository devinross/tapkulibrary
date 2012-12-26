//
//  LabelViewController.m
//  Created by Devin Ross on 7/4/09.
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

#import "LabelViewController.h"
@implementation LabelViewController

- (id) init{
	if(!(self=[super initWithStyle:UITableViewStyleGrouped])) return nil;
	self.title = @"Label Cells";
	return self;
}

#pragma mark - View Lifecycle
- (void) loadView{
	[super loadView];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	
	TKLabelFieldCell *cell1 = [[TKLabelFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell1.label.text = @"Field";
	cell1.field.text = @"Non Editable Text";
	
	TKLabelTextViewCell *cell2 = [[TKLabelTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell2.label.text = @"Text View";
	cell2.textView.text = @"List of cells:\nTKLabelFieldCell\nTKLabelTextViewCell\nTKLabelTextFieldCell\nTKLabelSwitchCell\n";
	
	TKLabelTextFieldCell *cell3 = [[TKLabelTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell3.label.text = @"Text Field";
	cell3.field.text = @"Press to edit";
	
	TKLabelSwitchCell *cell4 = [[TKLabelSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell4.label.text = @"Switch";
	
	
	self.cells = @[cell1,cell2,cell3,cell4];

}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cells count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.cells objectAtIndex:indexPath.row];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return indexPath.row == 1 ? 120 : 44;
}

@end