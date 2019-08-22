//
//  STLocationGeoSearch.m
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationGeoSearch.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface STLocationGeoSearch () <BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;

@property (nonatomic, copy) STLocationGeoSearchCompletionHandler completionHandler;

@end

@implementation STLocationGeoSearch

+ (instancetype)search {
    return [[STLocationGeoSearch alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ST_initData];
    }
    return self;
}

- (void)ST_initData {
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
}

#pragma mark - 
- (void)reverseGeoCodeSearchWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(STLocationGeoSearchCompletionHandler)completionHandler {
    if (!_geoCodeSearch.delegate) {
        _geoCodeSearch.delegate = self;
    }
    
    if (!_reverseGeoCodeOption) {
        _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    }
    _reverseGeoCodeOption.reverseGeoPoint = coordinate;
    
    BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    if (flag) {
#if DEBUG
        NSLog(@"反geo检索发送成功");
#endif
    } else {
#if DEBUG
        NSLog(@"反geo检索发送成功");
#endif
    }
    _completionHandler = completionHandler;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    _geoCodeSearch.delegate = nil;
    
    if (error==0) {
        if ([result address]==nil || [@"" isEqualToString:[result address]]) {
            return;
        }
        if (_completionHandler) {
            _completionHandler(result);
        }
    }
}


@end
