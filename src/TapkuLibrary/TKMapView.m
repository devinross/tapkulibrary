//
//  TKMapView.m
//  Created by Devin Ross on 7/11/09.
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

#import "TKMapView.h"


// OVERLAY CLASS DEFINITION & IMPLEMENTATION
@interface TKOverlayView : UIView {
	id target;
	SEL action;
	CGPoint point;

}
- (id) initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
@property (readonly,nonatomic) CGPoint point;
@end
@implementation TKOverlayView
@synthesize point;

- (id) initWithFrame:(CGRect)frame target:(id)t action:(SEL)a{
	
	if(!(self = [super initWithFrame:frame])) return nil;

	target = t;
	action = a;
    
    return self;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	point = [touch locationInView:self];
	[target performSelector:action];
}
- (void)dealloc {
	target = nil;
	action = nil;
}

@end




// TKMAPVIEW IMPLEMENTATION
@implementation TKMapView

@synthesize mapView,delegate,pinMode;

- (id)init{
	return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}
- (id)initWithFrame:(CGRect)frame {
	
	if(!(self = [super initWithFrame:frame])) return nil;
	
	CGRect b = frame;
	b.origin = CGPointZero;
	
	mapView = [[MKMapView alloc] initWithFrame:b];
	[self addSubview:mapView];
	
	overlay = [[TKOverlayView alloc] initWithFrame:b target:self action:@selector(didTouch)];
	overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
	pinMode = NO;

    return self;
}

- (void) didTouch{
	
	CGRect r = mapView.bounds;
	
	float longitudePercent = overlay.point.x / r.size.width;
	float latitudePercent = overlay.point.y / r.size.height;

	CLLocationCoordinate2D coord = mapView.centerCoordinate;
	MKCoordinateSpan span = mapView.region.span;
	
	float lat = coord.latitude + (span.latitudeDelta/2);
	float lon = coord.longitude - (span.longitudeDelta/2);
	
	
	CLLocationCoordinate2D corner;
	corner.latitude = lat - span.latitudeDelta * latitudePercent; // up and down
	corner.longitude = lon + span.longitudeDelta * longitudePercent; // left right
	
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