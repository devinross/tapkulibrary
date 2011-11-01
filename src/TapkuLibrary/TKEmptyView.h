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



@interface TKEmptyView : TKGradientView {	
	UILabel *_titleLabel, *_subtitleLabel;
	UIImageView *_imageView;
}

@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subtitleLabel;

- (id) initWithFrame:(CGRect)frame 
				mask:(UIImage*)image 
			   title:(NSString*)titleString 
			subtitle:(NSString*)subtitleString;


- (id) initWithFrame:(CGRect)frame 
	  emptyViewImage:(TKEmptyViewImage)image 
			   title:(NSString*)titleString 
			subtitle:(NSString*)subtitleString;


- (void) setImage:(UIImage*)image;
- (void) setEmptyImage:(TKEmptyViewImage)image;


@end

