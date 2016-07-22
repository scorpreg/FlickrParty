//
//  PhotoCell.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 21/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "PhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotoCell

- (void)fillWithData:(CellData*)data
{
    int photoWidth = [[UIScreen mainScreen] bounds].size.width;
    int photoHeight = data.imageHeight_small * (photoWidth / data.imageWidth_small);       
    
    UIImageView* photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photoWidth, photoHeight)];
    [self addSubview:photo];
    
    [photo  sd_setImageWithURL:[NSURL URLWithString:data.photoURL_small] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UIImageView* profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, photo.frame.size.height + 10, 30, 30)];
    [self addSubview:profilePicture];
    
    [profilePicture  sd_setImageWithURL:[NSURL URLWithString:data.profilePictureURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //Check is there a valid profile picture. If there is not, use default one.
        if (image == nil) {
            [profilePicture  sd_setImageWithURL:[NSURL URLWithString:@"https://www.flickr.com/images/buddyicon.gif"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [profilePicture setImage:[self maskImage:image withMask:[UIImage imageNamed:@"mask"]]];
            }];
        }else{
            //Masking with circle mask image
            [profilePicture setImage:[self maskImage:image withMask:[UIImage imageNamed:@"mask"]]];
        }
    }];
        
    
    UILabel* ownerNameLabel = [[UILabel alloc] init];
    [ownerNameLabel setText:data.ownerName];
    [ownerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14.0f]];
    [ownerNameLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0f]];
    [self addSubview:ownerNameLabel];
    [ownerNameLabel sizeToFit];
    [ownerNameLabel setFrame:CGRectMake(50, photo.frame.size.height + 10, ownerNameLabel.frame.size.width, 20)];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ownerNameLabel.frame.origin.x, ownerNameLabel.frame.origin.y + ownerNameLabel.frame.size.height, photoWidth - ownerNameLabel.frame.origin.x - 10, 20)];
    [titleLabel setText:data.title];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0f]];
    [titleLabel setNumberOfLines:2];
    [self addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    NSDateFormatter* receivedDateFormatter = [[NSDateFormatter alloc] init];
    [receivedDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* receivedDate = [receivedDateFormatter dateFromString:data.date];
    
    NSDateFormatter* showingDateFormatter = [[NSDateFormatter alloc] init];
    [showingDateFormatter setDateFormat:@"dd MMMM EEEE"];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ownerNameLabel.frame.origin.x + ownerNameLabel.frame.size.width + 5, ownerNameLabel.frame.origin.y, photoWidth - (ownerNameLabel.frame.origin.x + ownerNameLabel.frame.size.width + 10), 20)];
    [dateLabel setText:[NSString stringWithFormat:@"· %@",[showingDateFormatter stringFromDate:receivedDate]]];
    [dateLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:12.0f]];
    [dateLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0f]];
    [self addSubview:dateLabel];
    
    
    UIImageView* seperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, photoWidth, 50 - titleLabel.frame.size.height)];
    [seperator setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    [self addSubview:seperator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

@end
