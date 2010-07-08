//
//  ImageCenterViewController.m
//  Created by Devin Ross on 4/16/10.
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

#import "ImageCenterViewController.h"


@implementation ImageCenterViewController


#pragma mark -
#pragma mark Initialization



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.rowHeight = 120;
	
	urlArray = [[NSArray arrayWithObjects:
				 @"http://farm3.static.flickr.com/2797/4196552800_a5de0f3627_t.jpg",
				 @"http://farm3.static.flickr.com/2380/2417672368_a41257399f_t.jpg",
				 @"http://farm3.static.flickr.com/2063/2181373837_b32a7e36fd_t.jpg",
				 @"http://farm4.static.flickr.com/3018/2458286264_8e5bae7ec3_t.jpg",
				 @"http://farm4.static.flickr.com/3236/2779325398_80347b2c6f_t.jpg",
				 @"http://farm4.static.flickr.com/3629/3459136258_885598f06a_t.jpg",
				 @"http://farm4.static.flickr.com/3619/3308615215_63752b7b27_t.jpg",
				 @"http://farm4.static.flickr.com/3379/3337846702_4c3f21ecdb_t.jpg",
				 @"http://farm1.static.flickr.com/3/2451788_febcdb12f6_t.jpg",
				 @"http://farm4.static.flickr.com/3559/3681486285_2d92961aec_t.jpg",
				 @"http://farm4.static.flickr.com/3630/3681486481_8f864b67a5_t.jpg",
				 @"http://farm3.static.flickr.com/2626/3682301814_1fe5081448_t.jpg",
				 @"http://farm3.static.flickr.com/2655/3951923344_d2bb111a50_t.jpg",
				 @"http://farm4.static.flickr.com/3229/2723469734_8eeec4e2e4_t.jpg",
				 @"http://farm4.static.flickr.com/3664/3660136156_dbf8852267_t.jpg",
				 @"http://farm4.static.flickr.com/3369/3659337053_180878a026_t.jpg",
				 nil] retain];
			  
	images = [[NSMutableArray alloc] init];
	for(int i=0;i<[urlArray count] * 3;i++){
		[images addObject:[NSNull null]];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved) name:@"newImage" object:nil];
	
}


- (void) newImageRetrieved{
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [urlArray count] * 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    

	cell.textLabel.text = [NSString stringWithFormat:@"Cell %d",indexPath.row];
	int i = indexPath.row;
	
	if([images objectAtIndex:i] != [NSNull null]) cell.imageView.image = [images objectAtIndex:i];
	else{
		
		int index = i % [urlArray count];
		
		UIImage *image = [[TKImageCenter sharedImageCenter]  imageAtURL:[NSURL URLWithString:[urlArray objectAtIndex:index]] 
														  queueIfNeeded:YES];
		
		if(image != nil){
			[images replaceObjectAtIndex:i withObject:image];
			cell.imageView.image = image;
		}else{
			cell.imageView.image = nil;
		}
		
	}
    
    return cell;
}





- (void)dealloc {
    [super dealloc];
}


@end

