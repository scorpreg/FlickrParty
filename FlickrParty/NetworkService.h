//
//  NetworkService.h
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 20/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkService : NSObject
- (void)getFeedWithPage:(int)page completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;
@end
