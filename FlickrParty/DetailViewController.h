//
//  DetailViewController.h
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 22/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellData.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) CellData* detailedData;

@end
