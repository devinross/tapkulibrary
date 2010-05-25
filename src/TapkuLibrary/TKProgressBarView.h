//
//  TKProgressBar.h
//  TapkuLibrary
//
//  Created by Devin Ross on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	TKProgressBarViewStyleLong,
	TKProgressBarViewStyleShort
} TKProgressBarViewStyle;

@interface TKProgressBarView : UIView {
	
	TKProgressBarViewStyle style;
	float progress;
}

- (id) initWithStyle:(TKProgressBarViewStyle)style;


@property (assign,nonatomic) float progress; // a value between 0.0 and 1.0

@end
