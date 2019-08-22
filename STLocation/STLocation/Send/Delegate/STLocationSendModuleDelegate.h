//
//  STLocationSendModuleDelegate.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol STLocationSendModuleDelegate <NSObject>

/**
 *  刷新中点坐标
 *
 *  @param coordinate 坐标
 *  @param animated   是否动画
 *  @param refresh    是否刷新poi列表
 */
- (void)locationRefreshCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated refreshPoiList:(BOOL)refresh;

/**
 *  将要显示生命周期
 */
- (void)locationViewWillAppear;

/**
 *  将要消失生命周期
 */
- (void)locationViewWillDisappear;

/**
 *  获取当前的中心经纬度
 *
 *  @return 经纬度
 */
- (CLLocationCoordinate2D)locationCenterCoordinate;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  停止定位
 */
- (void)stopLocation;


@end
