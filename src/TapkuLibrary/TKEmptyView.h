//
//  TKEmptyView.h
//  Created by Devin Ross on 7/24/09.
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
#import "TKGradientView.h"


/**
 The glyph that appears with the empty view.
 */
typedef enum {
	TKEmptyViewImageChatBubble,
	TKEmptyViewImageClock,
	TKEmptyViewImageCompass,
	TKEmptyViewImageEye,
	TKEmptyViewImageHeart,
	TKEmptyViewImageMovieClip,
	TKEmptyViewImageMusicNote,
	TKEmptyViewImagePhotos,
	TKEmptyViewImagePictureFrame,
	TKEmptyViewImageSearch,
	TKEmptyViewImageSign,
	TKEmptyViewImageStar,
	TKEmptyViewImageStopwatch,
	TKEmptyViewImageKey,
	TKEmptyViewImageMale,
	TKEmptyViewImageTelevision
} TKEmptyViewImage;


/** A simple view for showing no content available. */
@interface TKEmptyView : TKGradientView 


///-------------------------
/// @name Initializing a TKEmptyView Object
///-------------------------

/** Initializes an empty view with an image that will be stylized.
 
 @param frame The frame of the `UIView`.
 @param image The image that will appear central in the view.
 @param titleString The title of the empty view.
 @param subtitleString The subtitle of the empty view.
 @return An initialized `TKEmptyView` object or nil if the object couldn’t be created.
 */
- (id) initWithFrame:(CGRect)frame 
				mask:(UIImage*)image 
			   title:(NSString*)titleString 
			subtitle:(NSString*)subtitleString;

/** Initializes an empty view with the given `TKEmptyViewImage`.
 
 @warning Make sure to include the bundle included with the framework in your own project.
 
 @param frame The frame of the `UIView`.
 @param image The bundled image that will be the central image.
 @param titleString The title of the empty view.
 @param subtitleString The subtitle of the empty view.
 @return An initialized `TKEmptyView` object or nil if the object couldn’t be created.
 */
- (id) initWithFrame:(CGRect)frame 
	  emptyViewImage:(TKEmptyViewImage)image 
			   title:(NSString*)titleString 
			subtitle:(NSString*)subtitleString;

///-------------------------
/// @name Properties
///-------------------------

/** The image view for the empty content. */
@property (strong,nonatomic) UIImageView *imageView;

/** The title message. */
@property (strong,nonatomic) UILabel *titleLabel;

/** The secondary message. */
@property (strong,nonatomic) UILabel *subtitleLabel;



///-------------------------
/// @name Set the Empty View Image
///-------------------------

/** 
 The image that be used to mask the glyph that will be displayed  above the title message. This image needs to be a transparent png image. 
 @param image Set the image as the empty image.
 */
- (void) setImage:(UIImage*)image;

/** Set the empty view to a bundled image. 
 @param image Set the image to a preset image.
*/
- (void) setEmptyImage:(TKEmptyViewImage)image;


@end

