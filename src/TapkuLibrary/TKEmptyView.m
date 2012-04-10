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


@implementation UIView (TKEmptyViewCategory)

+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
	
	NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors) [ar addObject:(id)c.CGColor];
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ar, NULL);
	
	
	CGContextClipToRect(context, rect);
	
	CGPoint start = CGPointMake(0.0, 0.0);
	CGPoint end = CGPointMake(0.0, rect.size.height);
	
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
}

@end




@implementation UIImage (TKEmptyViewCategory)

- (void) drawMaskedGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	
	[UIView drawGradientInRect:rect withColors:colors];
	
	CGContextRestoreGState(context);
}

@end





@interface TKEmptyView()

- (UIImage*) maskedImageWithImage:(UIImage*)m;
- (UIImage*) predefinedImage:(TKEmptyViewImage)img;

@end


#pragma mark -
@implementation TKEmptyView
@synthesize imageView=_imageView,titleLabel=_titleLabel,subtitleLabel=_subtitleLabel;


- (id) initWithFrame:(CGRect)frame mask:(UIImage*)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
    if(!(self=[super initWithFrame:frame])) return nil;
    self.backgroundColor = [UIColor whiteColor];
	
	UIColor *top = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1];
	UIColor *bot = [UIColor colorWithRed:225/255.0 green:229/255.0 blue:235/255.0 alpha:1];
	
	self.colors = [NSArray arrayWithObjects:top,bot,nil];
	self.startPoint = CGPointZero;
	self.endPoint = CGPointMake(0, 1);
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor colorWithRed:128/255. green:136/255. blue:149/255. alpha:1];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.shadowColor = [UIColor whiteColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    _titleLabel.text = titleString;
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.textColor = [UIColor colorWithRed:128/255. green:136/255. blue:149/255. alpha:1];
    _subtitleLabel.textAlignment = UITextAlignmentCenter;
    _subtitleLabel.shadowColor = [UIColor whiteColor];
    _subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    
    _subtitleLabel.text = subtitleString;
    
    _imageView = [[UIImageView alloc] initWithImage:[self maskedImageWithImage:image]];
    _imageView.frame = CGRectMake((int)(frame.size.width/2)-(_imageView.frame.size.width/2), (int)(frame.size.height/2)-(_imageView.frame.size.height/2), _imageView.image.size.width, _imageView.image.size.height);

    
    [self addSubview:_imageView];
    [self addSubview:_subtitleLabel];
    [self addSubview:_titleLabel];
    

		
	
	return self;
	
}
- (id) initWithFrame:(CGRect)frame emptyViewImage:(TKEmptyViewImage)image title:(NSString*)titleString subtitle:(NSString*)subtitleString{
	return [self initWithFrame:frame mask:[self predefinedImage:image] title:titleString subtitle:subtitleString];
}
- (id) initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame emptyViewImage:TKEmptyViewImageStar title:@"" subtitle:@""];
}


- (void) layoutSubviews{	
	CGSize s = self.bounds.size;
	
	CGRect ir = _imageView.bounds;
	ir.origin = CGPointMake( (int)(s.width/2)-(ir.size.width/2), (int)(s.height/2)-(ir.size.height/2 + ir.size.height/8));
	
	_imageView.frame = ir;
	
	_titleLabel.frame = CGRectMake(0,(int) MAX( s.height/2+s.height/4,(int)ir.origin.y+ir.size.height+4) , s.width , 20);
	_subtitleLabel.frame = CGRectMake((int)0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height , s.width , 16);
	
}


- (void) setImage:(UIImage*)image{
	_imageView.image = [self maskedImageWithImage:image];
	[self setNeedsLayout];
}
- (void) setEmptyImage:(TKEmptyViewImage)image{
	[self setImage:[self predefinedImage:image]];
}
- (UIImage*) maskedImageWithImage:(UIImage*)m{
	
	if(m==nil) return nil;

	UIGraphicsBeginImageContext(CGSizeMake((m.size.width)*m.scale , (m.size.height+2)*m.scale));
	CGContextRef context = UIGraphicsGetCurrentContext();

	NSArray *colors = [NSArray arrayWithObjects:
				   [UIColor colorWithRed:174/255.0 green:182/255.0 blue:195/255.0 alpha:1],
				   [UIColor colorWithRed:197/255.0 green:202/255.0 blue:211/255.0 alpha:1],nil];
	

	CGContextSetShadowWithColor(context, CGSizeMake(1, 4),4, [UIColor colorWithWhite:0 alpha:0.1].CGColor);
	[m drawInRect:CGRectMake(0, 0+(1*m.scale),m.size.width*m.scale, m.size.height*m.scale)];
	[m drawMaskedGradientInRect:CGRectMake(0, 0, m.size.width*m.scale, m.size.height*m.scale) withColors:colors];
	
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImage *scaledImage = [UIImage imageWithCGImage:image.CGImage scale:m.scale orientation:UIImageOrientationUp];
	

	
	return scaledImage;
}
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
		case TKEmptyViewImageMale:
			str = @"malePerson";
			break;
		case TKEmptyViewImageTelevision:
			str = @"television";
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
	
	
	return [UIImage imageWithContentsOfFile:TKBUNDLE(path)];
}



@end
