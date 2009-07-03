//
//  TKLabelFieldCell.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLabelCell.h"

@interface TKLabelFieldCell : TKLabelCell {
	UILabel *field;
}
@property (retain, nonatomic) UILabel *field;
@end

