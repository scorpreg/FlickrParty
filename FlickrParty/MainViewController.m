//
//  MainViewController.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 20/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView* topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [topBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topBar];

    UIImage* logoImage = [UIImage imageNamed:@"logo"];
    
    UIImageView* logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(topBar.frame.size.width/2-logoImage.size.width/2, topBar.frame.size.height/2-logoImage.size.height/2 , logoImage.size.width, logoImage.size.height)];
    [logoImageView setImage:logoImage];
    [topBar addSubview:logoImageView];
    
    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBar.frame.size.height-1, topBar.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7f]];
    [topBar addSubview:line];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
