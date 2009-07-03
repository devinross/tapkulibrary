//
//  LoadingHUDView.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingHUDView : UIView {
	UIActivityIndicatorView *_activity;
	BOOL _hidden;

	NSString *_title;
	NSString *_message;
}


- (void) startAnimating;
- (void) stopAnimating;

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *message;




@end
