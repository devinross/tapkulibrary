//
//  TKSwitchCell.h
//  ToDoLists
//
//  Created by Devin Ross on 6/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKSwitchCell : UITableViewCell {
	UILabel *title;
	UISwitch *slider;
}

@property (copy,nonatomic) NSString *text;
@property (assign, nonatomic) UISwitch *slider;

@end
