//
//  DRPlace.h
//  iRPI
//
//  Created by Devin Ross on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TKPlace : NSObject <MKAnnotation> {
	NSString *title;
	CLLocationCoordinate2D coordinate;
	MKPinAnnotationColor color;
	
}
@property (copy) NSString *title;
@property (assign,nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) MKPinAnnotationColor color;
@end
