//
//  NetworkService.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 20/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "NetworkService.h"
#import <AFNetworking/AFNetworking.h>

NSString * const apiURL = @"https://api.flickr.com/services/rest/";
NSString * const apiKey = @"59022a7698ebae38ddce0970a247accd";

@implementation NetworkService 


- (void)getFeedWithPage:(int)page completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSDictionary *parameters = @{
                                 @"api_key": apiKey,
                                 @"method": @"flickr.photos.search",
                                 @"tags": @"party",
                                 @"format": @"json",
                                 @"page":[NSNumber numberWithInt:page],
                                 @"per_page":@10,
                                 @"extras": @"owner_name,date_taken,url_z,url_o,url_l,description,tags,icon_server",
                                 };
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:apiURL parameters:parameters error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {                
        
        if (error) {
            
            completionHandler(nil,error);
            
        } else {
            
            id pureJSON = [self extractJsonFromData:responseObject];
            completionHandler(pureJSON,error);
            
        }
    }];
    [dataTask resume];
}

- (id)extractJsonFromData:(NSData*)data
{
    NSString* stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    stringData = [stringData stringByReplacingOccurrencesOfString:@"jsonFlickrApi(" withString:@""];
    stringData = [stringData substringToIndex:[stringData length] - 1];
    
    return [NSJSONSerialization JSONObjectWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}


@end
