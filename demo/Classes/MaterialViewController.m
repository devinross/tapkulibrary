//
//  MaterialViewController.m
//  Demo
//
//  Created by Devin Ross on 12/22/14.
//
//

#import "MaterialViewController.h"

@interface MaterialViewController ()

@end

@implementation MaterialViewController


- (void) loadView{
	[super loadView];
	
	self.colorView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.colorView.backgroundColor = [UIColor randomColor];
	[self.view addSubview:self.colorView];
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	

	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self.view];
	[self.view fireMaterialTouchDiskAtPoint:p];
	
	
	
	
	
	[self.view materialTransitionWithSubview:self.colorView atPoint:p changes:^{
		
		
		self.colorView.backgroundColor = [UIColor randomColor];
		
	} completion:^(BOOL finished) {
		
	}];
}

@end
