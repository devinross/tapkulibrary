//
//  TKInfoHeaderTableViewController.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoHeaderView.h"


@interface TKInfoHeaderTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	InfoHeaderView *header;
	UITableView *tableView;
	
}


@property (nonatomic,copy) NSString *titleLabel;
@property (nonatomic,copy) NSString *subtitleLabel;



@end
