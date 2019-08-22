//
//  STLocationSendMapViewPresenter.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLocationSendModuleDelegate.h"

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

typedef void (^STLocationSendMapViewGeoSearchCompletionHandler)(id data);

@interface STLocationSendMapViewPresenter : NSObject<BMKLocationServiceDelegate, BMKMapViewDelegate, STLocationSendModuleDelegate>

- (void)setGeoSearchCompletionHandler:(STLocationSendMapViewGeoSearchCompletionHandler)completionHandler;

/* 持有外部视图弱引用 */
@property (nonatomic, weak) BMKMapView *mapView;

@end
