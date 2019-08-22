//
//  STLocationSendMapView.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMapView;
typedef void(^STLocationSendMapViewActionBlock)();

@interface STLocationSendMapView : UIView

/* 地图实例 */
@property (nonatomic, strong, readonly) BMKMapView *mapView;

/**
 *  初始化方法
 *
 *  @param frame       位置大小
 *  @param actionBlock 点击定位按钮回调
 *
 *  @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame actionHandler:(STLocationSendMapViewActionBlock)actionBlock;

@end
