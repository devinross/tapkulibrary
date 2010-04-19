//
//  coverpadViewController.h
//  coverpad
//
//  Created by Devin Ross on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface coverflowViewController : UIViewController <TKCoverflowViewDelegate,TKCoverflowViewDataSource> {
	TKCoverflowView *coverflow;
	NSArray *covers;
	

}

@end

