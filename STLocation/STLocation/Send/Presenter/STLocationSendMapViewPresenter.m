//
//  STLocationSendMapViewPresenter.m
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationSendMapViewPresenter.h"
#import "STLocationGeoSearch.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface STLocationSendMapViewPresenter ()

@property (nonatomic, strong) BMKLocationService *locationService;

@property (nonatomic, strong) STLocationGeoSearch *geoSearch;

@property (nonatomic, assign) CLLocationCoordinate2D searchCoordinate;

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, copy) STLocationSendMapViewGeoSearchCompletionHandler geoSearchCompletionHandler;

@property (nonatomic, assign, getter=isSelectPoiRefresh) BOOL selectPoiRefresh;

@end

@implementation STLocationSendMapViewPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ST_initData];
    }
    return self;
}

- (void)ST_initData {
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
}

- (void)setMapView:(BMKMapView *)mapView {
    mapView.delegate = self;
    _mapView = mapView;
}

#pragma mark - BMKLocationServiceDelegate
/**
 *  用户位置更新后，此函数会被调用
 *  @param userLocation 用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
}

/**
 *  定位失败后，会调用此函数
 *
 *  @param error 错误
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"Location error");
}



#pragma mark - BMKMapViwDelegate
/**
 *  地图区域改变时调用此函数
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    CLLocationCoordinate2D coordinate = [mapView centerCoordinate];
    
    if (!(coordinate.latitude - [self centerCoordinate].latitude > -0.000001
          && coordinate.latitude - [self centerCoordinate].latitude < 0.000001
          && coordinate.longitude - [self centerCoordinate].longitude > -0.000001
          && coordinate.longitude - [self centerCoordinate].longitude < 0.000001)) {
        
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        self.centerCoordinate = coordinate;
        
        if (![self isSelectPoiRefresh]) {
            [self reverseGeoCode:[self centerCoordinate]];
        }
    }
    
    [self setSelectPoiRefresh:NO];
}

- (void)reverseGeoCode:(CLLocationCoordinate2D)coordinate {
    if (![self geoSearch]) {
        _geoSearch = [STLocationGeoSearch search];
    }
    
    _searchCoordinate = coordinate;
    __weak typeof(self) weakSelf = self;
    
    [self.geoSearch reverseGeoCodeSearchWithCoordinate:coordinate completion:^(id data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult *)data;
        BMKAddressComponent *addressDetail = [result addressDetail];
        BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
        
        poiInfo.name = @"[位置]";
        poiInfo.address = result.address;
        poiInfo.pt = result.location;
        poiInfo.city = addressDetail.city;
        
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        [resultArray addObject:poiInfo];
        [resultArray addObjectsFromArray:[result poiList]];
        
        if ([strongSelf geoSearchCompletionHandler]) {
            strongSelf.geoSearchCompletionHandler(resultArray);
        }
    }];
}

#pragma mark - STLocationSendModuleDelegate
/**
 *  刷新中点坐标
 */
- (void)locationRefreshCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated refreshPosition:(BOOL)refresh {
    
    if (!refresh) {
        self.selectPoiRefresh = YES;
    }
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

/**
 *  将要显示
 */
- (void)locationViewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self startLocation];
}

/**
 *  将要消失
 */
- (void)locationViewWillDisappear {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    [self stopLocation];
}

/**
 *  返回当前中心经纬度
 */
- (CLLocationCoordinate2D)locationCenterCoordinate {
    return [self.mapView centerCoordinate];
}

- (void)startLocation {
    [self.locationService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
}

- (void)stopLocation {
    if (self.locationService) {
        [self.locationService stopUserLocationService];
    }
    _mapView.showsUserLocation = NO;
}


@end
