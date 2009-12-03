//
//  TKGraph.m
//  Created by Devin Ross on 5/25/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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

#import "TKGraph.h"
#import "TKGlobal.h"
#import "UIImageAdditions.h"
#import "UIViewAdditions.h"

#define stageHeight 230.0
#define stageTopMargin 40.0
#define pointDistance 50.0

#define kIndicatorWidth 80.0
#define kIndicatorHeight 43.0



@interface TKGraphGoalLabel : UIView{
	NSString *title;
}
@property (copy,nonatomic) NSString *title;
@end
@implementation TKGraphGoalLabel
@synthesize title;


- (id) init{
	if(![super initWithFrame:CGRectMake(0, 0, 100, 18)]) return nil;
	
	self.backgroundColor = [UIColor clearColor];
	return self;
}
- (void)setTitle:(NSString*)str{
	title = [str copy];
	CGSize s = [title sizeWithFont:[UIFont boldSystemFontOfSize:11]];
	CGRect r = self.frame;
	r.size.width = s.width + 12;
	self.frame = r;
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect{

	
	[UIView drawRoundRectangleInRect:rect withRadius:4.0 color:[UIColor redColor]];
	
	[[UIColor whiteColor] set];
	[title drawInRect:CGRectMake(6, 2, 100, 12) withFont:[UIFont boldSystemFontOfSize:11]];
}

@end

@interface TKGraphIndicator : UIView {
	UIImageView *background;
	UILabel *label;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up;
@end
@implementation TKGraphIndicator

- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up{
	[super initWithFrame:frame];
	if(up){
		background = [[UIImageView alloc] initWithImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/popup.png")]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, kIndicatorWidth - 6, 20)];
	}else{
		background = [[UIImageView alloc] initWithImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/popdown.png")]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(3, 14, kIndicatorWidth - 6, 20)];
	}
	
	
	
	label.text = str;
	label.font = [UIFont boldSystemFontOfSize:14.0];
	label.adjustsFontSizeToFitWidth = YES;
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	
	[self addSubview:background];
	[self addSubview:label];
	return self;
}
- (void)dealloc {
	[background release];
	[label release];
	[super dealloc];
}

@end

@interface TKGraphPlotView : UIView {
	NSMutableArray *data;
}
@property (retain,nonatomic) NSMutableArray *data;
@end
@implementation TKGraphPlotView
@synthesize data;

- (void) setData:(NSMutableArray *)d{
	[data release];
	data = [d retain];
	[self setNeedsDisplay];
}

- (void) drawGraphFill:(CGContextRef) context{
	
	CGContextSetRGBFillColor(context, (230.0 / 255.0), (242.0/255.0), (250.0 / 255.0), 0.9);
	CGContextSetLineWidth(context, 0);
	
	if([data count] < 2) return;
	
	BOOL started = NO;
	
	int i=0;
	int j=0;
	for(; i < [data count]; i++){
		NSDictionary *d = [data objectAtIndex:i];
		if([d objectForKey:@"yCoordinate"] != nil){
			if(!started){
				CGContextMoveToPoint(context, (i+1) * pointDistance, stageHeight);
				started = YES;
			}
			CGContextAddLineToPoint(context,  (i+1) * pointDistance,[[[data objectAtIndex:i] objectForKey:@"yCoordinate"] floatValue]);
			j=i;
		}
	}
	
	CGContextAddLineToPoint(context, (j+1) * pointDistance, stageHeight);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}
- (void) drawGraphLine:(CGContextRef) context{
	
	
	//if([data count] < 2) return;
	
	UIImage *tick = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/tick.png")];
	
	
	CGContextSetRGBStrokeColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 3);
	CGContextSetLineJoin(context, kCGLineJoinBevel);
	
	BOOL started = NO;
	
	CGContextMoveToPoint(context, pointDistance, [[[data objectAtIndex:0] objectForKey:@"yCoordinate"] floatValue]);
	
	for(int i = 0; i < [data count] ; i++){
		NSDictionary *d = [data objectAtIndex:i];
		
		float x = (i+1.0) * pointDistance;
		
		if([d objectForKey:@"yCoordinate"] != nil){
			
			float y = [[d objectForKey:@"yCoordinate"] floatValue];
			if(!started){
				CGContextMoveToPoint(context, x, [[[data objectAtIndex:i] objectForKey:@"yCoordinate"] floatValue]);
				started = YES;
			}else
				CGContextAddLineToPoint(context, x, y);
			
		}
		
		
		
		
		
		[tick drawAtPoint:CGPointMake(x,stageHeight)];
		
		/*
		 UIImageView *vert = [[UIImageView alloc] initWithImage:];
		 [vert setFrame:CGRectMake(x, stageHeight, 1, 8)];
		 [self addSubview:vert];
		 */
		
		
		
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, stageHeight+4, 50, 15)];
		lab.text = [d objectForKey:@"xLabel"];
		[lab setFont:[UIFont boldSystemFontOfSize:10.0]];
		[lab setTextColor:[UIColor grayColor]];
		[lab setBackgroundColor:[UIColor clearColor]];
		[self addSubview:lab];
		
	}
	CGContextStrokePath(context);
}
- (void) drawPointCirles:(CGContextRef) context{
	
	//CGContextSetRGBStrokeColor(context,249.0/255.0, 249.0/255.0, 249.0/255.0, 1.0);
	CGContextSetRGBFillColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 2);
	
	for(int i = 0; i < [data count] ; i++){
		
		
		NSDictionary *d = [data objectAtIndex:i];
		if([d objectForKey:@"yCoordinate"] != nil){
			int x = (i+1) * pointDistance, y = [[d objectForKey:@"yCoordinate"] floatValue];
			CGContextFillEllipseInRect(context, CGRectMake(x-4, y-4, 8.0, 8.0));
		}
		
	}
	
}
- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawGraphFill:context];
	[self drawGraphLine:context];
	[self drawPointCirles:context];
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[[[self superview] superview] touchesEnded:touches withEvent:event];
}

@end





@interface TKGraph (PrivateMethods)

- (void) drawBackground:(CGContextRef)context;
- (void) drawBottomLine:(CGContextRef)context;
- (void) drawHorizontalLines:(CGContextRef)context;
- (void) drawGoalLine:(CGContextRef)context;

- (void) loadData;
- (void) updateGoalLabel:(BOOL)animated;

- (float) valueToYCoordinate:(float)value;
- (float) yCoordinateToValue:(float)y;

@end
@implementation TKGraph
@synthesize dataSource,touchIndicatorEnabled;

- (void) setDataSource:(id<TKGraphDataSource>)src {
	dataSource = src;
	[self loadData];
}


- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

		title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.backgroundColor = [UIColor clearColor];
		title.font = [UIFont boldSystemFontOfSize:16.0];
		title.textAlignment = UITextAlignmentCenter;
		[self addSubview:title];
		
		CGRect r = CGRectInset(frame,60, 8);
		r.size.height = 20;
		title.frame = r;
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, stageTopMargin, self.frame.size.width, frame.size.height - 30)];
		scrollView.delegate = self;
		scrollView.showsHorizontalScrollIndicator = YES;
		scrollView.backgroundColor = [UIColor clearColor];
		[self addSubview:scrollView];
		
		border = [[UIImageView alloc] initWithImage:[UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/mask.png")]];
		[self addSubview:border];
		
		plotView = [[TKGraphPlotView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		plotView.backgroundColor = [UIColor clearColor];
		[scrollView addSubview:plotView];
		
		goalLabel = [[TKGraphGoalLabel alloc] init];
		
		touchIndicatorEnabled = YES;
		
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
	
	if(data==nil) [self loadData];
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawBackground:context];
	[self drawBottomLine:context];
	[self drawHorizontalLines:context];
	if(goal) [self drawGoalLine:context];
	
	
	float width = ([data count] + 1) * pointDistance;
	float height = scrollView.frame.size.height;
	
	scrollView.contentSize = CGSizeMake(width,height);
	plotView.frame = CGRectMake(0, 0, width, height);
	if(goalLine!=nil){
		CGRect r = goalLine.frame;
		r.size.width = width + 800;
		goalLine.frame = r;
	}
	
	[plotView setData:data];
	
	
	

	
	
	
	
}

- (void) loadData{
	
	if ([dataSource respondsToSelector:@selector(titleForGraph:)])
		title.text = [dataSource titleForGraph:self];
	
	int numberOfPoints = [dataSource numberofPointsOnGraph:self];
	if(numberOfPoints < 1) return;
	
	[data release];
	data = nil;
	
	data = [[NSMutableArray alloc] initWithCapacity:numberOfPoints];
	
	
	NSNumber *n;
	int j = 0;

	while(YES){
		n = [dataSource graph:self  yValueForPoint:j];
		if(n != nil) break;
		if(j >= numberOfPoints) return;
		j++;
	}
	
	
	highValue = [n floatValue];
	lowValue = [n floatValue];
	
	
	for(int i=0;i<numberOfPoints; i++){
		
		NSNumber *num = [dataSource graph:self  yValueForPoint:i];
		NSString *xLabel = [dataSource graph:self xLabelForPoint:i];
		
		
		NSMutableDictionary *point = [[NSMutableDictionary alloc] init];
		
		[point setObject:xLabel forKey:@"xLabel"];
		
		if(num != nil){
			
			[point setObject:num forKey:@"yValue"];
			
			float yValue = [num floatValue];
			[point setObject:[dataSource graph:self yLabelForValue:yValue] forKey:@"yLabel"];
			
			if(yValue > highValue) highValue = yValue;
			if(yValue < lowValue) lowValue = yValue;
		}
		
		[data addObject:point];
		[point release];
	}
	
	goal = NO;
	NSNumber *g;
	if ([dataSource respondsToSelector:@selector(goalValueForGraph:)]){
		
		g = [dataSource goalValueForGraph:self];
		goal = YES;
		goalValue = [g floatValue];
		
		if(goalValue > highValue) highValue = goalValue;
		if(goalValue < lowValue) lowValue = goalValue;
	}
	
	
	
	highValue = highValue + highValue * 0.05;
	lowValue = lowValue - lowValue * .05;
	
	for(int i=0;i<numberOfPoints;i++){
		NSMutableDictionary *d = [data objectAtIndex:i];
		
		if([d objectForKey:@"yValue"] != nil){
			float yCoor = [self valueToYCoordinate:[[d objectForKey:@"yValue"] floatValue]];
			yCoor = stageHeight - yCoor;
			[d setObject:[NSNumber numberWithFloat:yCoor] forKey:@"yCoordinate"];
		}
	}
	
	
}

- (void) reload{
	
	[data release];
	data = nil;
	[self setNeedsDisplay];
	
}


- (void) moveToPoint:(NSInteger)point animated:(BOOL)animated{
	
	if(point<0 || point >= [data count]) return;
	


	float x = point * pointDistance;
	[scrollView setContentOffset:CGPointMake(x-480+pointDistance*2, 0) animated:animated];
	//[self updateGoalLabel:animated];
	
	
	CGRect r = goalLabel.frame;
	r.origin.x = x+25;
	if(animated){
		[UIView beginAnimations:NULL context:nil];
		[UIView setAnimationDuration:.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	}
	
	goalLabel.frame = r;
	if(animated)
		[UIView commitAnimations];
	
		
	
}
- (void) updateGoalLabel:(BOOL)animated{
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

#pragma mark TITLE TEXT
- (NSString*) graphTitle{
	return title.text;
}
- (void) setGraphTitle:(NSString *)str{
	title.text = str;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll{
	[self updateGoalLabel:YES];
}

- (void) drawBackground:(CGContextRef)context{
	// GRAY BACKGROUND 
	CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, 300.0));
	CGContextSetRGBFillColor(context, 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.4);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, 270.0));
}
- (void) drawBottomLine:(CGContextRef)context{
	
	UIImage *line = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/bottomline.png")];
	[line drawAtPoint:CGPointMake(0,270)];
	
}
- (void) drawHorizontalLines:(CGContextRef)context{
	
	// HORIZONTAL LINES
	
	UIImage *line = [UIImage imageFromPath:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/horizontalline.png")];
	
	for(int i=0; i < 8;i++){
		
		int yline = ((stageHeight/7) * i);
		int tim = [self yCoordinateToValue:yline];
		yline = [self valueToYCoordinate:tim];
		yline++;
		yline = stageHeight + stageTopMargin - yline;		

		if(yline>268) yline = 270;
		
		///(@"%d",yline);
		

		[line drawAtPoint:CGPointMake(0,yline)];

		
	}
	
}
- (void) drawGoalLine:(CGContextRef)context{
	
	if(goalLine==nil){
		goalLine = [[UIView alloc] initWithFrame:CGRectZero];
		goalLine.backgroundColor = [UIColor redColor];
	}
	CGRect r = CGRectMake(-400, (int)(stageHeight  - [self valueToYCoordinate:goalValue]), 480, 1);
	goalLine.frame = r;
	[scrollView addSubview:goalLine];
	
	if(goalLabel==nil)
		goalLabel = [[TKGraphGoalLabel alloc] init];
	r = goalLabel.frame;
	r.origin.y = (int) (stageHeight  - [self valueToYCoordinate:goalValue]) - 9;
	//r = CGRectMake(scrollView.contentOffset.x + 420, (int) (stageHeight   - [self valueToYCoordinate:goalValue]) - 9, 60, goalLabel.frame.size.height);
	goalLabel.frame = r;
	goalLabel.title = @"GOAL";
	[scrollView addSubview:goalLabel];
	
}



- (float) valueToYCoordinate:(float)value{
	float ret = stageHeight * ((value - lowValue) / (highValue - lowValue));
	return  ret;
}
- (float) yCoordinateToValue:(float)y{
	float q = (((float)y)/stageHeight);
	q = q * (highValue - lowValue) + lowValue;
	return (float)q;
}



- (void) showIndicatorForPoint:(int)point{
	int i = point;
	
	if(i >= [data count])
		i = [data count] - 1;
	else if(i < 0)
		i = 0;
	
	NSDictionary *d = [data objectAtIndex:i];
	
	if([d objectForKey:@"yValue"] == nil) return;
	
	float y = [[d objectForKey:@"yCoordinate"] floatValue];
	float x = i * pointDistance;
	
	int row = i;
	
	NSString *str;
	if ([dataSource respondsToSelector:@selector(graph:titleForIndicatorAtXPoint:)])
		str = [dataSource graph:self titleForIndicatorAtXPoint:row];
	else
		str = [d objectForKey:@"yLabel"];
	
	if(y - kIndicatorHeight - 10 < 10)
		indicator = [[TKGraphIndicator alloc] initWithFrame:CGRectMake((int)x + 10, (int)y + 6, kIndicatorWidth, kIndicatorHeight) 
													  title:str 
													 sideUp:NO];
	else 
		indicator = [[TKGraphIndicator alloc] initWithFrame:CGRectMake((int)x + 10,(int)y - 45, kIndicatorWidth, kIndicatorHeight) 
													  title:str
													 sideUp:YES];
	[scrollView addSubview:indicator];
	
	
	
	CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"opacity"];
	a.duration = 0.5;
	a.fromValue = [NSNumber numberWithFloat:0.0];
	a.toValue = [NSNumber numberWithFloat:1.0];
	[[indicator layer] addAnimation:a forKey:@"changeopacity"];
	indicator.layer.opacity = 1.0;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	if(!touchIndicatorEnabled) return;
	
	UITouch *t = [touches anyObject];
	CGPoint point = [t locationInView:plotView];
	
	
	
	
	if(indicator != nil){
		[indicator removeFromSuperview];
		[indicator release];
		indicator = nil;
	}
	
	int i = (point.x-(pointDistance/2)) / pointDistance;
	
	[self showIndicatorForPoint:i];
	
	
}

- (void)dealloc {
    [super dealloc];
}


@end

