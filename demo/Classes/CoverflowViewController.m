//
//  CoverflowViewController.m
//  Created by Devin Ross on 1/3/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
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
#import "CoverflowViewController.h"

@implementation CoverflowViewController

- (NSUInteger) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	return YES;
}


#pragma mark - View Lifecycle
- (void) loadView{
	
	CGRect r = [UIScreen mainScreen].bounds;
	r = CGRectApplyAffineTransform(r, CGAffineTransformMakeRotation(90 * M_PI / 180.));
	r.origin = CGPointZero;
	
	self.view = [[UIView alloc] initWithFrame:r];
	
	
	
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	r = self.view.bounds;
	r.size.height = 1000;
	
	self.coverflow = [[TKCoverflowView alloc] initWithFrame:self.view.bounds];
	self.coverflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.coverflow.coverflowDelegate = self;
	self.coverflow.dataSource = self;
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
		self.coverflow.coverSpacing = 100;
		self.coverflow.coverSize = CGSizeMake(300, 300);
	}
	
	[self.view addSubview:self.coverflow];
	
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btn.frame = CGRectMake(0,0,100,20);
		[btn setTitle:@"# Covers" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(changeNumberOfCovers) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
	}else{
		
		UIBarButtonItem *nocoversitem = [[UIBarButtonItem alloc] initWithTitle:@"# Covers" 
																  style:UIBarButtonItemStyleBordered 
																 target:self action:@selector(changeNumberOfCovers)];
		
		UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		self.toolbarItems = [NSArray arrayWithObjects:flex,nocoversitem,nil];
	}
													   
	

	CGSize s = self.view.bounds.size;
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	infoButton.frame = CGRectMake(s.width-50, 5, 50, 30);
	[self.view addSubview:infoButton];

	
}
- (void) viewDidLoad {
    [super viewDidLoad];
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		self.covers = [[NSMutableArray alloc] initWithObjects:
				  [UIImage imageNamed:@"cover_2.jpg"],[UIImage imageNamed:@"cover_1.jpg"],
				  [UIImage imageNamed:@"cover_3.jpg"],[UIImage imageNamed:@"cover_4.jpg"],
				  [UIImage imageNamed:@"cover_5.jpg"],[UIImage imageNamed:@"cover_6.jpg"],
				  [UIImage imageNamed:@"cover_7.jpg"],[UIImage imageNamed:@"cover_8.jpg"],
				  [UIImage imageNamed:@"cover_9.jpeg"],nil];
	}else{
		self.covers = [[NSMutableArray alloc] initWithObjects:
				  [UIImage imageNamed:@"ipadcover_2.jpg"],[UIImage imageNamed:@"ipadcover_1.jpg"],
				  [UIImage imageNamed:@"ipadcover_3.jpg"],[UIImage imageNamed:@"ipadcover_4.jpg"],
				  [UIImage imageNamed:@"ipadcover_5.jpg"],[UIImage imageNamed:@"ipadcover_6.jpg"],
				  [UIImage imageNamed:@"ipadcover_7.jpg"],[UIImage imageNamed:@"ipadcover_8.jpg"],
				  [UIImage imageNamed:@"ipadcover_9.jpg"],nil];
	}
	

	

	[self.coverflow setNumberOfCovers:580];
	
	

	
	
	
}
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	}
	
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.coverflow bringCoverAtIndexToFront:[self.covers count]*2 animated:NO];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}
}

- (void) info{
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		[self dismissModalViewControllerAnimated:YES];
	else{
		
		CGRect rect = self.view.bounds;
		if(!collapsed) rect = CGRectInset(rect, 100, 100);
		self.coverflow.frame = rect;
		collapsed = !collapsed;

	}
}
- (void) changeNumberOfCovers{
	
	NSInteger index = self.coverflow.currentIndex;
	NSInteger no = arc4random() % 200;
	NSInteger newIndex = MAX(0,MIN(index,no-1));
	
	//NSLog(@"Covers Count: %d index: %d",no,newIndex);

	[self.coverflow setNumberOfCovers:no];
	self.coverflow.currentIndex = newIndex;
	
}


- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{
	NSLog(@"Front %d",index);
}
- (TKCoverflowCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index{
	
	TKCoverflowCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil){
		BOOL phone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
		CGRect rect = phone ? CGRectMake(0, 0, 224, 300) : CGRectMake(0, 0, 300, 600);
		cover = [[TKCoverflowCoverView alloc] initWithFrame:rect]; // 224
		cover.baseline = 224;
	}
	cover.image = [self.covers objectAtIndex:index%[self.covers count]];

	return cover;
}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasTappedInFront:(int)index tapCount:(NSInteger)tapCount{
	
	TKLog(@"Index: %d",index);
	
	if(tapCount<2) return;

	TKCoverflowCoverView *cover = [coverflowView coverAtIndex:index];
	if(cover == nil) return;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cover cache:YES];
	[UIView commitAnimations];
	
}


@end