//
//  InfoHeaderView.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoHeaderView : UIView {
	UILabel *title;
	UILabel *subtitle;
}

@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *subtitle;
@end
