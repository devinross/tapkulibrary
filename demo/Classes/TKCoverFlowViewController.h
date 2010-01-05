//
//  TKCoverFlowViewController.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 1/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>


@interface TKCoverFlowViewController : UIViewController <AFOpenFlowViewDelegate,AFOpenFlowViewDataSource> {
	AFOpenFlowView *flowView;
}

@end
