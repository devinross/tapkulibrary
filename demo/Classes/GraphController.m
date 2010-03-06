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



@implementation GraphPoint

- (id) initWithID:(int)pkv value:(NSNumber*)number{
	if(self = [super init]){
		pk = pkv;
		value = [number retain];
	}
	return self;
	
}

- (NSNumber*) yValue{
	return value;
}
- (NSString*) xLabel{
	return [NSString stringWithFormat:@"%d",pk];
}
- (NSString*) yLabel{
	return [NSString stringWithFormat:@"%d",[value intValue]];
}


@end

@implementation GraphController


- (void)viewDidLoad{
	[super viewDidLoad];
	
	graph.title.text = @"Graph View";
	[graph setPointDistance:15];
	
	
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGRect r = indicator.frame;
	r.origin = self.view.bounds.origin;
	r.origin.x = self.view.bounds.size.width / 2  - r.size.width / 2;
	r.origin.y = self.view.bounds.size.height / 2  - r.size.height / 2;
	indicator.frame = r;
	[self.view addSubview:indicator];
	[indicator startAnimating];
	
	data = [[NSMutableArray alloc] init];
	
	

	[NSThread detachNewThreadSelector:@selector(thread) toTarget:self withObject:nil];

	
	
}

- (void) thread{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	srand([[NSDate date] timeIntervalSince1970]);
	
	for(int i=0;i<60;i++){
		int no = rand() % 100 + i;
		
		GraphPoint *gp = [[GraphPoint alloc] initWithID:i value:[NSNumber numberWithFloat:no]];
		[data addObject:gp];
		[gp release];
	}
	
	[self performSelectorOnMainThread:@selector(threadComplete) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}
- (void) threadComplete{
	[indicator stopAnimating];
	
	[self.graph setGraphWithDataPoints:data];
	self.graph.goalValue = [NSNumber numberWithFloat:30.0];
	self.graph.goalShown = YES;
	[self.graph scrollToPoint:80 animated:YES];
	[self.graph showIndicatorForPoint:75];
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
	[data release];
	[indicator release];
    [super dealloc];
}


@end
