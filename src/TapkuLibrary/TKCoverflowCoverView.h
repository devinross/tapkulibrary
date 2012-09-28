//
//  TKCoverView.h
//  Created by Devin Ross on 1/3/10.
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


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
/** 
 `TKCoverflowCoverView` objects are the main views for displaying covers in `TKCoverflowView`. 
 */
@interface TKCoverflowCoverView : UIView 

- (id) initWithFrame:(CGRect)frame showReflection:(BOOL)reflection;

/** The coverflow image. */
@property (strong,nonatomic) UIImage *image;

/** The gradient layer the will create the reflection below the coverflow image */
@property (strong,nonatomic) CAGradientLayer *gradientLayer;

/** The height of the image. This property will help coverflow adjust views to display images with different heights. */
@property (assign,nonatomic) CGFloat baseline; // set this property for displaying images w/ different heights



@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImageView *reflected;


@end
