//
//  NSStringAddition.h
//  Created by Devin Ross on 10/26/09.
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

@import Foundation;

/** Additional functionality for `NSString`.  */
@interface NSString (TKCategory)


/** Returns `YES` if a string is a valid email address, otherwise `NO`. 
 @return True if the string is formatted properly as an email address.
 */
- (BOOL) isEmail;

/** Returns a `NSString` that is URL friendly. 
 @return A URL encoded string.
 */
- (NSString*) URLEncode;

/** Returns a `NSString` that properly replaces HTML specific character sequences. 
 @return An escaped HTML string.
 */
- (NSString *) escapeHTML;

/** Returns a `NSString` that properly formats text for HTML. 
 @return An unescaped HTML string.
 */
- (NSString *) unescapeHTML;

/** Returns a `NSString` that removes HTML elements. 
 @return Returns a string without the HTML elements. 
 */
- (NSString*) stringByRemovingHTML;

/** Returns an MD5 string of from the given `NSString`. 
 @return A MD5 string.
 */
- (NSString *) md5sum;

/** Returns `YES` is a string has the substring, otherwise `NO`. 
 @param substring The substring.
 @return `YES` if the substring is contained in the string, otherwise `NO`.
 */
- (BOOL) hasString:(NSString*)substring;



- (NSString*) formattedPhoneNumberWithLastCharacterRemoved:(BOOL)deleteLastChar;


@end
