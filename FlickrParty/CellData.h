//
//  CellData.h
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 21/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject

@property (nonatomic, strong) NSString* photoId;
@property (nonatomic, strong) NSString* ownerName, *title , *descriptionHtmlContent, *tags, *profilePictureURL ,*photoURL_small,*photoURL, *date;
@property float imageWidth_small, imageHeight_small;

- (void)fillWithData:(NSDictionary*)data;
@end
