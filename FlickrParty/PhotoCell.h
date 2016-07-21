//
//  PhotoCell.h
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 21/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellData.h"

@interface PhotoCell : UITableViewCell
- (void)fillWithData:(CellData*)data;
@end
