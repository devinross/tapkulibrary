//
//  TKMapView.h
//  TapkuLibrary
//
//  Created by Devin Ross on 7/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TKPlace.h"


@class TKOverlayView;

@protocol TKOverlayViewDelegate;

@interface TKMapView : UIView <TKOverlayViewDelegate> {
	MKMapView *mapView;
	TKOverlayView *overlay;
	BOOL pinMode;
}

- (void) setPinMode:(BOOL)pinMode;

@end

@protocol TKOverlayViewDelegate;
@interface TKOverlayView : UIView {
	id <TKOverlayViewDelegate> delegate;
}

@property (assign,nonatomic) id <TKOverlayViewDelegate> delegate;

@end


@protocol TKOverlayViewDelegate<NSObject>
@optional
- (void) didTouchAtPoint:(CGPoint)point;
@end
