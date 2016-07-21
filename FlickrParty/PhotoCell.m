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
    float photoWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIImageView* photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photoWidth, data.imageHeight_small * (photoWidth / data.imageWidth_small))];
    [self addSubview:photo];
    
    [photo  sd_setImageWithURL:[NSURL URLWithString:data.photoURL_small] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UIImageView* profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, photo.frame.size.height + 10, 40, 40)];
    [self addSubview:profilePicture];
    
    [profilePicture  sd_setImageWithURL:[NSURL URLWithString:data.profilePictureURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [profilePicture setImage:[self maskImage:image withMask:[UIImage imageNamed:@"mask"]]];
    }];
    
    UILabel* ownerNameLabel = [[UILabel alloc] init];
    [ownerNameLabel setText:data.ownerName];
    [ownerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14.0f]];
    [ownerNameLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0f]];
    [self addSubview:ownerNameLabel];
    [ownerNameLabel sizeToFit];
    [ownerNameLabel setFrame:CGRectMake(60, profilePicture.frame.origin.y, ownerNameLabel.frame.size.width, 20)];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ownerNameLabel.frame.origin.x, ownerNameLabel.frame.origin.y + ownerNameLabel.frame.size.height, photoWidth - ownerNameLabel.frame.origin.x - 10, 20)];
    [titleLabel setText:data.title];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0f]];
    [self addSubview:titleLabel];
    
    NSDateFormatter* receivedDateFormatter = [[NSDateFormatter alloc] init];
    [receivedDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* receivedDate = [receivedDateFormatter dateFromString:data.date];
    
    NSDateFormatter* showingDateFormatter = [[NSDateFormatter alloc] init];
    [showingDateFormatter setDateFormat:@"dd MMMM EEEE"];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ownerNameLabel.frame.origin.x + ownerNameLabel.frame.size.width + 5, ownerNameLabel.frame.origin.y, photoWidth - (ownerNameLabel.frame.origin.x + ownerNameLabel.frame.size.width + 10), 20)];
    [dateLabel setText:[NSString stringWithFormat:@"· %@",[showingDateFormatter stringFromDate:receivedDate]]];
    [dateLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
    [dateLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0f]];
    [self addSubview:dateLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
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
