//
//  TKGlobal.h
//  Created by Devin Ross on 7/25/09.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define TKLog(s, ...) NSLog( @"[%@ %@] %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd),[NSString stringWithFormat:(s), ##__VA_ARGS__] )


#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:_URL]

#define CAScale(_X,_Y,_Z) CATransform3DMakeScale(_X,_Y,_Z)
#define CARotate(_ANGLE,_X,_Y,_Z) CATransform3DMakeRotation(_ANGLE,_X,_Y,_Z)
#define CATranslate(_X,_Y,_Z) CATransform3DMakeTranslation(_X,_Y,_Z)
#define CAConcat(_ONE,_TWO) CATransform3DConcat(_ONE,_TWO)

#define CGScale(_X,_Y) CGAffineTransformMakeScale(_X,_Y)
#define CGRotate(_ANGLE) CGAffineTransformMakeRotation(_ANGLE)
#define CGTranslate(_X,_Y) CGAffineTransformMakeTranslation(_X,_Y)
#define CGConcat(_ONE,_TWO) CGAffineTransformConcat(_ONE,_TWO)





inline CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size);
inline CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size){
	CGRect r; r.origin.x = x; r.origin.y = y; r.size = size; return r;
}

inline CGRect CGRectMakeWithPoint(CGPoint origin, CGFloat width, CGFloat height);
inline CGRect CGRectMakeWithPoint(CGPoint origin, CGFloat width, CGFloat height){
	CGRect r; r.origin = origin; r.size.width = width; r.size.height = height; return r;
}

inline CGRect CGRectCompose(CGPoint origin, CGSize size);
inline CGRect CGRectCompose(CGPoint origin, CGSize size){
	CGRect r; r.origin = origin; r.size = size; return r;
}



@interface TKGlobal : NSObject 

+ (NSString*) fullBundlePath:(NSString*)bundlePath;

@end
