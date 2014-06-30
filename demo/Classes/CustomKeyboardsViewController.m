//
//  CustomKeyboardsViewController.m
//  Created by Devin Ross on 3/21/14.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

#import "CustomKeyboardsViewController.h"

@interface CustomKeyboardsViewController ()
@property (nonatomic,strong) NSArray *cells;
@end

@implementation CustomKeyboardsViewController

- (instancetype) init{
	if(!(self=[super initWithStyle:UITableViewStyleGrouped])) return nil;
	self.title = NSLocalizedString(@"Custom Keyboards", @"");
	return self;
}

- (void) loadView{
	[super loadView];
	
	self.numberFieldCell = [[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	self.numberInputView = [[TKNumberInputWithNextKeyView alloc] initWithFrame:CGRectZero];
	self.numberInputView.textField = self.numberFieldCell.textField;
	self.numberInputView.delegate = self;
	self.numberInputView.textField.placeholder = NSLocalizedString(@"Number Field", @"");
	self.numberFieldCell.textField.inputView = self.numberInputView;
	
	self.decimalFieldCell = [[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	self.decimalInputView = [[TKDecimalInputWithNextKeyView alloc] initWithFrame:CGRectZero];
	self.decimalInputView.delegate = self;
	self.decimalInputView.textField = self.decimalFieldCell.textField;
	self.decimalInputView.textField.placeholder = NSLocalizedString(@"Decimal Field", @"");
	self.decimalFieldCell.textField.inputView = self.decimalInputView;
	
	self.cells = @[self.numberFieldCell,self.decimalFieldCell];
	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.numberFieldCell.textField becomeFirstResponder];
}

- (void) inputView:(TKInputView *)inputView didSelectKey:(TKInputKey *)key{
	
	if(inputView == self.numberInputView){
		
		[self.decimalFieldCell.textField becomeFirstResponder];
		
	}else if(inputView == self.decimalInputView){
		
		[self.numberFieldCell.textField becomeFirstResponder];

	}
	
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	return self.cells[indexPath.row];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}

@end