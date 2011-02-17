//
//  TKGraphView.m
//  Created by Devin Ross on 12/8/09.
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

#import "TKGraphView.h"
#import "UIView+TKCategory.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"

#define BOTTOM_LINE 270.0
#define SCROLL_HEIGHT 230.0
#define stageTopMargin 40.0


#define INDICATOR_WIDTH 80.0
#define INDICATOR_HEIGHT 43.0
#define SCROLL_MARGINS 40

static int POINT_DISTANCE = 50;

static float lowValue; 
static float highValue;



#pragma mark TKGraphViewGoalLabel

@interface TKGraphViewGoalLabel : UIView{
	NSString *title;
}
@property (copy,nonatomic) NSString *title;

@end

@implementation TKGraphViewGoalLabel
@synthesize title;

- (id) init{
	
	if(![super initWithFrame:CGRectMake(0, 0, 100, 18)]) 
		return nil;
	
	self.backgroundColor = [UIColor clearColor];
	
	return self;
}

- (void) drawRect:(CGRect)rect{
	
	[UIView drawRoundRectangleInRect:rect withRadius:4.0 color:[UIColor redColor]];
	[[UIColor whiteColor] set];
	[title drawInRect:CGRectMake(6, 2, 100, 12) withFont:[UIFont boldSystemFontOfSize:11]];
	
}

- (void) setTitle:(NSString*)str{
	[title release];
	title = [str copy];
	CGSize s = [title sizeWithFont:[UIFont boldSystemFontOfSize:11]];
	CGRect r = self.frame;
	r.size.width = s.width + 12;
	self.frame = r;
	[self setNeedsDisplay];
}

- (void) dealloc{
	[title release];
	[super dealloc];
}

@end



#pragma mark TKGraphViewIndicator

@interface TKGraphViewIndicator : UIView {
	UIImageView *background;
	UILabel *label;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up;
@end

@implementation TKGraphViewIndicator

- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up{
	
	if(![super initWithFrame:frame]) return nil;
	
	int y;
	UIImage *img;
	
	if(up){
		img = [UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/graph/popup"];
		y = 5;
	}else{
		img = [UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/graph/popdown"];
		y = 14;
	}
	
	background = [[UIImageView alloc] initWithImage:img];
	[self addSubview:background];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(3, y, INDICATOR_WIDTH - 6, 20)];
	label.text = str;
	label.font = [UIFont boldSystemFontOfSize:14.0];
	label.minimumFontSize = 10.0;
	label.adjustsFontSizeToFitWidth = YES;
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	[self addSubview:label];
	
	return self;
}
- (void)dealloc {
	[background release];
	[label release];
	[super dealloc];
}

@end




#pragma mark TKGraphViewPlotView

@interface TKGraphViewPlotView : UIView {
	NSArray *data;
	NSMutableArray *labels;
}

@property (retain,nonatomic) NSArray *data;

@end

@implementation TKGraphViewPlotView
@synthesize data;

- (void) setData:(NSArray *)d{
	
	[labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[labels release]; labels = nil;
	[data release];
	data = [d retain];
	[self setNeedsDisplay];
}

- (float) valueToYCoordinate:(float)value{
	float ret = SCROLL_HEIGHT * ((value - lowValue) / (highValue - lowValue));
	return SCROLL_HEIGHT - ret;
}
- (float) yCoordinateToValue:(float)y{
	float q = (((float)y)/SCROLL_HEIGHT);
	q = q * (highValue - lowValue) + lowValue;
	return q;
}
- (float) yCoordinate:(NSObject <TKGraphViewPoint> *)obj{
	float f = [[obj yValue] floatValue];
	return [self valueToYCoordinate:f];
}

// DRAW
- (void) drawPointsFillWithContext:(CGContextRef) context{
	
	if([data count] < 2) return;
	
	
	CGContextSaveGState(context);
	
	CGContextSetRGBFillColor(context, (230.0 / 255.0), (242.0/255.0), (250.0 / 255.0), 0.9);
	CGContextSetLineWidth(context, 0);
	
	
	BOOL started = NO;
	
	int i=0,j=0;
	
	for(; i < [data count]; i++){
		NSObject <TKGraphViewPoint> *d = [data objectAtIndex:i];
		if([d yValue] != nil){
			if(!started){
				CGContextMoveToPoint(context, (i+1) * POINT_DISTANCE + SCROLL_MARGINS, SCROLL_HEIGHT);
				started = YES;
			}
			CGContextAddLineToPoint(context,  (i+1) * POINT_DISTANCE + SCROLL_MARGINS,[self yCoordinate:[data objectAtIndex:i]]);
			j=i;
		}
	}
	
	CGContextAddLineToPoint(context, (j+1) * POINT_DISTANCE + SCROLL_MARGINS, SCROLL_HEIGHT);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	CGContextRestoreGState(context);
	
}
- (void) drawPointsLineWithContext:(CGContextRef) context{
	
	CGContextSaveGState(context);
	
	CGContextSetRGBStrokeColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 3);
	CGContextSetLineJoin(context, kCGLineJoinBevel);
	
	BOOL started = NO;
	
	CGContextMoveToPoint(context, POINT_DISTANCE, [self yCoordinate:[data objectAtIndex:0]]);
	
	for(int i = 0; i < [data count] ; i++){
		NSObject <TKGraphViewPoint> *d = [data objectAtIndex:i];
		
		float x = (i+1.0) * POINT_DISTANCE + SCROLL_MARGINS;
		
		if([d yValue] != nil){
			
			float y = [self yCoordinate:[data objectAtIndex:i]];
			if(!started){
				CGContextMoveToPoint(context, x, [self yCoordinate:[data objectAtIndex:i]]);
				started = YES;
			}else
				CGContextAddLineToPoint(context, x, y);
			
		}
	}
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
	


	
	
}
- (void) drawPointCirlesWithContext:(CGContextRef) context{
	
	//CGContextSetRGBStrokeColor(context,249.0/255.0, 249.0/255.0, 249.0/255.0, 1.0);
	CGContextSetRGBFillColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 2);
	
	for(int i = 0; i < [data count] ; i++){
		
		
		if([[data objectAtIndex:i] yValue] != nil){
			int x = (i+1) * POINT_DISTANCE + SCROLL_MARGINS , y = [self yCoordinate:[data objectAtIndex:i]];
			CGContextFillEllipseInRect(context, CGRectMake(x-4, y-4, 8.0, 8.0));
		}
		
	}
	
}
- (void) drawXAxisLabelsWithContext:(CGContextRef) context{
	
	//int c = [data count] * POINT_DISTANCE;
	
	float z =  1.0 / (POINT_DISTANCE / 50.0);
	int per = (int)z;
	per = (per<1) ? 1 : per;

	labels = [[NSMutableArray alloc] initWithCapacity:[self.data count]];
	
	for(int i=0;i<[self.data count];i += per){
		
		float x = (i+1.0) * POINT_DISTANCE + SCROLL_MARGINS;
		NSObject <TKGraphViewPoint> *d = [data objectAtIndex:i];
		CGFloat clr[] = {0,0,0,0.3};
		
		
		[UIView drawLineInRect:CGRectMake(x-.5, SCROLL_HEIGHT, 0, 6) colors:clr];
		
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, SCROLL_HEIGHT+4, 50, 15)];
		lab.text = [d xLabel];
		[lab setFont:[UIFont boldSystemFontOfSize:10.0]];
		[lab setTextColor:[UIColor grayColor]];
		[lab setBackgroundColor:[UIColor clearColor]];
		[self addSubview:lab];
		[labels addObject:lab];
		[lab release];
		
	}	
}
- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawXAxisLabelsWithContext:context];
	[self drawPointsFillWithContext:context];
	[self drawPointsLineWithContext:context];
	[self drawPointCirlesWithContext:context];
	
	
}


// GET TOUCH
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"Touch");
	[[[self superview] superview] touchesEnded:touches withEvent:event];
}

- (void) dealloc{
	[labels release];
	[data release];
	[super dealloc];
}

@end



#pragma mark TKGraphView

@interface TKGraphView (PrivateMethods)

- (void) drawBackground:(CGContextRef)context;
- (void) drawBottomLine:(CGContextRef)context;
- (void) drawHorizontalLines:(CGContextRef)context;

- (float) valueToYCoordinate:(float)value;
- (float) yCoordinateToValue:(float)y;
- (void) moveGoalLabel:(BOOL)animated;
- (void) calculateHighLow;
@end

@implementation TKGraphView
@synthesize title = titleLabel,touchIndicatorEnabled,goalShown,goalValue;


// PUBLIC

- (id) initWithFrame:(CGRect)frame {
	if(![super initWithFrame:frame]) return nil;
	

	titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	titleLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:titleLabel];
	
	CGRect r = CGRectInset(frame,60, 8);
	r.size.height = 20;
	titleLabel.frame = r;
	
	
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, stageTopMargin, self.frame.size.width, frame.size.height - 30)];
	scrollView.delegate = self;
	scrollView.showsHorizontalScrollIndicator = YES;
	scrollView.backgroundColor = [UIColor clearColor];
	[self addSubview:scrollView];
	
	border = [[UIImageView alloc] initWithImage:[UIImage imageNamedTK:@"TapkuLibrary.bundle/Images/graph/mask"]];
	[self addSubview:border];
	
	plotView = [[TKGraphViewPlotView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	plotView.backgroundColor = [UIColor clearColor];
	[scrollView addSubview:plotView];
	
	
	
	goalLine = [[UIView alloc] initWithFrame:CGRectZero];
	goalLine.backgroundColor = [UIColor redColor];
	
	goalLabel = [[TKGraphViewGoalLabel alloc] init];
	goalLabel.title = @"GOAL";
	
	
	touchIndicatorEnabled = YES;
	goalShown = NO;
		
    
    return self;
}

- (void) setPointDistance:(int)distance{
	if(distance < 1 || distance > 100) return;
	POINT_DISTANCE = distance;
	[self reload];
}
- (int) pointDistance{
	return POINT_DISTANCE;
}

- (void) reload{
	[indicator removeFromSuperview];
	[self calculateHighLow];
	[self setNeedsDisplay];
	[plotView setData:data];
}

- (void) scrollToPoint:(NSInteger)point animated:(BOOL)animated{
	
	if(point<0 || point >= [data count]) return;
	
	
	
	float x = point * POINT_DISTANCE;
	[scrollView setContentOffset:CGPointMake(x-480+POINT_DISTANCE*2, 0) animated:animated];
	
	
	
	CGRect r = goalLabel.frame;
	r.origin.x = x-480+POINT_DISTANCE*2 + 420;
	if(animated){
		[UIView beginAnimations:NULL context:nil];
		[UIView setAnimationDuration:.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	}
	
	goalLabel.frame = r;
	if(animated)
		[UIView commitAnimations];
	
}

- (void) hideIndicator{
	
	if(indicator!=nil){
		
		UIView *v = indicator;
		indicator = nil;
		
		[UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState 
						 animations:^{
							 v.alpha = 0;
						 } 
						 completion:^(BOOL completed){
							 [v removeFromSuperview];
							 [v release];
							 
						 }];
		

	}
	
}

- (void) showIndicatorForPoint:(int)point{
	int i = point;
	
	if(i >= [data count])
		i = [data count] - 1;
	else if(i < 0)
		i = 0;
	
	NSObject <TKGraphViewPoint> *d = [data objectAtIndex:i];
	
	if([d yValue] == nil) return;
	
	
	float y = [self valueToYCoordinate:[[d yValue] floatValue]];
	float x = POINT_DISTANCE + i * POINT_DISTANCE - (INDICATOR_WIDTH/2) + SCROLL_MARGINS;
	
	//int row = i;
	
	NSString *str = [d yLabel];
	
	BOOL  up = y - INDICATOR_HEIGHT - 10 < 10 ? NO : YES;
	
	
	int originy = up ?  y - 45 : y + 6;

	if(indicator!=nil){
		[indicator removeFromSuperview];
		[indicator release];
	}
	
	
	indicator = [[TKGraphViewIndicator alloc] initWithFrame:CGRectMake((int)x,originy, INDICATOR_WIDTH, INDICATOR_HEIGHT) 
													  title:str
													 sideUp:up];
	[scrollView addSubview:indicator];
	
	
	
	CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"opacity"];
	a.duration = 0.5;
	a.fromValue = [NSNumber numberWithFloat:0.0];
	a.toValue = [NSNumber numberWithFloat:1.0];
	[[indicator layer] addAnimation:a forKey:@"changeopacity"];
	indicator.layer.opacity = 1.0;
}

- (void) setGoalShown:(BOOL)yes{
	goalShown = yes;
	if(!yes){
		[goalLine removeFromSuperview];
		[goalLabel removeFromSuperview];
	}else{
		
		CGRect r = CGRectMake(-400, (int)([self valueToYCoordinate:[goalValue floatValue]]), scrollView.contentSize.width , 1);
		goalLine.frame = r;
		[scrollView addSubview:goalLine];
		
		r = goalLabel.frame;
		r.origin.y = (int) ([self valueToYCoordinate:[goalValue floatValue]]) - 9;
		goalLabel.frame = r;
		[scrollView addSubview:goalLabel];
		[self moveGoalLabel:YES];
	}
	
}
- (NSString*) goalTitle{
	return goalLabel.title;
}
- (void) setGoalTitle:(NSString *)str{
	goalLabel.title = str;
}
- (void) setGoalValue:(NSNumber *)no{
	
	[goalValue release];
	goalValue = [no retain];
	
	[self reload];
	[self setGoalShown:goalShown];
	
}

- (void) setGraphWithDataPoints:(NSArray*)dataPoints{
	[data release];
	data = [dataPoints retain];
	[self calculateHighLow];
	[self setNeedsDisplay];
	[plotView setData:data];
}


#pragma mark DELEGATE & TOUCH FUNCTIONS
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll{
	[self moveGoalLabel:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	//[self hideIndicator];
	
	[UIView beginAnimations:nil context:nil];

	indicator.alpha = 0;
	[UIView commitAnimations];
	

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	if(!touchIndicatorEnabled) return;
	
	UITouch *t = [touches anyObject];
	CGPoint point = [t locationInView:plotView];
	
	NSLog(@"%f",point.x);
	
	int i = ((point.x - SCROLL_MARGINS) -(POINT_DISTANCE/2)) / POINT_DISTANCE;
	
	
	[self showIndicatorForPoint:i];
	
}


- (void) drawBackground:(CGContextRef)context{
	// GRAY BACKGROUND 
	CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, 300.0));
	CGContextSetRGBFillColor(context, 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.4);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, BOTTOM_LINE));
}
- (void) drawBottomLine:(CGContextRef)context{
	[UIView drawLineInRect:CGRectMake(0, BOTTOM_LINE+.5, 480, 0) red:0 green:0 blue:0 alpha:.4];
}
- (void) drawHorizontalLines:(CGContextRef)context{
	
	// HORIZONTAL LINES
	
	
	if(data==nil || [data count] < 1)  return;
	UIImage *line = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/horizontalline.png")];
	
	for(int i=0; i < 8;i++){
		
		int yline = ((SCROLL_HEIGHT/7) * i);
		int tim = [self yCoordinateToValue:yline];
		yline = [self valueToYCoordinate:tim];
		yline++;
		yline = SCROLL_HEIGHT + stageTopMargin - yline;		
		
		if(yline>268) yline = 270;
		
		
		[line drawAtPoint:CGPointMake(0,yline)];
		
		
	}
	
}
- (void) drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context];
	[self drawBottomLine:context];
	//[self drawHorizontalLines:context];
	
	
	float width = ([data count] + 1) * POINT_DISTANCE + SCROLL_MARGINS * 2;
	float height = scrollView.frame.size.height;
	
	scrollView.contentSize = CGSizeMake(width,height);
	plotView.frame = CGRectMake(0, 0, width, height);
	if(goalLine!=nil){
		CGRect r = goalLine.frame;
		r.size.width = width + 800;
		goalLine.frame = r;
	}
	
}

- (void) calculateHighLow{
	//highValue;
	//lowValue;
	
	if(data == nil || [data count] < 1) return;
	
	highValue = lowValue = [[[data objectAtIndex:0] yValue] floatValue];
	
	
	for(int i=0;i<[data count]; i++){
		
		NSObject <TKGraphViewPoint> *obj = [data objectAtIndex:i];
		if(obj != nil){
			float value = [[obj yValue] floatValue];
			if(value > highValue) highValue = value;
			if(value < lowValue) lowValue = value;
		}
		
	}
	
	
	if (goalValue != nil){
		if([goalValue floatValue] > highValue) highValue = [goalValue floatValue];
		if([goalValue floatValue] < lowValue) lowValue = [goalValue floatValue];
	}
	
	
	//NSLog(@"GOAL %f",[goalValue floatValue]);
	highValue = highValue + abs(highValue * 0.08);
	lowValue = lowValue - abs(lowValue * .08);
	
	
	
}

- (void) moveGoalLabel:(BOOL)animated{
	CGRect r = goalLabel.frame;
	r.origin.x = scrollView.contentOffset.x + 420;
	if(animated){
		[UIView beginAnimations:NULL context:nil];
		[UIView setAnimationDuration:.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	}
	
	goalLabel.frame = r;
	if(animated)
		[UIView commitAnimations];
	
	
}


#pragma mark UTILITY FUNCTIONS
- (float) valueToYCoordinate:(float)value{
	float ret = SCROLL_HEIGHT * ((value - lowValue) / (highValue - lowValue));
	return  SCROLL_HEIGHT - ret;
}
- (float) yCoordinateToValue:(float)y{
	float q = (((float)y)/SCROLL_HEIGHT);
	q = q * (highValue - lowValue) + lowValue;
	return (float)q;
}

- (void) dealloc {
	
	[data release];
	[goalValue release];
	[goalLine release];
	[goalLabel release];
	[indicator release];
	[titleLabel release];
	[border release];
	[scrollView release];
	[plotView release];
    [super dealloc];
}

@end