//
//  LoadingHUDView.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoadingHUDView.h"
@implementation LoadingHUDView


- (id) init{
	if (self = [super initWithFrame:CGRectMake(0, 0, 280, 100)]) {
		
		_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self addSubview:_activity];
		self.backgroundColor = [UIColor clearColor];
		_hidden = YES;
		
    }
    return self;
}

- (void) startAnimating{
	if(!_hidden) return;
	_hidden = NO;
	[self setNeedsDisplay];
	[_activity startAnimating];
	
}
- (void) stopAnimating{
	if(_hidden) return;
	_hidden = YES;
	[self setNeedsDisplay];
	[_activity stopAnimating];
	
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}
- (void) adjustHeight{
	CGSize s1 = [self calculateHeightOfTextFromWidth:_title 
												font:[UIFont boldSystemFontOfSize:16] 
											   width:200 
										   linebreak:UILineBreakModeTailTruncation];
	CGSize s2 = [self calculateHeightOfTextFromWidth:_message 
												font:[UIFont systemFontOfSize:12] 
											   width:200 
										   linebreak:UILineBreakModeCharacterWrap];
	CGRect r = self.frame;
	r.size.height = s1.height + s2.height + 20;
	self.frame = r;
}

- (void) drawRoundedRect:(CGRect)rrect radius:(CGFloat)radius{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
	
	
}
- (void)drawRect:(CGRect)rect {
	
	if(_hidden) return;
	
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:16];
	UIFont *messageFont = [UIFont systemFontOfSize:12];
	
	
	
	CGSize s1 = [self calculateHeightOfTextFromWidth:_title font:titleFont width:200 linebreak:UILineBreakModeTailTruncation];
	CGSize s2 = [self calculateHeightOfTextFromWidth:_message font:messageFont width:200 linebreak:UILineBreakModeCharacterWrap];
	
	float h = s1.height + s2.height + 16;
	float w = s1.width;
	if(s2.width > s1.width) w = s2.width;
	w += 80;
	float x = 140 - (w / 2);
	
	CGPoint c = _activity.center;
	c.y = h / 2;
	c.x = x + 30;
	_activity.center = c;
	
	

	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9] set];
	CGRect rrect = CGRectMake((int)x, 0, (int)w,h);
	[self drawRoundedRect:rrect radius:5.0];
	

	
	[[UIColor whiteColor] set];
	
	float base = x+ 48;
	float rest =  (w - 48) / 2 - ( s1.width / 2);
	CGRect r = CGRectMake((int) (base+rest) , 8, (int)s1.width, (int)s1.height);
	
	CGSize s = [_title drawInRect:r 
						 withFont:titleFont 
					lineBreakMode:UILineBreakModeTailTruncation 
						alignment:UITextAlignmentCenter];

	

	r.origin.y += s.height;
	r.size.width = s2.width;
	r.size.height = s2.height;
	
	base = x+ 50;
	rest = (w - 50) / 2 - ( s2.width / 2);
	r.origin.x = (int) (base + rest);
	
	[_message drawInRect:r 
				withFont:messageFont
		   lineBreakMode:UILineBreakModeCharacterWrap 
			   alignment:UITextAlignmentCenter];

	
}




- (void) setTitle:(NSString*)str{
	_title = [str copy];
	[self adjustHeight];
	[self setNeedsDisplay];
}
- (NSString*) title{
	return _title;
}
- (void) setMessage:(NSString*)str{
	_message = [str copy];
	[self adjustHeight];
	[self setNeedsDisplay];
}
- (NSString*) message{
	return _message;
}



- (void)dealloc {
	[_activity release];
	[super dealloc];
}


@end
