    //
//  AlertsViewController.m
//  universaldemo
//
//  Created by Devin Ross on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertsViewController.h"


@implementation AlertsViewController

- (id) init{
	if(!(self=[super init])) return nil;
	self.title = NSLocalizedString(@"Alerts",@"Alerts");
	
	[TKAlertCenter defaultCenter];
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	

}


- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	self.navigationItem.rightBarButtonItem = [[[TKBarButtonItem alloc] initWithTitle:@"Tap Me" style:TKBarButtonItemStylePlain target:self action:@selector(beer)] autorelease];


	
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Hi!"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"This is the alert system"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Use images too!" image:[UIImage imageNamed:@"beer"]];


}






- (void) beer{
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Beer!" image:[UIImage imageNamed:@"beer"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

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
