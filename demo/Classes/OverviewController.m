//
//  OverviewController.m
//  Created by Devin Ross on 7/13/09.
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

#import "OverviewController.h"


@implementation OverviewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.header.title.text = @"Title Label";
	self.header.subtitle.text = @"Subtitle";
	self.header.indicator.text = @"Green";
	self.header.indicator.color = TKOverviewIndicatorViewColorGreen;
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	if(indexPath.row == 0)
		cell.textLabel.text = @"Blue";
	if(indexPath.row == 1)
		cell.textLabel.text = @"Red";
	if(indexPath.row == 2)
		cell.textLabel.text = @"Green";
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row==0){
		self.header.indicator.color = TKOverviewIndicatorViewColorBlue;
		self.header.indicator.text = @"Blue";
	}else if(indexPath.row==1){
		self.header.indicator.color = TKOverviewIndicatorViewColorRed;
		self.header.indicator.text = @"Red";
	}else if(indexPath.row==2){
		self.header.indicator.color = TKOverviewIndicatorViewColorGreen;
		self.header.indicator.text = @"Green";
	}
		
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [NSString stringWithFormat:@"Section %d",section+1];
}





- (void)dealloc {
    [super dealloc];
}


@end
