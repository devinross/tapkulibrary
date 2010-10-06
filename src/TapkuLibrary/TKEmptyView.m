//
//  TKEmptyView.m
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

#import "TKEmptyView.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"
#import "UIView+TKCategory.h"

@interface TKEmptyView()

- (UIImage*) maskedImageWithImage:(UIImage*)m;


@end



@implementation TKEmptyView
@synthesize imageView,titleLabel,subtitleLabel;

- (UIImage*) predefinedImage:(TKEmptyViewImage)img{
	
	NSString *str; 


	
	switch (img) {
		case TKEmptyViewImageChatBubble:
			str = @"chatbubble";
			break;
		case TKEmptyViewImageClock:
			str = @"clock";
			break;
		case TKEmptyViewImageCompass:
			str = @"compass";
			break;
		case TKEmptyViewImageEye:
			str = @"eye";
			break;
		case TKEmptyViewImageHeart:
			str = @"heart";
			break;
		case TKEmptyViewImageMovieClip:
			str = @"movieclip";
			break;
		case TKEmptyViewImageMusicNote:
			str = @"note";
			break;
		case TKEmptyViewImagePhotos:
			str = @"photos";
			break;
		case TKEmptyViewImagePictureFrame:
			str = @"pictureframe";
			break;
		case TKEmptyViewImageSearch:
			str = @"search";
			break;
		case TKEmptyViewImageSign:
			str = @"sign";
			break;
		case TKEmptyViewImageStar:
			str = @"star";
			break;
		case TKEmptyViewImageStopwatch:
			str = @"stopwatch";
			break;
		case TKEmptyViewImageKey:
			str = @"key";
			break;
		default:
			str = @"star";
			break;
	}
	
	NSString *scale = @"";
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
		NSInteger s = [[UIScreen mainScreen] scale];
		if(s > 1) scale = @"@2x";
	}

	NSString *path = [NSString stringWithFormat:@"TapkuLibrary.bundle/Images/empty/%@%@.png",str,scale];
	return [UIImage imageFromPath:TKBUNDLE(path)];
}


- (id) initWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	if(self = [super initWithFrame:frame]){
		
		
		self.backgroundColor = [UIColor whiteColor];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.font = [UIFont boldSystemFontOfSize:16];
		titleLabel.textColor = [UIColor darkGrayColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		
		titleLabel.text = titleString;
		
		subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		subtitleLabel.font = [UIFont systemFontOfSize:13];
		subtitleLabel.textColor = [UIColor grayColor];
		subtitleLabel.textAlignment = UITextAlignmentCenter;
		
		subtitleLabel.text = subtitleString;
		
		imageView = [[UIImageView alloc] initWithImage:[self maskedImageWithImage:image]];
		
		
		[self addSubview:imageView];
		[self addSubview:subtitleLabel];
		[self addSubview:titleLabel];
		

		
	}
	return self;
	
}
- (id) initWithFrame:(CGRect)frame emptyViewImage:(TKEmptyViewImage)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	return [self initWithFrame:frame mask:[self predefinedImage:image] title:titleString subtitle:subtitleString];
}
- (id) initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame emptyViewImage:TKEmptyViewImageStar title:@"" subtitle:@""];
}

- (void) layoutSubviews{
	[super layoutSubviews];
	
	CGRect rect = self.frame;

	CGRect titleRect = CGRectMake(0, 0, rect.size.width, 20);
	CGRect subtitleRect = CGRectMake(0, 0, rect.size.width, 16);
	
	imageView.center = CGPointMake((int)(rect.size.width/2),(int)(rect.size.height/2 - (rect.size.height/8)));
	imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
	
	
	titleRect.origin.y = (int)imageView.frame.size.height+imageView.frame.origin.y+ 5;
	subtitleRect.origin.y =  (int)titleRect.origin.y + titleRect.size.height + 5;
	
	subtitleLabel.frame = subtitleRect;
	titleLabel.frame = titleRect;
	
	
}


- (void) setImage:(UIImage*)image{
	imageView.image = [self maskedImageWithImage:image];
	[self layoutSubviews];
}

- (UIImage*) maskedImageWithImage:(UIImage*)m{
	
	if(m==nil) return nil;
	
	
	UIGraphicsBeginImageContext(CGSizeMake(m.size.width*m.scale, (m.size.height+2)*m.scale));
	
	CGFloat color[] = { 139/255.0, 152/255.0, 173/255.0, 1.0 };
	CGFloat colors[] = { 171/255.0, 180/255.0, 196/255.0, 1.00,   213/255.0, 217/255.0, 225/255.0, 1.00 };

	[m drawInRect:CGRectMake(0, 2*m.scale, m.size.width*m.scale, m.size.height*m.scale) asAlphaMaskForColor:color];
	[m drawInRect:CGRectMake(0, 0, m.size.width*m.scale, m.size.height*m.scale) asAlphaMaskForGradient:colors];
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImage *scaledImage = [UIImage imageWithCGImage:image.CGImage scale:m.scale orientation:UIImageOrientationUp];
	

	
	return scaledImage;
	
}


- (void) dealloc {
	
	[subtitleLabel release];
	[titleLabel release];
	[imageView release];
	
    [super dealloc];
}


@end
