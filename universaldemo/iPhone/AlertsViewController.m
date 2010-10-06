    //
//  AlertsViewController.m
//  universaldemo
//
//  Created by Devin Ross on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertsViewController.h"


@implementation AlertsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
}


- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Tap Me" style:UIBarButtonItemStylePlain target:self action:@selector(beer)] autorelease];
	

	
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Hi!"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"This is the alert system"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Use images too!" image:[UIImage imageNamed:@"beer"]];

}


- (void) beer{
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Beer!" image:[UIImage imageNamed:@"beer"]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}


@end
