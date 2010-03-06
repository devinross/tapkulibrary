//
//  CoverflowPadViewController.h
//  CoverflowPad
//
//  Created by Devin Ross on 1/27/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCoverflowView.h"
#import "TKCoverView.h"

@interface CoverflowPadViewController : UIViewController <TKCoverflowViewDelegate,TKCoverflowViewDataSource> {

	
	TKCoverflowView *coverflow; 
	
	
	NSMutableArray *covers; // album covers images
	
}

@end

