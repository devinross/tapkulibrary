//
//  UIImageView+TKCategory.h
//  Created by Devin Ross on 12/12/10.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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


@import UIKit;

/** Additional functionality for `UIImageView`.  */
@interface UIImageView (TKCategory)

/** Returns a image view with an image of the given image name.
 @param imageName The name of the image to create the imagename with.
 @return Returns `UIImageView` object.
 */
+ (UIImageView*) imageViewWithImageNamed:(NSString*)imageName;

/** Returns a image view with the given frame.
 @param frame The frame of the view.
 @return Returns `UIImageView` object.
 */
+ (UIImageView*) imageViewWithFrame:(CGRect)frame;

@end
