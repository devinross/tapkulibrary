//
//  UIImageAdditions.h
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


@import UIKit;

/** Additional functionality for `UIImage`.  */
@interface UIImage (TKCategory)

+ (UIImage*) imageNamedTK:(NSString*)path;

- (UIImage *) imageCroppedToRect:(CGRect)rect;

- (UIImage *) squareImage;


/** Creates and returns an image with the applyed lighting effect.
 @return An image with the applied lighting effect.
 */
- (UIImage *) imageByApplyingLightEffect;

/** Creates and returns an image with the applyed lighting effect.
 @return An image with the applied lighting effect.
 */
- (UIImage *) imageByApplyingExtraLightEffect;

/** Creates and returns an image with the applyed tint color.
 @param blurRadius the blur radius applied to the image
 @param saturation The saturation change applied to the original image. 1.0 is the default.
 @return An image with the applied tint effect.
 */
- (UIImage*) imageByApplyingDarkEffectWithBlurRadius:(CGFloat)blurRadius saturationFactor:(CGFloat)saturation;


/** Creates and returns an image with the a dark tint color applied.
 @return An image with the applied dark tint effect.
 */
- (UIImage *) imageByApplyingDarkEffect;


/** Creates and returns an image with the applyed tint color.
 @param tintColor The color that will applied to the image. For subtle changes, make sure the alpha of the color is less than 1.
 @return An image with the applied tint effect.
 */
- (UIImage *) imageByApplyingTintEffectWithColor:(UIColor *)tintColor;


/** Creates and returns an image with the applyed blur, tint color, saturation change, and masked image.
 @param blurRadius the blur radius applied to the image
 @param tintColor The color that will applied to the image. For subtle changes, make sure the alpha of the color is less than 1.
 @param saturationDeltaFactor The saturation change applied to the original image. 1.0 is the default.
 @param maskImage The mask image applied to the original image.
 @return An image with the applied blur.
 */
- (UIImage *) imageByApplyingBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end

