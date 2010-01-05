//
//  TKCoverFlowViewController.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 1/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TKCoverFlowViewController.h"


@implementation TKCoverFlowViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	flowView = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0, 0, 480, 280)];
	flowView.backgroundColor = [UIColor blackColor];
	flowView.viewDelegate = self;
	flowView.dataSource = self;
	flowView.numberOfImages = 30;
	[self.view addSubview:flowView];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index{
	NSLog(@"BOB");
	[openFlowView setImage:[UIImage imageNamed:@"albumcover.jpg"] forIndex:index];
}
- (UIImage *)defaultImage{
	NSLog(@"COVERS");
	return [UIImage imageNamed:@"albumcover.jpg"];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	
	//return YES;
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


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
