//
//  TKReorderTableView.m
//  Created by Devin Ross on 6/25/13.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Portions Copyright (c) 2013 Ben Vogelzang.
 https://github.com/bvogelzang/BVReorderTableView
 
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


#import "TKReorderTableView.h"
#import "UIGestureRecognizer+TKCategory.h"

@interface TKReorderTableView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSTimer *scrollingTimer;
@property (nonatomic, assign) CGFloat scrollRate;
@property (nonatomic, strong) NSIndexPath *currentLocationIndexPath;
@property (nonatomic, strong) UIImageView *draggingView;

@end


@implementation TKReorderTableView
@dynamic delegate;

#pragma mark Init & Friends
- (id) init{
	if(!(self=[super init])) return nil;
	[self setup];
    return self;
}
- (id) initWithFrame:(CGRect)frame{
	if(!(self=[super initWithFrame:frame])) return nil;
	[self setup];
    return self;
}
- (id) initWithCoder:(NSCoder *)coder {
	if(!(self=[super initWithCoder:coder])) return nil;
	[self setup];
    return self;
}
- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
	if(!(self=[super initWithFrame:frame style:style])) return nil;
	[self setup];
    return self;
}
- (void) setup {
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:self.longPress];
    self.canReorder = YES;
}


#pragma mark Move Cell

- (UIImageView*) draggingImageViewWithImage:(UIImage*)image frame:(CGRect)frame{
	UIImageView *dragging = [[UIImageView alloc] initWithImage:image];
	dragging.frame = CGRectOffset(dragging.bounds, CGRectGetMinX(frame), CGRectGetMinY(frame));
	dragging.layer.masksToBounds = NO;
	dragging.layer.shadowColor = [UIColor blackColor].CGColor;
	dragging.layer.shadowOffset = CGSizeMake(0, 0);
	dragging.layer.shadowRadius = 4.0;
	dragging.layer.shadowOpacity = 0.4;
	return dragging;
}

- (void) longPress:(UILongPressGestureRecognizer *)gesture{
    
    CGPoint location = [gesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    
	
	
	if([self.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)] && ![self.dataSource tableView:self canMoveRowAtIndexPath:indexPath])
		indexPath = nil;
	
	
	if([gesture began] && indexPath == nil){
		[self cancelGesture];
		return;
	}else if ([gesture began] && indexPath) {
        
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:NO];
        [cell setHighlighted:NO animated:NO];
        
        // make an image from the pressed tableview cell
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // create and image view that we will drag around the screen
        if (!self.draggingView) {
			CGRect rect = [self rectForRowAtIndexPath:indexPath];
			
			self.draggingView = [self draggingImageViewWithImage:cellImage frame:rect];
            [self addSubview:self.draggingView];
            // zoom image towards user
            [UIView beginAnimations:@"zoom" context:nil];
            self.draggingView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.draggingView.center = CGPointMake(self.center.x, location.y);
            [UIView commitAnimations];
        }
        
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
		[self.delegate tableView:self willReorderRowAtIndexPath:indexPath];
        self.currentLocationIndexPath = indexPath;
        [self endUpdates];
        
        // enable scrolling for cell
        self.scrollingTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(scrollTableWithCell:) userInfo:@{ @"gesture" : gesture} repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.scrollingTimer forMode:NSDefaultRunLoopMode];
        
    } else if ([gesture changed]) {
		// dragging
		
        // update position of the drag view
        // don't let it go past the top or the bottom too far
        if (location.y >= 0 && location.y <= self.contentSize.height + 50) {
            self.draggingView.center = CGPointMake(self.center.x, location.y);
        }
        
        CGRect rect = self.bounds;
        // adjust rect for content inset as we will use it below for calculating scroll zones
        rect.size.height -= self.contentInset.top;
        CGPoint location = [gesture locationInView:self];
		
		
        [self updateCurrentLocation:gesture];
        
        // tell us if we should scroll and which direction
        CGFloat scrollZoneHeight = 20;
        CGFloat bottomScrollBeginning = self.contentOffset.y + self.contentInset.top + rect.size.height - scrollZoneHeight;
        CGFloat topScrollBeginning = self.contentOffset.y + self.contentInset.top  + scrollZoneHeight;
        // we're in the bottom zone
        if (location.y >= bottomScrollBeginning) {
            self.scrollRate = (location.y - bottomScrollBeginning);
        } else if (location.y <= topScrollBeginning) {
            self.scrollRate = (location.y - topScrollBeginning); // we're in the top zone
        } else {
            self.scrollRate = 0;
        }
		
		
    } else if ([gesture ended]) {
		// dropped
		
		
		self.userInteractionEnabled = NO;
		
        NSIndexPath *indexPath = self.currentLocationIndexPath;
        
        // remove scrolling timer
        [self.scrollingTimer invalidate];
        self.scrollingTimer = nil;
        
        // animate the drag view to the newly hovered cell
        [UIView animateWithDuration:0.3 animations:^{
			
			CGRect rect = [self rectForRowAtIndexPath:indexPath];
			self.draggingView.transform = CGAffineTransformIdentity;
			self.draggingView.frame = CGRectOffset(self.draggingView.bounds, rect.origin.x, rect.origin.y);
			
		} completion:^(BOOL finished) {
			
			[self beginUpdates];
			[self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			[self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			[self.delegate tableView:self didFinishReorderingAtIndexPath:indexPath];
			[self endUpdates];
			
			// reload the rows that were affected just to be safe
			NSMutableArray *visibleRows = self.indexPathsForVisibleRows.mutableCopy;
			[visibleRows removeObject:indexPath];
			[self reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationNone];
			
			self.currentLocationIndexPath = nil;
			
			[UIView animateWithDuration:0.3f animations:^{
				self.draggingView.alpha = 0;
			}completion:^(BOOL finished){
				[self.draggingView removeFromSuperview];
				self.draggingView = nil;
				self.userInteractionEnabled = YES;
				
			}];
			
			
		}];
    }
}
- (void) updateCurrentLocation:(UILongPressGestureRecognizer *)gesture{
    
	// refresh index path
    CGPoint location = [gesture locationInView:self];
	NSIndexPath *indexPath  = [self indexPathForRowAtPoint:location];
	
	
	if(indexPath && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
		indexPath = [self.delegate tableView:self targetIndexPathForMoveFromRowAtIndexPath:self.currentLocationIndexPath toProposedIndexPath:indexPath];
	
    if (indexPath && ![indexPath isEqual:self.currentLocationIndexPath]) {
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[self.currentLocationIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.delegate tableView:self moveRowAtIndexPath:self.currentLocationIndexPath toIndexPath:indexPath];
        self.currentLocationIndexPath = indexPath;
        [self endUpdates];
    }
	
}
- (void) scrollTableWithCell:(NSTimer *)timer {
	
	
    UILongPressGestureRecognizer *gesture = timer.userInfo[@"gesture"];
    CGPoint location = [gesture locationInView:self];
    
    CGPoint currentOffset = self.contentOffset;
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + self.scrollRate);
	
    if (newOffset.y < -self.contentInset.top)
        newOffset.y = -self.contentInset.top;
	
	else if (self.contentSize.height < CGRectGetHeight(self.frame))
        newOffset = currentOffset;
	
	else if (newOffset.y > self.contentSize.height - CGRectGetHeight(self.frame))
        newOffset.y = self.contentSize.height - CGRectGetHeight(self.frame);
    
	
	self.contentOffset = newOffset;
    
    if (location.y >= 0 && location.y <= self.contentSize.height + 50)
        self.draggingView.center = CGPointMake(self.center.x, location.y);
    
    [self updateCurrentLocation:gesture];
	
}
- (void) cancelGesture {
    self.longPress.enabled = NO;
    self.longPress.enabled = YES;
}


#pragma mark Properties
- (void) setCanReorder:(BOOL)canReorder {
    _canReorder = canReorder;
    self.longPress.enabled = canReorder;
}
- (BOOL) isEmpty{
	BOOL empty = YES;
	NSInteger sections = self.numberOfSections;
    for(int i = 0; i < sections; i++){
		if([self numberOfRowsInSection:i] > 0){
			empty = NO;
			break;
		}
	}
	return empty;
}

@end
