//
//  HUDViewController.m
//  Created by Devin Ross on 7/4/09.
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

#import "HUDViewController.h"


@implementation HUDViewController




- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"HUD";
	
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
	[self.view addSubview:img];
	[img release];
	
	
	loading  = [[LoadingHUDView alloc] initWithTitle:@"Loading"];
	[self.view addSubview:loading];
	[loading startAnimating];
	loading.center = CGPointMake(self.view.bounds.size.width/2, 160);
	
	
	loading2  = [[LoadingHUDView alloc] initWithTitle:@"Lorem ipsum dolor sit amet" message:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam nec lectus quam, ac consectetur mauris. Donec est leo, hendrerit et tincidunt vel, pulvinar ut risus. Duis vulputate tincidunt erat. "];
	[self.view addSubview:loading2];
	[loading2 startAnimating];
	loading2.center = CGPointMake(self.view.bounds.size.width/2, 270);
}



- (void)dealloc {
	[loading release];
	[loading2 release];
    [super dealloc];
}


@end
