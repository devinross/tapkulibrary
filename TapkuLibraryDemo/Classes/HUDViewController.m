//
//  HUDViewController.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 7/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUDViewController.h"


@implementation HUDViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"HUD";
	
	loading  = [[LoadingHUDView alloc] init];
	[self.view addSubview:loading];
	[loading setTitle:@"Loading"];
	[loading setMessage:@"Enter Description Here"];
	[loading startAnimating];
	loading.center = CGPointMake(self.view.bounds.size.width/2, 200);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}


@end
