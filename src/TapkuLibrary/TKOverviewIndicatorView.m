//
//  InfoIndicator.m
//  Created by Devin Ross on 7/20/09.
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


#import "TKOverviewIndicatorView.h"
#import "UIImageAdditions.h"
#import "NSStringAdditions.h"

@implementation TKOverviewIndicatorView
@synthesize color;

static UIImage *left = nil;
static UIImage *right = nil;
static UIImage *middle = nil;

- (id) initWithColor:(TKOverviewIndicatorViewColor)colour{
	if (self = [super initWithFrame:CGRectMake(0, 0, 130, 27)]) {
        // Initialization code
		textLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, 120, 27), 6, 2)];
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.font = [UIFont boldSystemFontOfSize:16];
		textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
		textLabel.shadowOffset = CGSizeMake(0,-1);
		[self addSubview:textLabel];
		
		
		
		[self setColor:colour];
		
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (float) calculateHeightOfTextFromWidth:(NSString*)text 
									font:(UIFont*)withFont 
								   width:(float)width 
							   linebreak:(UILineBreakMode)lineBreakMode{
	[text retain];
	[withFont retain];
	CGSize suggestedSize = [text sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
	[text release];
	[withFont release];
	
	return suggestedSize.width;
}

- (NSString*) text{
	return textLabel.text;
}
- (void) setText:(NSString*)str{
	textLabel.text = str;
	CGRect f = textLabel.frame;
	f.size.width = [str sizeWithFont:textLabel.font].width;
	textLabel.frame = f;
	[self setNeedsDisplay];
}

- (void) setColor:(TKOverviewIndicatorViewColor)colour{
	if(color == colour && middle != nil) return;
	color = colour;
	[left release];
	[right release];
	[middle release];
	
	
	NSString *bundle = TKBUNDLE(@"TapkuLibrary.bundle/Images/overview/");
	
	if(color == TKOverviewIndicatorViewColorBlue){
		
		left = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_blue_left.png"]];
		middle = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_blue_middle.png"]];
		right = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_blue_right.png"]];
	}else if(color == TKOverviewIndicatorViewColorGreen){
		left = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_green_left.png"]];
		middle = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_green_middle.png"]];
		right =  [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_green_right.png"]];
	}else{
		left = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_red_left.png"]];
		middle = [UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_red_middle.png"]];
		right =[UIImage imageFromPath:[bundle stringByAppendingPathComponent:@"ind_red_right.png"]];
	}
	
	[left retain];
	[right retain];
	[middle retain];
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	float w = 6 + [textLabel.text heightWithFont:textLabel.font  width:textLabel.bounds.size.width  linebreak:textLabel.lineBreakMode].width;
	float ow = self.frame.size.width - w - 5;
	
	
	CGRect f = textLabel.frame;
	f.size.width=w;
	f.origin.x = ow;
	textLabel.frame = f;
	 


	
	CGRect sr = CGRectMake(ow-5, 0, 5, 27);
	CGContextDrawImage(context, sr, [left CGImage]);
	sr.origin.x = self.bounds.size.width - 5;
	CGContextDrawImage(context, sr, [right CGImage]);
	
	CGContextClipToRect(context, CGRectMake(ow,0, w, self.bounds.size.height));
	CGRect imageRect = CGRectMake(0, 0, 1, 27);
	imageRect.origin = CGPointMake(0, 0);
	CGContextDrawTiledImage(context, imageRect, [middle CGImage]);
	


}


- (void)dealloc {
	[textLabel release];
    [super dealloc];
}


@end
