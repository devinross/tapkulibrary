//
//  TKProgressCircleView.h
//  TapkuLibrary
//
//  Created by Devin Ross on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKProgressCircleView : UIView {
	BOOL _twirlMode;
	float _progress,_displayProgress;
}

- (id) init;

@property (assign,nonatomic) float progress; // between 0.0 & 1.0
@property (assign,nonatomic,getter=isTwirling) BOOL twirlMode;

- (void) setProgress:(float)progress animated:(BOOL)animated;


@end