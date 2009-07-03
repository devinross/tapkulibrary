//
//  TKLabelTextfieldCell.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKLabelCell.h"

@interface TKLabelTextFieldCell : TKLabelCell {
	UITextField *field;
}
@property (retain, nonatomic) UITextField *field;
@end
