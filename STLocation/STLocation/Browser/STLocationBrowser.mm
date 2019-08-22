//
//  STLocationBrowser.m
//  STLocation
//
//  Created by 梁志云 on 16/6/23.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationBrowser.h"
#import "STLocationModel.h"
#import "STPaoPaoView.h"
#import "STMapManager.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

@interface STLocationBrowser ()<BMKLocationServiceDelegate, BMKMapViewDelegate, BMKAnnotation, UIActionSheetDelegate, BMKRouteSearchDelegate>

@property (nonatomic, strong) STLocationModel *locationModel;

@property (nonatomic, strong) BMKMapView* mapView;

@property (nonatomic, strong) BMKLocationService *locationService;

@property (nonatomic, strong) BMKPointAnnotation *locationAnnotation;

@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, strong) BMKRouteSearch *routesearch;

@end

@implementation STLocationBrowser

- (void)dealloc {
    if (_locationService) {
        _locationService = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    if (_locationAnnotation) {
        _locationAnnotation = nil;
    }
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_userLocation) {
        _userLocation = nil;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YS_initData];
    
    [self YS_initUserInterface];
}

- (void)YS_initUserInterface
{
    self.title = @"位置";
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    _mapView.centerCoordinate = _locationModel.coordinate;
    _mapView.zoomLevel = 16;
    
    _mapView.delegate = self;
    
    [[self view] addSubview:_mapView];
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"mapapi.bundle/custom/location_user.png"] forState:UIControlStateNormal];
    [locationButton setFrame:CGRectMake(CGRectGetWidth(_mapView.frame) - 37 - 20, CGRectGetMaxY(_mapView.frame) - 20 - 40, 37, 40)];
    [locationButton addTarget:self action:@selector(onClickedStartUserLaction:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:locationButton];
    
    _locationAnnotation = [[BMKPointAnnotation alloc] init];
    _locationAnnotation.coordinate = _locationModel.coordinate;
    _locationAnnotation.title = _locationModel.locationAddress;
    [_mapView addAnnotation:_locationAnnotation];
    [_mapView selectAnnotation:_locationAnnotation animated:YES];
};

- (void)YS_initData
{
    _locationService = [[BMKLocationService alloc] init];
    _routesearch = [[BMKRouteSearch alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithLocationModel:(STLocationModel *)locatonModel
{
    self = [super init];
    if (self) {
        _locationModel = locatonModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locationService.delegate = self;
    self.routesearch.delegate = self;
    [self startLocation:BMKUserTrackingModeNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.routesearch.delegate = nil;
    self.locationService.delegate = nil;
    [self stopLocation];
}

- (void)onClickedStartUserLaction:(UIButton *)sender
{
    [self startLocation:BMKUserTrackingModeFollow];
}

- (void)startLocation:(BMKUserTrackingMode)userTrackingMode
{
    [[self locationService] startUserLocationService];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = userTrackingMode;
    _mapView.zoomLevel = 16;
}

- (void)stopLocation
{
    if ([self locationService]) {
        [[self locationService] stopUserLocationService];
    }
    _mapView.showsUserLocation = NO;
}



#pragma mark - BMKLocationServiceDelegate
/**
 *  用户位置更新后，会调用此函数
 *  @param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self setUserLocation:userLocation];
    [_mapView updateLocationData:userLocation];
}

/**
 *  定位失败后，会调用此函数
 *  @param mapView 地图View
 *  param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
#if DEBUG
    NSLog(@"location error");
#endif
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"BMKPinAnnotationView";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorGreen;
        
        STPaoPaoView *paopaoView = [[STPaoPaoView alloc] initWithLocationModel:[self locationModel]];
        
        __weak typeof(self) weakSelf = self;
        
        [paopaoView setActionHandler:^() {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"导航到 %@", [[strongSelf locationModel] locationAddress] ] delegate:strongSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度地图",@"显示路线", nil];
            
            [actionSheet showInView:[strongSelf view]];
        }];
        
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
    }
    return annotationView;
}


- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.8];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        polylineView.lineWidth = 6.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self nativeNavi];
    }
    else if (buttonIndex == 1) {
        [self walkSearch];
    }
}

#pragma mark - 导航

- (void)nativeNavi
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化终点节点
    BMKPlanNode* endPlanNode = [[BMKPlanNode alloc]init];
    endPlanNode.pt = [self locationModel].coordinate;
    //指定终点名称
    endPlanNode.name = [self locationModel].locationName;
    //指定终点
    para.endPoint = endPlanNode;
    //指定返回自定义scheme
    para.appScheme = [[STMapManager sharedManager] schemesURL];
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
}

- (void)webNavi
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = [self userLocation].location.coordinate;
    //指定起点名称
    start.name = [self userLocation].title;
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = [self locationModel].coordinate;
    para.endPoint = end;
    //指定终点名称
    end.name = [self locationModel].locationName;
    if (!end.name) {
        end.name = [self locationModel].locationAddress;
    }
    para.appScheme = [[STMapManager sharedManager] schemesURL];
    //指定调启导航的app名称
    para.appName = @"testAppName";
    //调启web导航
    [BMKNavigation openBaiduMapNavigation:para];
}

- (void)walkSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = [self userLocation].location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = [self locationModel].coordinate;
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag) {
#if DEBUG
        NSLog(@"walk检索发送成功");
#endif
    } else {
#if DEBUG
        NSLog(@"walk检索发送失败");
#endif
    }
}

#pragma mark - BMKRouteSearchDelegate
/**
 * 返回步行搜索结果
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}


@end