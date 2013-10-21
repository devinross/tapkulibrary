//
//  TKGlobal.h
//  Created by Devin Ross on 7/25/09.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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

@import Foundation;
@import UIKit;
@import QuartzCore;


#define TKLog(s, ...) NSLog( @"[%@ %@] %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd),[NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:[@"TapkuLibrary.bundle/Images" stringByAppendingPathComponent:_URL]]


FOUNDATION_STATIC_INLINE CATransform3D CAScale(CGFloat x,CGFloat y,CGFloat z);
FOUNDATION_STATIC_INLINE CATransform3D CAScale(CGFloat x,CGFloat y,CGFloat z){
	return CATransform3DMakeScale(x,y,z);
}

FOUNDATION_STATIC_INLINE CATransform3D CARotate(CGFloat angle,CGFloat x,CGFloat y,CGFloat z);
FOUNDATION_STATIC_INLINE CATransform3D CARotate(CGFloat angle,CGFloat x,CGFloat y,CGFloat z){
	return CATransform3DMakeRotation(angle,x,y,z);
}

FOUNDATION_STATIC_INLINE CATransform3D CATranslate(CGFloat x,CGFloat y,CGFloat z);
FOUNDATION_STATIC_INLINE CATransform3D CATranslate(CGFloat x,CGFloat y,CGFloat z){
	return CATransform3DMakeTranslation(x,y,z);
}

FOUNDATION_STATIC_INLINE CATransform3D CAConcat(CATransform3D t1,CATransform3D t2);
FOUNDATION_STATIC_INLINE CATransform3D CAConcat(CATransform3D t1,CATransform3D t2){
	return CATransform3DConcat(t1,t2);
}

FOUNDATION_STATIC_INLINE CGAffineTransform CGScale(CGFloat x,CGFloat y);
FOUNDATION_STATIC_INLINE CGAffineTransform CGScale(CGFloat x,CGFloat y){
	return CGAffineTransformMakeScale(x,y);
}

FOUNDATION_STATIC_INLINE CGAffineTransform CGRotate(CGFloat angle);
FOUNDATION_STATIC_INLINE CGAffineTransform CGRotate(CGFloat angle){
	return CGAffineTransformMakeRotation(angle);
}

FOUNDATION_STATIC_INLINE CGAffineTransform CGTranslate(CGFloat x, CGFloat y);
FOUNDATION_STATIC_INLINE CGAffineTransform CGTranslate(CGFloat x, CGFloat y){
	return CGAffineTransformMakeTranslation(x, y);
}

FOUNDATION_STATIC_INLINE CGAffineTransform CGConcat(CGAffineTransform first, CGAffineTransform second);
FOUNDATION_STATIC_INLINE CGAffineTransform CGConcat(CGAffineTransform first, CGAffineTransform second){
	return CGAffineTransformConcat(first, second);
}

FOUNDATION_STATIC_INLINE CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size);
FOUNDATION_STATIC_INLINE CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size){
	CGRect r; r.origin.x = x; r.origin.y = y; r.size = size; return r;
}

FOUNDATION_STATIC_INLINE CGRect CGRectMakeWithPoint(CGPoint origin, CGFloat width, CGFloat height);
FOUNDATION_STATIC_INLINE CGRect CGRectMakeWithPoint(CGPoint origin, CGFloat width, CGFloat height){
	CGRect r; r.origin = origin; r.size.width = width; r.size.height = height; return r;
}

FOUNDATION_STATIC_INLINE CGRect CGRectCompose(CGPoint origin, CGSize size);
FOUNDATION_STATIC_INLINE CGRect CGRectCompose(CGPoint origin, CGSize size){
	CGRect r; r.origin = origin; r.size = size; return r;
}



FOUNDATION_STATIC_INLINE CGPoint CGPointGetMidpoint(CGPoint p1,CGPoint p2);
FOUNDATION_STATIC_INLINE CGPoint CGPointGetMidpoint(CGPoint p1,CGPoint p2){
	return CGPointMake((p1.x+p2.x)/2.0f,(p1.y+p2.y)/2.0f);
}

FOUNDATION_STATIC_INLINE CGFloat CGPointGetDistance(CGPoint p1,CGPoint p2);
FOUNDATION_STATIC_INLINE CGFloat CGPointGetDistance(CGPoint p1,CGPoint p2){
	return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}


FOUNDATION_STATIC_INLINE CGPoint CGRectGetMidpoint(CGRect rect);
FOUNDATION_STATIC_INLINE CGPoint CGRectGetMidpoint(CGRect rect){
	return CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f);
}

FOUNDATION_STATIC_INLINE CGPoint CGRectGetCenter(CGRect rect);
FOUNDATION_STATIC_INLINE CGPoint CGRectGetCenter(CGRect rect){
	return CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
}




@interface TKGlobal : NSObject 

+ (NSString*) fullBundlePath:(NSString*)bundlePath;

@end
