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
@synthesize tableView = _tableView, emptyView = _emptyView, loadingView = _loadingView;
@synthesize searchBar = _searchBar, searchBarController = _searchBarController;

// -----------------------------
// INIT & FRIENDS
- (id) init{
	self = [self initWithStyle:UITableViewStylePlain];
	return self;
}
- (id) initWithStyle:(UITableViewStyle)style{
	if(!(self = [super init])) return nil;
	
	_style = style;
	
	return self;
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) _unloadSubviews{
	self.tableView = nil;
	self.emptyView = nil;
	self.loadingView = nil;
	self.searchBar = nil;
	self.searchBarController = nil;
}
- (void) viewDidUnload {
	[self _unloadSubviews];
	[super viewDidUnload];
}
- (void) dealloc {
	[self _unloadSubviews];
    [super dealloc];
}
// -----------------------------

- (void) loadView{
	[super loadView];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.showsVerticalScrollIndicator = YES;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:self.tableView];
}



// -----------------------------
// TABLEVIEW 
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
// PROPERTIES
- (TKEmptyView*) emptyView{
	if(_emptyView==nil){
		_emptyView = [[TKEmptyView alloc] initWithFrame:self.view.bounds 
										 emptyViewImage:TKEmptyViewImageSearch title:nil subtitle:nil];
		_emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	}
	return _emptyView;
}
- (UIView*) loadingView{
	if(_loadingView==nil){
		_loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
		_loadingView.backgroundColor = [UIColor clearColor];
		_loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		act.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

		act.center = _loadingView.center;
		[act startAnimating];
		[_loadingView addSubview:act];
		[act release];
	}
	return _loadingView;
}
- (UISearchBar*) searchBar{
	if(_searchBar==nil){
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
		_searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	return _searchBar;
}
- (UISearchDisplayController*) searchBarController{
	if(_searchBarController==nil){
		_searchBarController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
		_searchBarController.delegate = self;
		_searchBarController.searchResultsDataSource = self;
		_searchBarController.searchResultsDelegate = self;
	}
	return _searchBarController;
}
// -----------------------------

@end
