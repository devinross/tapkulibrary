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

#define TKBUNDLE(_URL) [TKGlobal fullBundlePath:_URL]

#define CAScale(_X,_Y,_Z) CATransform3DMakeScale(_X,_Y,_Z)
#define CARotate(_ANGLE,_X,_Y,_Z) CATransform3DMakeRotation(_ANGLE,_X,_Y,_Z)
#define CATranslate(_X,_Y,_Z) CATransform3DMakeTranslation(_X,_Y,_Z)
#define CAConcat(_ONE,_TWO) CATransform3DConcat(_ONE,_TWO)

#define CGScale(_X,_Y) CGAffineTransformMakeScale(_X,_Y)
#define CGRotate(_ANGLE) CGAffineTransformMakeRotation(_ANGLE)
#define CGTranslate(_X,_Y) CGAffineTransformMakeTranslation(_X,_Y)
#define CGConcat(_ONE,_TWO) CGAffineTransformConcat(_ONE,_TWO)

@interface TKGlobal : NSObject 

+ (NSString*) fullBundlePath:(NSString*)bundlePath;

@end
