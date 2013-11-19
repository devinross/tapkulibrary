//
//  UIFont+TKCategory.m
//  Created by Devin Ross on 10/5/13.
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

#import "UIFont+TKCategory.h"

@implementation UIFont (TKCategory)

#pragma mark Helvetica Neue
+ (UIFont*) helveticaNeueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue" size:size];
}
+ (UIFont*) helveticaNeueBoldItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size];
}
+ (UIFont*) helveticaNeueLightWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+ (UIFont*) helveticaNeueItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}
+ (UIFont*) helveticaNeueUltraLightItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:size];
}
+ (UIFont*) helveticaNeueCondensedBoldWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
}
+ (UIFont*) helveticaNeueMediumItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:size];
}
+ (UIFont*) helveticaNeueMediumWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}
+ (UIFont*) helveticaNeueThinItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Thin_Italic" size:size];
}
+ (UIFont*) helveticaNeueThinWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}
+ (UIFont*) helveticaNeueLightItalicWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:size];
}
+ (UIFont*) helveticaNeueUltraLightWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}
+ (UIFont*) helveticaNeueBoldWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}
+ (UIFont*) helveticaNeueCondensedBlackWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:size];
}


#pragma mark Avenir
+ (UIFont*) avenirHeavyWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Heavy" size:size];
}
+ (UIFont*) avenirObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Oblique" size:size];
}
+ (UIFont*) avenirBlackWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Black" size:size];
}
+ (UIFont*) avenirBookWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Book" size:size];
}
+ (UIFont*) avenirBlackObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-BlackOblique" size:size];
}
+ (UIFont*) avenirHeavyObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-HeavyOblique" size:size];
}
+ (UIFont*) avenirLightWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Light" size:size];
}
+ (UIFont*) avenirMediumObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-MediumOblique" size:size];
}
+ (UIFont*) avenirMediumWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Medium" size:size];
}
+ (UIFont*) avenirLightObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-LightOblique" size:size];
}
+ (UIFont*) avenirRomanWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-Roman" size:size];
}
+ (UIFont*) avenirBookObliqueWithSize:(CGFloat)size{
	return [UIFont fontWithName:@"Avenir-BookOblique" size:size];
}


@end