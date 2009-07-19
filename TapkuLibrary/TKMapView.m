//
//  TKMapView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TKMapView.h"


@implementation TKMapView
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
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (void)dealloc {
    [super dealloc];
}


- (void) didTouchAtPoint:(CGPoint)point{

	TKPlace *place = [[TKPlace alloc] init];
	
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

	place.coordinate = corner;
	place.title = @"Place";
	[mapView addAnnotation:place];
	[place release];
	
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
