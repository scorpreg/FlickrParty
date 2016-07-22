//
//  DetailViewController.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 22/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "DetailViewController.h"
#import <PureLayout/PureLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@property (nonatomic, strong) UIScrollView *imageScroll;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DetailViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    [self.view addSubview:self.topBar];    
    [self.view addSubview:self.imageScroll];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.tagsLabel];
    
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)updateViewConstraints
{
    // Check a flag didSetupConstraints before creating constraints, because this method may be called multiple times, and we
    // only want to create these constraints once. Without this check, the same constraints could be added multiple times,
    
    if (!self.didSetupConstraints) {
      
        [self.topBar autoPinToTopLayoutGuideOfViewController:self withInset:0.0f];
        [self.topBar autoSetDimension:ALDimensionHeight toSize:44.0f];
        [self.topBar autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
        
        [self.logoImageView autoCenterInSuperview];

        // Text resizing
        [self.tagsLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        // Position the multi-line label at the bottom of the screen, with some insets
        [self.tagsLabel autoPinToBottomLayoutGuideOfViewController:self withInset:70.0f];
        [self.tagsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0f];
        [self.tagsLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20.0f];
        
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark - UI objects


- (UILabel *)tagsLabel
{
    if (!_tagsLabel) {
        _tagsLabel = [UILabel newAutoLayoutView];
        [_tagsLabel setText:_detailedData.tags];
        [_tagsLabel setTextAlignment:NSTextAlignmentCenter];
        [_tagsLabel setFont:[UIFont fontWithName:@"OpenSans" size:14.0f]];
        [_tagsLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
        [_tagsLabel setNumberOfLines:0];
        [_tagsLabel sizeToFit];
    }
    return _tagsLabel;
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView newAutoLayoutView];
        [_topBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topLine"]]];
        
        self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        [self.topBar addSubview:self.logoImageView];
    }
    return _topBar;
}

- (UIButton*)closeButton
{
    if (!_closeButton) {
        UIImage* closeButtonImage = [UIImage imageNamed:@"closeButton"];
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-closeButtonImage.size.width/2, [[UIScreen mainScreen] bounds].size.height-60, closeButtonImage.size.width, closeButtonImage.size.height)];
        [_closeButton setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - Scroll Zooming

- (UIScrollView*)imageScroll
{
    if (!_imageScroll) {
        
        _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
        [_imageScroll setBackgroundColor:[UIColor blackColor]];
        [_imageScroll setDelegate:self];
        
        self.photoImageView = [[UIImageView alloc] init];
        [_imageScroll addSubview:self.photoImageView];
        
        [self.photoImageView  sd_setImageWithURL:[NSURL URLWithString:_detailedData.photoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.photoImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [self.photoImageView setImage:image];
            _imageScroll.contentSize = image.size;
            
            CGFloat scaleWidth = _imageScroll.frame.size.width / _imageScroll.contentSize.width;
            CGFloat scaleHeight = _imageScroll.frame.size.height / _imageScroll.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            _imageScroll.minimumZoomScale = minScale;
            _imageScroll.maximumZoomScale = 1.0;
            _imageScroll.zoomScale = minScale;
            
            [self centerScrollViewContents];
        }];
     
    }
    return _imageScroll;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = _imageScroll.bounds.size;
    CGRect contentsFrame = self.photoImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    contentsFrame.origin.y = 0.0f;
    
    self.photoImageView.frame = contentsFrame;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.photoImageView;
}

- (void)closeButtonClicked:(UIButton*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
