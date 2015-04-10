//
//  TKGradientView.h
//  Created by Devin Ross on 9/21/11.
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


@import UIKit;
@import QuartzCore;


/** This class implements `UIView` backed by a `CAGradientLayer`. */
@interface TKGradientView : UIView 

///----------------------------
/// @name Gradient Style Properties
///----------------------------

/** An array of `UIColor` objects defining the color of each gradient stop. */
@property (nonatomic,strong) NSArray *colors;

/** An optional array of NSNumber objects defining the location of each gradient stop. */
@property (nonatomic,strong) NSArray *locations;


/**
 The start point corresponds to the first stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the layer’s bounds rectangle when drawn.
 Default value is (0.5,0.0).
*/
@property (nonatomic,assign) CGPoint startPoint;


/** The end point of the gradient when drawn in the layer’s coordinate space. */
@property (nonatomic,assign) CGPoint endPoint;

/** Style of gradient drawn by the layer. */
@property (nonatomic,copy) NSString *type;

@end