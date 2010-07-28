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


@implementation TKEmptyView
@synthesize mask;

- (void) setTitle:(NSString *)s{
	titleLayer.string = s;
}
- (void) setSubtitle:(NSString *)s{
	subtitleLayer.string = s;
}
- (NSString*) title{
	return titleLayer.string;
}
- (NSString*) subtitle{
	return subtitleLayer.string;
}




- (UIImage*) predefinedImage:(TKEmptyViewImage)img{
	


	
	switch (img) {
		case TKEmptyViewImageChatBubble:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/chatbubble.png")];
			break;
		case TKEmptyViewImageClock:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/clock.png")];
			break;
		case TKEmptyViewImageCompass:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/compass.png")];
			break;
		case TKEmptyViewImageEye:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/eye.png")];
			break;
		case TKEmptyViewImageHeart:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/heart.png")];
			break;
		case TKEmptyViewImageMovieClip:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/movieclip.png")];
			break;
		case TKEmptyViewImageMusicNote:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/note.png")];
			break;
		case TKEmptyViewImagePhotos:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/photos.png")];
			break;
		case TKEmptyViewImagePictureFrame:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/pictureframe.png")];
			break;
		case TKEmptyViewImageSearch:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/search.png")];
			break;
		case TKEmptyViewImageSign:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/sign.png")];
			break;
		case TKEmptyViewImageStar:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/star.png")];
			break;
		case TKEmptyViewImageStopwatch:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/stopwatch.png")];
			break;
		case TKEmptyViewImageKey:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/key.png")];
			break;
		default:
			return [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/empty/star.png")];
			break;
	}

	return nil;
}



- (id) initWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	if(self = [self initWithFrame:frame]){
		
		self.mask = image;
		titleLayer.string = titleString;
		subtitleLayer.string = subtitleString;
		
	}
	return self;
	
}
- (id) initWithFrame:(CGRect)frame emptyViewImage:(TKEmptyViewImage)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	if(self = [self initWithFrame:frame]){
		
		self.mask = [self predefinedImage:image];
		titleLayer.string = titleString;
		subtitleLayer.string = subtitleString;
		
	}
	return self;
}
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor whiteColor];
		
		titleLayer = [[CATextLayer layer] retain];
		titleLayer.fontSize = 18;
		titleLayer.alignmentMode = kCAAlignmentCenter;
		titleLayer.foregroundColor = [UIColor grayColor].CGColor;
		[self.layer addSublayer:titleLayer];
		
		subtitleLayer = [[CATextLayer layer] retain];
		subtitleLayer.fontSize = 13;
		subtitleLayer.alignmentMode = kCAAlignmentCenter;

		subtitleLayer.foregroundColor = [UIColor grayColor].CGColor;
		[self.layer addSublayer:subtitleLayer];
		

		maskedLayer = [[CALayer layer] retain];
		[self.layer addSublayer:maskedLayer];
		
		
		
    }
    return self;
}

- (void) layoutSubviews{
	[super layoutSubviews];
	
	maskedLayer.transform = CATransform3DIdentity;
	maskedLayer.frame = CGRectMake(0, 0, mask.size.width, mask.size.height);
	
	CGFloat p1 = mask.size.width / self.frame.size.width;
	CGFloat p2 = mask.size.height / self.frame.size.height;
	
	CGFloat up = 20;
	
	if(p1>p2 && p1 > 0.80){
		maskedLayer.transform = CATransform3DMakeScale(p1-.3, p1-.3, 1);
		up = MAX(20,(-mask.size.height + self.frame.size.height)*0.5);
	}else if(p2 > 0.80){
		maskedLayer.transform = CATransform3DMakeScale(p2-.3,p2-.3, 1);
		up = MAX(20,(-mask.size.height + self.frame.size.height)*0.5);

	}
	
	maskedLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - up);
	
	
	

	
	CGRect r = CGRectMake(10, (int)(maskedLayer.frame.size.height + maskedLayer.frame.origin.y+10), self.bounds.size.width-20 , 20) ;
	titleLayer.frame = r;
	r.origin.y += 20;
	subtitleLayer.frame = r;
}



- (void) setMask:(UIImage*)m{
	//[mask release];
	//mask = [m retain];
	//[self setNeedsDisplay];
	
	UIGraphicsBeginImageContext(CGSizeMake(m.size.width, m.size.height+2));
	
	CGFloat color[] = { 139/255.0, 152/255.0, 173/255.0, 1.0 };

	[m drawInRect:CGRectMake(0, 2, m.size.width, m.size.height) asAlphaMaskForColor:color];
	
	CGFloat colors[] = {
		171/255.0, 180/255.0, 196/255.0, 1.00,
		213/255.0, 217/255.0, 225/255.0, 1.00
	};
	[m drawInRect:CGRectMake(0, 0, m.size.width, m.size.height) asAlphaMaskForGradient:colors];
	
	

	
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	mask = [image retain];
	maskedLayer.contents = (id)mask.CGImage;
	
	
	
}

- (void) dealloc {
	
	[subtitleLayer release];
	[titleLayer release];
	[mask release];
	
    [super dealloc];
}


@end
