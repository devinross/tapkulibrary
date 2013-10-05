//
//  TKImageCache.h
//  Created by Devin Ross on 8/29/11.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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


@class TKNetworkQueue,TKHTTPRequest;

/** An `TKImageCache` object provides a way to manage images between the network, disk and `NSCache`. */
@interface TKImageCache : NSCache 

///-------------------------
/// @name Initializing An Image Cache Object
///-------------------------

/** Initialize a new image cache object.
 @return A new created `TKImageCache` object.
 */
- (id) init;

/** Initialize a new image cache object.
 @param cacheDirectoryName The name of the folder to place cached images to disk.
 @return A new created `TKImageCache` object.
 */
- (id) initWithCacheDirectoryName:(NSString*)cacheDirectoryName;


///-------------------------
/// @name Properties
///-------------------------

/** Shows network activity monitor in status bar when network requests are created. */
@property BOOL shouldNetworkActivity;

/** The queue that manages all network requests for images */
@property (nonatomic,strong) TKNetworkQueue *imagesQueue;

/** The directory where images are stored on disk */
@property (nonatomic,copy) NSString *cacheDirectoryName;

/** The notification name posted to `NSNotificationCenter` */
@property (nonatomic,copy) NSString *notificationName;

/** The threshold of time images on disk need to be created before to be read from disk. Otherwise the images will be requested from the network again. The time needs to be greater than zero to for the creation date to be check. Default is -1. */
@property (nonatomic,assign) NSTimeInterval timeTillRefreshCache;


///-------------------------
/// @name Getting an image
///-------------------------

/** Returns an image if cached or properly routes requests to grab the image from disk or network.
 @param key The key corresponding to a specific image.
 @param url The URL to grab the image data from the network.
 @param queueIfNeeded If the image is not on disk or in cache, a network request will be create to grab the image data.
 @return Returns an `UIImage` object if the image is in `NSCache`.
 */
- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded;


/** Returns an image if cached or properly routes requests to grab the image from disk or network.
 @param key The key corresponding to a specific image.
 @param url The URL to grab the image data from the network.
 @param queueIfNeeded If the image is not on disk or in cache, a network request will be create to grab the image data.
 @param tag A tag to associate the image with the rest of your application.
 @return Returns an `UIImage` object if the image is in `NSCache`.
 */
- (UIImage*) imageForKey:(NSString*)key url:(NSURL*)url queueIfNeeded:(BOOL)queueIfNeeded tag:(NSUInteger)tag;


/** Grabs an image object directly from disk.
 @param key The key corresponding to a specific image..
 @return Returns an unadjusted `UIImage` object direct from disk.
 */
- (UIImage*) cachedImageForKey:(NSString*)key;

/** Checks to see if an image exists in cache or on disk for the given key.
 @param key The key corresponding to a specific image.
 @return Returns YES is the image corresponding to the key exists on disk or in NSCache, otherwise NO.
 */
- (BOOL) imageExistsWithKey:(NSString *)key;



///-------------------------
/// @name Managing images and requests.
///-------------------------

/** Cancel all image requests */
- (void) cancelOperations;

/** Remove an image request for a specific key
 @param key The key corresponding to a specific image.
 */
- (void) removeRequestForKey:(NSString*)key;

/** Clears local cache and remove all images from disk */
- (void) clearCachedImages;

/** Remove all images from disk that we're create earlier than a certain time
 @param time The time for which all images files must be created before to remain on disk.
 */
- (void) removeCachedImagesFromDiskOlderThanTime:(NSTimeInterval)time;


///-------------------------
/// @name For subclassing
///-------------------------
/** The directory where images are stored on disk.
 @return A `NSString` with the location to store images.
 */
- (NSString *) cacheDirectoryPath; // for subclassing


/** Perform image adjustments before storing it in local cache.
 
 @param image The image received from disk or the network.
 @return The adjusted image.
 */
- (UIImage*) adjustImageRecieved:(UIImage*)image;

@end

