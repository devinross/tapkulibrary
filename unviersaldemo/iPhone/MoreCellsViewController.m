//
//  MoreCellsViewController.m
//  Created by Devin Ross on 4/15/10.
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

#import "MoreCellsViewController.h"


@implementation MoreCellsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	buttonCell = [[TKButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"button"];
	buttonCell.title.text = @"This is a BUTTON Cell";
	
	switchCell = [[TKSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	switchCell.title.text = @"Switch Cell";
	
	textViewCell = [[TKTextViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	textViewCell.textView.text = @"TextView Cell - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent blandit malesuada turpis quis egestas. Curabitur varius nunc nec leo tincidunt mattis. Cras malesuada euismod lobortis. Praesent ultrices malesuada lorem et convallis. Pellentesque hendrerit lectus eget felis rutrum vel volutpat nisl semper. Suspendisse consectetur sem eu arcu ullamcorper ut cursus est fringilla. Suspendisse blandit rhoncus nisi ac lacinia. Curabitur vestibulum mattis eros a accumsan. Morbi pulvinar consequat hendrerit. In hac habitasse platea dictumst. Mauris euismod convallis faucibus. Morbi faucibus ultricies elit, ac ullamcorper ipsum accumsan et.";
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
	if(indexPath.section==0)
		return buttonCell;
	if(indexPath.section==1)
		return switchCell;
	if(indexPath.section==2)
		return textViewCell;
	
	return nil;
	
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == 2){
		return 140.0;
	}
	return 44.0;
	
}

- (void)dealloc {
	[textViewCell release];
	[switchCell release];
	[buttonCell release];
	[super dealloc];
}


@end

