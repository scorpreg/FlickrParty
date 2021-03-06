//
//  CellData.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 21/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "CellData.h"

@implementation CellData

- (void)fillWithData:(NSDictionary*)data
{
    self.photoId = [data objectForKey:@"id"];
    self.ownerName = [data objectForKey:@"ownername"];
    self.title = [data objectForKey:@"title"];
    self.tags = [data objectForKey:@"tags"];
    self.date = [data objectForKey:@"datetaken"];
    self.profilePictureURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg",[data objectForKey:@"iconfarm"],[data objectForKey:@"iconserver"],[data objectForKey:@"owner"]];
    self.descriptionHtmlContent = [data valueForKeyPath:@"description.content"];
    self.photoURL_small = [data objectForKey:@"url_z"];
    self.imageWidth_small = [[data objectForKey:@"width_z"] floatValue];
    self.imageHeight_small = [[data objectForKey:@"height_z"] floatValue];
    
    if([data objectForKey:@"url_l"])
        self.photoURL = [data objectForKey:@"url_l"];
    else
        self.photoURL = [data objectForKey:@"url_z"];    
}

@end
