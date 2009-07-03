//
//  TKButtonCell.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKButtonCell : UITableViewCell {
	UILabel *label;
}

@property (copy,nonatomic) NSString *text;

@end
