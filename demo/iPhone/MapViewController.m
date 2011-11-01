//
//  MapViewController.m
//  Created by Devin Ross on 7/11/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
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

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@implementation MapViewController


- (void) viewDidLoad {
    [super viewDidLoad];
	mapView = [[TKMapView alloc] initWithFrame:self.view.bounds];
	mapView.delegate = self;
	[self.view addSubview:mapView];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Add Pin" style:UIBarButtonItemStyleBordered target:self action:@selector(addPinMode:)] autorelease];


}


- (void) addPinMode:(id)sender{
	
	
	
	
	if(mapView.pinMode){
		mapView.mapView.mapType = MKMapTypeStandard;
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered;
		
	}else{
		mapView.mapView.mapType = MKMapTypeHybrid;
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
	}
		
	[mapView setPinMode:!mapView.pinMode];
}


- (void) didPlacePinAtCoordinate:(CLLocationCoordinate2D)location{
	TKMapPlace *place = [[TKMapPlace alloc] init];
	place.title = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
	NSLog(@"(%f,%f)",location.latitude,location.longitude);
	place.coordinate = location;
	[mapView.mapView addAnnotation:place];
	[place release];
}



- (void)dealloc {
	[mapView release];
    [super dealloc];
}


@end
