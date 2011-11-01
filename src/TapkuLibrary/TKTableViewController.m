//
//  TKTableViewController.m
//  Created by Devin Ross on 11/19/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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

#import "TKTableViewController.h"
#import "TKEmptyView.h"
#import "UIScrollview+TKCategory.h"


@implementation TKTableViewController
@synthesize tableView = _tableView, emptyView = _emptyView;
@synthesize searchBar = _searchBar, searchBarDisplayController = _searchBarDisplayController;

// -----------------------------
#pragma mark - Init & Friends
- (id) init{
	self = [self initWithStyle:UITableViewStylePlain];
	return self;
}
- (id) initWithStyle:(UITableViewStyle)style{
	if(!(self = [super init])) return nil;
	_style = style;
	_tableViewContentOffset = CGPointZero;
	return self;
}
- (void) _unloadSubviews{
	
	_tableViewContentOffset = self.tableView.contentOffset;
	
	self.tableView = nil;
	self.emptyView = nil;
	self.searchBar = nil;
	self.searchBarDisplayController = nil;
}
- (void) viewDidUnload {
	[self _unloadSubviews];
	[super viewDidUnload];
}
// -----------------------------


#pragma mark - View Load / Events
- (void) loadView{
	[super loadView];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.showsVerticalScrollIndicator = YES;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.contentOffset = _tableViewContentOffset;
	
	[self.view addSubview:_tableView];
}



// -----------------------------
#pragma mark - TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
// -----------------------------



// -----------------------------
#pragma mark - Properties
- (TKEmptyView*) emptyView{
	if(_emptyView==nil){
		_emptyView = [[TKEmptyView alloc] initWithFrame:self.view.bounds emptyViewImage:TKEmptyViewImageSearch title:nil subtitle:nil];
		_emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return _emptyView;
}
- (UISearchBar*) searchBar{
	if(_searchBar==nil){
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
		_searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	return _searchBar;
}
- (UISearchDisplayController*) searchBarDisplayController{
	if(_searchBarDisplayController==nil){
		_searchBarDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
		_searchBarDisplayController.delegate = self;
		_searchBarDisplayController.searchResultsDataSource = self;
		_searchBarDisplayController.searchResultsDelegate = self;
	}
	return _searchBarDisplayController;
}
// -----------------------------

@end
