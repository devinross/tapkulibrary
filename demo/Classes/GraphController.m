//
//  GraphController.m
//  Created by Devin Ross on 7/17/09.
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
#import "GraphController.h"


@implementation GraphController



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[graph moveToPoint:199 animated:YES];
	[graph showIndicatorForPoint:199];
}



#pragma mark  TKGraph Delegate Methods

- (NSString*) titleForGraph:(TKGraph*)graph{
	return @"Graph View";
}
- (int) numberofPointsOnGraph:(TKGraph*)graph{
	NSLog(@"Delegate");
	return 200;
}
- (NSNumber*) graph:(TKGraph*)graph yValueForPoint:(int)x{
	int z = (x * 20) % 3;
	return [NSNumber numberWithDouble:20.0*x - (z * (x-4) )];
}
- (NSString*) graph:(TKGraph*)graph xLabelForPoint:(int)x{

	return [NSString stringWithFormat:@"%d",x];
}
- (NSString*) graph:(TKGraph*)graph yLabelForValue:(float)value{

	int v = value;
	return [NSString stringWithFormat:@"%d",v];
}
- (NSNumber*) goalValueForGraph:(TKGraph*)graph{
	return [NSNumber numberWithDouble:270.0];
}


- (NSString*) graph:(TKGraph*)graph titleForIndicatorAtXPoint:(NSInteger)x{
	int z = (x * 20) % 3;
	z = 20.0*x - (z * (x-4));
	return [NSString stringWithFormat:@"%d",z];
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
