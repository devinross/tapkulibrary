//
//  TKNumberInputView.h
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

#import "TKInputView.h"
@class TKInputKey;

@interface TKNumberInputView : TKInputView


- (id) initWithFrame:(CGRect)frame withKeysModels:(NSArray*)keys keypadFrame:(CGRect)padFrame;

@property (nonatomic,strong) TKInputKey *oneKey;
@property (nonatomic,strong) TKInputKey *twoKey;
@property (nonatomic,strong) TKInputKey *threeKey;
@property (nonatomic,strong) TKInputKey *fourKey;
@property (nonatomic,strong) TKInputKey *fiveKey;
@property (nonatomic,strong) TKInputKey *sixKey;
@property (nonatomic,strong) TKInputKey *sevenKey;
@property (nonatomic,strong) TKInputKey *eightKey;
@property (nonatomic,strong) TKInputKey *nineKey;
@property (nonatomic,strong) TKInputKey *zeroKey;


- (NSArray*) keypadKeys;

@end
