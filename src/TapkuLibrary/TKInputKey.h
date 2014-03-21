//
//  TKInputKey.h
//  Created by Devin Ross on 3/21/14.
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

typedef enum {
	TKInputKeyTypeDefault = 0,
	TKInputKeyTypeDark = 1,
	TKInputKeyTypeHighlighted = 2
} TKInputKeyType;

@interface TKInputKey : UIView 

+ (id) keyWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner;

- (id) initWithFrame:(CGRect)frame symbol:(id)symbol normalType:(TKInputKeyType)normal selectedType:(TKInputKeyType)highlighted runner:(BOOL)runner;

@property (nonatomic,assign) TKInputKeyType normalType;
@property (nonatomic,assign) TKInputKeyType highlighedType;
@property (nonatomic,assign) BOOL runner;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *symbol;


- (void) setHighlighted:(BOOL)highlighted;

@end
