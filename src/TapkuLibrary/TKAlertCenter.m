//  TKAlertCenter.m
//  Created by Devin Ross on 9/29/10.
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

#import "TKAlertCenter.h"

@interface TKAlertCenter()
@property (nonatomic,retain) NSMutableArray *alerts;
@end


@interface TKAlertView : UIView {
	UILabel *message;
	UIImage *image;
}

- (id) init;
- (void) setMessageText:(NSString*)str;
- (void) setImage:(UIImage*)image;

@end



@implementation TKAlertCenter
@synthesize alerts;

+ (TKAlertCenter*) defaultCenter {
	static TKAlertCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[TKAlertCenter alloc] init];
	}
	return defaultCenter;
}

- (id) init{
	if(!(self=[super init])) return nil;
	
	self.alerts = [NSMutableArray array];
	alertView = [[TKAlertView alloc] init];
	active = NO;
	
	[[UIApplication sharedApplication].keyWindow addSubview:alertView];

	
	return self;
}
- (void) showAlerts{
	
	if([self.alerts count] < 1) {
		active = NO;
		return;
	}
	
	active = YES;
	
	alertView.transform = CGAffineTransformIdentity;
	alertView.alpha = 0;
	[[UIApplication sharedApplication].keyWindow addSubview:alertView];

	
	
	NSArray *ar = [self.alerts objectAtIndex:0];

	
	if([ar count] > 1) [alertView setImage:[[self.alerts objectAtIndex:0] objectAtIndex:1]];
	if([ar count] > 0) [alertView setMessageText:[[self.alerts objectAtIndex:0] objectAtIndex:0]];
	
	alertView.center = [UIApplication sharedApplication].keyWindow.center;

	
	
	CGRect rr = alertView.frame;
	rr.origin.x = (int)rr.origin.x;
	rr.origin.y = (int)rr.origin.y;
	alertView.frame = rr;
	
	
	
	
	
	alertView.transform = CGAffineTransformMakeScale(2, 2);
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep2)];
	alertView.transform = CGAffineTransformIdentity;
	alertView.alpha = 1;
	[UIView commitAnimations];
	
	
}
- (void) animationStep2{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep3)];
	alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
	alertView.alpha = 0;
	[UIView commitAnimations];
}
- (void) animationStep3{
	
	[alertView removeFromSuperview];
	[alerts removeObjectAtIndex:0];
	[self showAlerts];
	
}
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image{
	[self.alerts addObject:[NSArray arrayWithObjects:message,image,nil]];
	if(!active) [self showAlerts];
}
- (void) dealloc{
	[alerts release];
	[alertView release];
	[super dealloc];
}

@end





@implementation TKAlertView

- (id) init{
	
	if(!(self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])) return nil;
	
	
	self.backgroundColor = [UIColor clearColor];
	message = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
	message.backgroundColor = [UIColor clearColor];
	message.textColor = [UIColor whiteColor];
	message.font = [UIFont boldSystemFontOfSize:14];
	message.textAlignment = UITextAlignmentCenter;
	message.numberOfLines = 3;
	[self addSubview:message];
	
	return self;
	
}
- (void) adjust{
	
	
	CGSize s = [message.text sizeWithFont:message.font constrainedToSize:CGSizeMake(160,200)] ;
	
	self.bounds = CGRectMake(0, 0, s.width+40, s.height+15+15+7+image.size.height);
	
	
	CGRect mr = message.frame;
	mr.size = s;
	mr.size.height += 5;
	mr.origin.x = 20;
	mr.origin.y = 15+7+image.size.height;
	
	message.frame = mr;
	
	
	
	
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
}
- (void) setMessageText:(NSString*)str{
	message.text = str;
	[self adjust];
}
- (void) setImage:(UIImage*)img{
	[image release];
	image = [img retain];
	
	[self adjust];
}
- (void) drawRect:(CGRect)rect{
	[UIView drawRoundRectangleInRect:rect withRadius:10 color:[UIColor colorWithWhite:0 alpha:0.8]];
	
	
	CGRect r = CGRectZero;
	r.origin.y = 15;
	r.origin.x = (rect.size.width-image.size.width)/2;
	r.size = image.size;
	[image drawInRect:r];
}
- (void) dealloc{
	[message release];
	[image release];
	[super dealloc];
}

@end
