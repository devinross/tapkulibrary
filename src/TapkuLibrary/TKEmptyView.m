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
@synthesize title, subtitle, mask;



- (UIImage*) predefinedImage:(TKEmptyViewImage)img{
	
	
	NSString *str;


	
	switch (img) {
		case TKEmptyViewImageChatBubble:
			str = @"TapkuLibrary.bundle/Images/empty/chatbubble";
			break;
		case TKEmptyViewImageClock:
			str = @"TapkuLibrary.bundle/Images/empty/clock";
			break;
		case TKEmptyViewImageCompass:
			str = @"TapkuLibrary.bundle/Images/empty/compass";
			break;
		case TKEmptyViewImageEye:
			str = @"TapkuLibrary.bundle/Images/empty/eye";
			break;
		case TKEmptyViewImageHeart:
			str = @"TapkuLibrary.bundle/Images/empty/heart";
			break;
		case TKEmptyViewImageMovieClip:
			str = @"TapkuLibrary.bundle/Images/empty/movieclip";
			break;
		case TKEmptyViewImageMusicNote:
			str = @"TapkuLibrary.bundle/Images/empty/note";
			break;
		case TKEmptyViewImagePhotos:
			str = @"TapkuLibrary.bundle/Images/empty/photos";
			break;
		case TKEmptyViewImagePictureFrame:
			str = @"TapkuLibrary.bundle/Images/empty/pictureframe";
			break;
		case TKEmptyViewImageSearch:
			str = @"TapkuLibrary.bundle/Images/empty/search";
			break;
		case TKEmptyViewImageSign:
			str = @"TapkuLibrary.bundle/Images/empty/sign";
			break;
		case TKEmptyViewImageStar:
			str = @"TapkuLibrary.bundle/Images/empty/star";
			break;
		case TKEmptyViewImageStopwatch:
			str = @"TapkuLibrary.bundle/Images/empty/stopwatch";
			break;
		case TKEmptyViewImageKey:
			str = @"TapkuLibrary.bundle/Images/empty/key";
			break;
		default:
			str = @"TapkuLibrary.bundle/Images/empty/star";
			break;
	}

	
	return [UIImage imageNamedTK:str];
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
		
		self.backgroundColor = [UIColor whiteColor];
		
		title = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		title.font = [UIFont boldSystemFontOfSize:18];
		title.adjustsFontSizeToFitWidth = YES;
		title.textColor = [UIColor grayColor];
		title.backgroundColor = [UIColor whiteColor];
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
		subtitle.backgroundColor = [UIColor whiteColor];
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
