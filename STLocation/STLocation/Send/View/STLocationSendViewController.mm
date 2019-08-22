//
//  STLocationSendViewController.m
//  STLocation
//
//  Created by 梁志云 on 16/6/17.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationSendViewController.h"
#import "STLocationModel.h"
#import "STLocationSendTableViewPresenter.h"
#import "STLocationAddressCell.h"
#import "STLocationSendMapViewPresenter.h"
#import "STLocationSendMapView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


@interface STLocationSendViewController () <STLocationSendModuleDelegate>

@property (nonatomic, copy) STLocationSendCompletionHandler completionHandler;

@property (nonatomic, strong) STLocationModel *locationModel;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) STLocationSendTableViewPresenter *tableViewPresenter;

@property (nonatomic, strong) STLocationSendMapViewPresenter *mapViewPresenter;

@property (nonatomic, strong) UITableView *addressTableView;

@property (nonatomic, strong) NSArray *poiInfos;

@property (nonatomic, strong) UIView *contentontainer;

@end

@implementation STLocationSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YS_initData];
    
    [self YS_initPresenter];
    
    [self YS_initNavigationBar];
    
    [self YS_initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[self moduleDelegate] respondsToSelector:@selector(locationViewWillAppear)]) {
        [[self moduleDelegate] locationViewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[self moduleDelegate] respondsToSelector:@selector(locationViewWillDisappear)]) {
        [[self moduleDelegate] locationViewWillDisappear];
    }
}

- (void)setSendCompletion:(STLocationSendCompletionHandler)completionHandler
{
    if (completionHandler) {
        _completionHandler = completionHandler;
    }
}

- (void)YS_initData
{
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _locationModel = [[STLocationModel alloc] init];
}

- (void)YS_initPresenter
{
    __weak typeof(self) weakSelf = self;
    
    _tableViewPresenter = [[STLocationSendTableViewPresenter alloc] initWithPoiInfoArray:[self poiInfos] cellIdentifier:@"STLocatonAddressCell" configureCellBlock:^(STLocationAddressCell *communicationCell, BMKPoiInfo *poiInfo, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [communicationCell refreshCellWithPoiInfo:poiInfo isSelected:([strongSelf selectedIndexPath].row == indexPath.row?YES:NO)];
        
    } selectedBlock:^(BMKPoiInfo *poiInfo, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setSelectedIndexPath:indexPath];
        if ([[strongSelf moduleDelegate] respondsToSelector:@selector(locationRefreshCenterCoordinate:animated:refreshPoiList:)]) {
            [[strongSelf moduleDelegate] locationRefreshCenterCoordinate:poiInfo.pt animated:YES refreshPoiList:NO];
        }
    }];
    
    _mapViewPresenter = [[STLocationSendMapViewPresenter alloc] init];
    [_mapViewPresenter setGeoSearchCompletionHandler:^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf setPoiInfos:data];
        [[strongSelf tableViewPresenter] setPoiInfos:data];
        [[strongSelf addressTableView] reloadData];
    }];
    [self setModuleDelegate:_mapViewPresenter];
}

- (void)YS_initNavigationBar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 36, 24)];
    [[rightButton titleLabel] setFont:[UIFont systemFontOfSize:16.]];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTag:1];
    [rightButton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 36, 24)];
    [[leftButton titleLabel] setFont:[UIFont systemFontOfSize:16.]];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTag:0];
    [leftButton addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    
    if ([[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleLightContent) {
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)YS_initUserInterface
{
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    self.title = @"位置";
    
    _contentontainer = [[UIView alloc] initWithFrame:self.view.frame];
    [[self view] addSubview:_contentontainer];
    
    UIView *sendSearchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    __weak typeof(self) weakSelf = self;
    STLocationSendMapView *sendMapView = [[STLocationSendMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sendSearchBar.frame), [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height / 2.55) actionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [[strongSelf moduleDelegate] startLocation];
        
    }];
    [[self mapViewPresenter] setMapView:sendMapView.mapView];
    
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sendMapView.frame), [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - CGRectGetHeight(sendMapView.frame) - CGRectGetHeight(sendSearchBar.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame))];
    _addressTableView.delegate = [self tableViewPresenter];
    _addressTableView.dataSource = [self tableViewPresenter];
    
    [_contentontainer addSubview:sendSearchBar];
    [_contentontainer addSubview:sendMapView];
    [_contentontainer addSubview:_addressTableView];
    [_contentontainer bringSubviewToFront:sendSearchBar];
}

- (void)onClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        if ([self completionHandler]) {
            self.completionHandler(nil);
        }
    }
    else if (sender.tag == 1) {
        
        if (self.selectedIndexPath.row < [[self poiInfos] count]) {
            BMKPoiInfo *poiInfo = [self poiInfos][self.selectedIndexPath.row];
            
            [[self locationModel] setLocationAddress:[poiInfo address]];
            [[self locationModel] setCoordinate:[poiInfo pt]];
            [[self locationModel] setPosterImage:[[[self mapViewPresenter] mapView] takeSnapshot]];
            
            if ([@"[位置]" isEqualToString:[poiInfo name]]) {
                [[self locationModel] setLocationName:@"位置分享"];
            }
            else {
                [[self locationModel] setLocationName:[poiInfo name]];
            }
        }
        
        if ([self completionHandler]) {
            self.completionHandler([self locationModel]);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end