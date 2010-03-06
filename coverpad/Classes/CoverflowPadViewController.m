//
//  CoverflowPadViewController.m
//  CoverflowPad
//
//  Created by Devin Ross on 1/27/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "CoverflowPadViewController.h"

@implementation CoverflowPadViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
	
	
	covers = [[NSArray arrayWithObjects:
			   [UIImage imageNamed:@"cover_2.jpg"],[UIImage imageNamed:@"cover_1.jpg"],
			   [UIImage imageNamed:@"cover_3.jpg"],[UIImage imageNamed:@"cover_4.jpg"],
			   [UIImage imageNamed:@"cover_5.jpg"],[UIImage imageNamed:@"cover_6.jpg"],
			   [UIImage imageNamed:@"cover_7.jpg"],[UIImage imageNamed:@"cover_8.jpg"],
			   [UIImage imageNamed:@"cover_9.jpg"],nil] retain];
	
	
	coverflow = [[TKCoverflowView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
	coverflow.delegate = self;
	coverflow.dataSource = self;
	[self.view addSubview:coverflow];
	
	[coverflow setNumberOfCovers:60];
	coverflow.coverSize = CGSizeMake(400, 400);
	coverflow.coverSpacing = 140;
	//coverflow.angle = TKCoverflowViewCoverAngleMore;
	
	
}



- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{
	//NSLog(@"Front %d",index);
}
- (TKCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index;{
	
	TKCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil){
		cover = [[[TKCoverView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)] autorelease]; // 224
		
	}
	cover.baseline = 400;
	cover.image = [covers objectAtIndex:index%[covers count]];
	
	return cover;
	
}
- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index{
	
	
	TKCoverView *cover = [coverflowView coverAtIndex:index];
	if(cover == nil) return;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cover cache:YES];
	[UIView commitAnimations];
	

	
	
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
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
