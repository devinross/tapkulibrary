//
//  coverpadViewController.m
//  coverpad
//
//  Created by Devin Ross on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "coverflowViewController.h"

@implementation coverflowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	


	covers = [[NSArray arrayWithObjects:
			   [UIImage imageNamed:@"cover_2.jpg"],[UIImage imageNamed:@"cover_1.jpg"],
			   [UIImage imageNamed:@"cover_3.jpg"],[UIImage imageNamed:@"cover_4.jpg"],
			   [UIImage imageNamed:@"cover_5.jpg"],[UIImage imageNamed:@"cover_6.jpg"],
			   [UIImage imageNamed:@"cover_7.jpg"],[UIImage imageNamed:@"cover_8.jpg"],
			   [UIImage imageNamed:@"cover_9.jpg"],nil] retain];
	

	CGRect r = self.view.bounds;
	coverflow = [[TKCoverflowView alloc] initWithFrame:r];

	coverflow.delegate = self;
	coverflow.dataSource = self;
	[self.view addSubview:coverflow];
	coverflow.coverSpacing = 80;
	coverflow.coverSize = CGSizeMake(300, 300);
	
	[coverflow setNumberOfCovers:1060];
	

}


- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{
	//NSLog(@"Front %d",index);
}
- (TKCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index{
	
	TKCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil){


		cover = [[[TKCoverView alloc] initWithFrame:CGRectMake(0, 0, 300, 600)] autorelease]; // 224
		cover.baseline = 200;
	}
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
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
