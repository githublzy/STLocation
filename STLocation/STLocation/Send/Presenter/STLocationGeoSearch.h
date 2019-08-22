//
//  STLocationGeoSearch.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef  void(^STLocationGeoSearchCompletionHandler)(id data);

@interface STLocationGeoSearch : NSObject

/**
 *  快速实例
 *
 *  @return 实例
 */
+ (instancetype)search;

/**
 *  Geo搜索方法
 *
 *  @param coordinate        位置坐标
 *  @param completionHandler 结果回调
 */
- (void)reverseGeoCodeSearchWithCoordinate:(CLLocationCoordinate2D)coordinate completion:(STLocationGeoSearchCompletionHandler)completionHandler;

@end
