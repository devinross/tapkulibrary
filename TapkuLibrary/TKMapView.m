//
//  TKMapView.m
//  Created by Devin Ross on 7/11/09.
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

#import "TKMapView.h"


@implementation TKMapView
@synthesize mapView,delegate,pinMode;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		mapView = [[MKMapView alloc] initWithFrame:frame];
		[self addSubview:mapView];
		overlay = [[TKOverlayView alloc] initWithFrame:frame];
		overlay.delegate = self;
		overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
		pinMode = NO;
    }
    return self;
}

- (id)init{
	NSLog(@"INIT");
	CGRect frame = CGRectMake(0, 0, 50, 50);
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		mapView = [[MKMapView alloc] initWithFrame:frame];
		[self addSubview:mapView];
		overlay = [[TKOverlayView alloc] initWithFrame:frame];
		overlay.delegate = self;
		overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
		pinMode = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (void)dealloc {
    [super dealloc];
}


- (void) didTouchAtPoint:(CGPoint)point{

	//TKPlace *place = [[TKPlace alloc] init];
	
	CGRect r = mapView.bounds;
	
	float longitudePercent = point.x / r.size.width;
	float latitudePercent = point.y / r.size.height;
	
	NSLog(@"-(%f,%f)",longitudePercent,latitudePercent);
	
	

	CLLocationCoordinate2D coord = mapView.centerCoordinate;
	MKCoordinateSpan span = mapView.region.span;
	
	float lat = coord.latitude + (span.latitudeDelta/2);
	float lon = coord.longitude - (span.longitudeDelta/2);
	
	
	CLLocationCoordinate2D corner;
	//corner.latitude = lat;
	//corner.longitude = lon;
	corner.latitude = lat - span.latitudeDelta * latitudePercent; // up and down
	corner.longitude = lon + span.longitudeDelta * longitudePercent; // left right
	
	NSLog(@"Center (%f, %f)",coord.longitude,coord.latitude);
	NSLog(@"%f %f",corner.longitude,corner.latitude);

	//place.coordinate = corner;
	//place.title = @"Place";
	//[mapView addAnnotation:place];
	//[place release];
	
	
	[delegate didPlacePinAtCoordinate:corner];
}


- (void) setPinMode:(BOOL)pinIsMode{
	pinMode = pinIsMode;
	if(pinMode){
		[self addSubview:overlay];
	}else{
		[overlay removeFromSuperview];
	}
}

@end



@implementation TKOverlayView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (void)dealloc {
    [super dealloc];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"Touch");
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"Moved");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	//NSLog(@"%f %f",point.x,point.y);
	[delegate didTouchAtPoint:point];
}

@end
