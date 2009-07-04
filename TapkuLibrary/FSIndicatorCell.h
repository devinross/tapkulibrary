//
//  FSIndicatorCell.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface FSIndicatorCell : ABTableViewCell {
	NSString *_text;
	int _count;
	NSString *_countStr;
}

@property (copy,nonatomic) NSString *text;
@property (assign, nonatomic) int count;

@end
