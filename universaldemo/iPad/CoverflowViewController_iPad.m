//
//  coverpadViewController.m
//  Created by Devin Ross on 4/17/10.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "CoverflowViewController_iPad.h"

@implementation CoverflowViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];


	covers = [[NSArray arrayWithObjects:
			   [UIImage imageNamed:@"ipadcover_2.jpg"],[UIImage imageNamed:@"ipadcover_1.jpg"],
			   [UIImage imageNamed:@"ipadcover_3.jpg"],[UIImage imageNamed:@"ipadcover_4.jpg"],
			   [UIImage imageNamed:@"ipadcover_5.jpg"],[UIImage imageNamed:@"ipadcover_6.jpg"],
			   [UIImage imageNamed:@"ipadcover_7.jpg"],[UIImage imageNamed:@"ipadcover_8.jpg"],
			   [UIImage imageNamed:@"ipadcover_9.jpg"],nil] retain];
	

	CGRect r = self.view.bounds;
	r.size.height = 1000;


	
	coverflow = [[TKCoverflowView alloc] initWithFrame:r];
	coverflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	coverflow.delegate = self;
	coverflow.dataSource = self;
	[self.view addSubview:coverflow];
	coverflow.coverSpacing = 100;
	coverflow.coverSize = CGSizeMake(300, 300);
	[coverflow setNumberOfCovers:100];
	

}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{

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
	
	coverflow.delegate = nil;
	coverflow.dataSource = nil;
	[coverflow release];
	
	[covers release];
	
    [super dealloc];
}

@end
