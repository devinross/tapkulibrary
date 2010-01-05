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
#import "UIImageAdditions.h"
#import "UIViewAdditions.h"


@implementation TKEmptyView
@synthesize title, subtitle, mask;



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
		title.text = titleString;
		subtitle.text = subtitleString;
		
	}
	return self;
	
}
- (id) initWithFrame:(CGRect)frame emptyViewImage:(TKEmptyViewImage)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	if(self = [self initWithFrame:frame]){
		
		self.mask = [self predefinedImage:image];
		title.text = titleString;
		subtitle.text = subtitleString;
		
	}
	return self;
}
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
		
		title = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		title.font = [UIFont boldSystemFontOfSize:18];
		title.adjustsFontSizeToFitWidth = YES;
		title.textColor = [UIColor grayColor];
		title.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
		title.textAlignment = UITextAlignmentCenter;
		[self addSubview:title];
		
		CGRect r= title.frame;
		r.size.height = 22;
		r.origin.y = (int)(self.frame.size.height/2 + self.frame.size.height/8);
		title.frame=r;
		
		
		
		subtitle = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		subtitle.font = [UIFont boldSystemFontOfSize:12];
		subtitle.adjustsFontSizeToFitWidth = YES;
		subtitle.textColor = [UIColor grayColor];
		subtitle.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
		subtitle.textAlignment = UITextAlignmentCenter;
		[self addSubview:subtitle];
		
		r= subtitle.frame;
		r.size.height = 20;
		r.origin.y = (int)(self.frame.size.height/2 + self.frame.size.height/8 + 30);
		subtitle.frame=r;
		
		

		
		
		
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
	
	
	
	CGFloat color[] = { 139/255.0, 152/255.0, 173/255.0, 1.0 };
	float y = self.frame.size.height/2 - mask.size.height/2 - 40;
	float x = self.bounds.size.width/2 - mask.size.width/2;
	
	//NSLog(@"View size: %f %f %f",self.frame.size.height,mask.size.height,y);
	

	
	[mask drawInRect:CGRectMake((int)x, (int)y, mask.size.width, mask.size.height) asAlphaMaskForColor:color];
	
	CGFloat colors[] = {
		171/255.0, 180/255.0, 196/255.0, 1.00,
		213/255.0, 217/255.0, 225/255.0, 1.00
	};
	[mask drawInRect:CGRectMake((int)x, (int)y - 2, mask.size.width, mask.size.height) asAlphaMaskForGradient:colors];
	
	
	
	CGRect r = title.frame;
	r.origin.y = y + mask.size.height + 30;
	title.frame = r;
	
	r = subtitle.frame;
	r.origin.y = y + mask.size.height + 60;
	subtitle.frame = r;
}
- (void) setMask:(UIImage*)m{
	[mask release];
	mask = [m retain];
	[self setNeedsDisplay];
}

- (void) dealloc {
	
	[title release];
	[subtitle release];
	[mask release];
	
    [super dealloc];
}


@end
