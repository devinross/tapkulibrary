//
//  TTProgressWindow.h
//  TapTapShare
//
//  Created by Devin Ross on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKProgressBarView.h"

@interface TKProgressAlertView : UIAlertView {
	TKProgressBarView *progressBar;
	UILabel *label;
}
@property (retain,nonatomic,readonly) TKProgressBarView *progressBar;
@property (retain,nonatomic,readonly) UILabel *label;
- (id) initWithProgressTitle:(NSString*)title;
- (void) show;
- (void) hide;

@end
