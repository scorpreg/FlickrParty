//
//  MainViewController.m
//  FlickrParty
//
//  Created by Ahmet Faruk Birinci on 20/07/16.
//  Copyright © 2016 afb. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkService.h"
#import "PhotoCell.h"
#import "CellData.h"
#import <PureLayout/PureLayout.h>

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray* feedArray;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIImageView *logoImageView, *topLine;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property int page, totalPage;

@end

@implementation MainViewController

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];

    [self.view addSubview:self.topBar];
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.tableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.feedArray = [[NSMutableArray alloc] init];
    [self getFeedElements];
}

- (void)getFeedElements
{
    [[NetworkService alloc] getFeedWithPage:self.page completionHandler:^(id responseObject, NSError *error) {
        //Get feed objects from flicker API, then add the feedArray
        [self.feedArray addObjectsFromArray:[responseObject valueForKeyPath:@"photos.photo"]];
        
        self.totalPage = [[responseObject valueForKeyPath:@"photos.pages"] intValue];
        [self.tableView reloadData];
        
        //If refresh control is alive, then finish it.
        if(self.refreshControl)
        [self.refreshControl endRefreshing];
    }];
}

- (void)refreshData
{
    self.page = 1;
    self.feedArray = [[NSMutableArray alloc] init];
    [self getFeedElements];
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

        [self.topLine autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
        [self.topLine autoSetDimension:ALDimensionHeight toSize:1.0f];
        [self.topLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBar];
        
        [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topLine withOffset:0];
        [self.tableView autoSetDimension:ALDimensionWidth toSize:[[UIScreen mainScreen] bounds].size.width];
        [self.tableView autoSetDimension:ALDimensionHeight toSize:[[UIScreen mainScreen] bounds].size.height - self.tableView.frame.origin.y - 60];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView newAutoLayoutView];
        [_topBar setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

        self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        [self.topBar addSubview:self.logoImageView];
    }
    return _topBar;
}

- (UIImageView*)topLine
{
    if (!_topLine) {
        //Tiny little line
        _topLine = [UIImageView newAutoLayoutView];
        [_topLine setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f]];        
    }
    return _topLine;
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView newAutoLayoutView];
        [_tableView setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        //Pull to refresh object
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor colorWithRed:0.3 green:0.4 blue:0.6 alpha:1.0f];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        
    }
    return _tableView;
}

#pragma mark - UITableView Delegate/Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)[indexPath indexAtPosition: [indexPath length] - 1];
    
    NSDictionary* rowData = [self.feedArray objectAtIndex:index];
    
    //Detecting every cell height
    float totalHeight = 70;
    float imageHeight =  [[rowData objectForKey:@"height_z"] floatValue]*([[UIScreen mainScreen] bounds].size.width / [[rowData objectForKey:@"width_z"] floatValue]);
    
    return totalHeight + imageHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)[indexPath indexAtPosition: [indexPath length] - 1];
    
    //Convert JSON data to CellData
    CellData* data = [[CellData alloc] init];
    [data fillWithData:[self.feedArray objectAtIndex:index]];
    
    //Create cell with CellData
    PhotoCell* cell = [[PhotoCell alloc] init];
    [cell fillWithData:data];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Paging control mechanism
    if (indexPath.row>self.feedArray.count-2 && self.page<self.totalPage) {
        self.page += 1;
        [self getFeedElements];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
