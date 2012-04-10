//
//  TKProgressBar.h
//  Created by Devin Ross on 4/29/10.
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

#import <UIKit/UIKit.h>

typedef enum {
	TKProgressBarViewStyleLong,
	TKProgressBarViewStyleShort
} TKProgressBarViewStyle;


/** A progress bar view. */
@interface TKProgressBarView : UIView {
	TKProgressBarViewStyle _style;
	float _progress,_displayProgress;
}

/**
 Initialize a progress bar.
 @param style The style of the progress bar.
 @return A progress bar or nil.
 */
- (id) initWithStyle:(TKProgressBarViewStyle)style;

/** The progress. */
@property (assign,nonatomic) float progress; // a value between 0.0 and 1.0


/**
 Sets the progress. Allows for animation of the progress meter. 
 @param progress The progress.
 @param animated Flag for animating the increase of the progress.
 */
- (void) setProgress:(float)progress animated:(BOOL)animated;

@end
