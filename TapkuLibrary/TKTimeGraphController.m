//
//  TKTimeGraphController.m
//  Created by Devin Ross on 7/24/09.
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

#import "TKTimeGraphController.h"


@implementation TKTimeGraphController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*//*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	timeGraph = [[TKTimeGraph alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
	timeGraph.delegate = self;
	timeGraph.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:timeGraph];
	
	close = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	close.frame = CGRectMake(0, 0, 50, 50);
	[close setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[close setImage:[UIImage imageNamed:@"close_touch.png"] forState:UIControlStateHighlighted];
	[close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:close];
 
}


 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 statusColor = [UIApplication sharedApplication].statusBarStyle;
	 [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleBlackOpaque;
 }
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
 - (void)viewWillDisappear:(BOOL)animated {
	 [super viewWillDisappear:animated];
	 [UIApplication sharedApplication].statusBarStyle =  statusColor;
 }
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


- (void) close{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark  TKTimeGraph Delegate Methods

- (NSString*) titleForTimeGraph:(TKTimeGraph*)graph{
	return nil;
}
- (int) numberofPointsOnTimeGraph:(TKTimeGraph*)graph{
	return 0;
}
- (NSNumber*) timeGraph:(TKTimeGraph*)graph yValueForPoint:(int)x{
	return [NSNumber numberWithInt:0];
}
- (NSString*) timeGraph:(TKTimeGraph*)graph xLabelForPoint:(int)x{
	return nil;
}
- (NSString*) timeGraph:(TKTimeGraph*)graph yLabelForValue:(float)value{
	return nil;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
