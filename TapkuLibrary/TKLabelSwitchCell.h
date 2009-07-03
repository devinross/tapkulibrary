//
//  TKLabelSlider.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLabelCell.h"

@interface TKLabelSwitchCell : TKLabelCell {
	UISwitch *switcher;
}
@property (retain,nonatomic) UISwitch *switcher;

@end
