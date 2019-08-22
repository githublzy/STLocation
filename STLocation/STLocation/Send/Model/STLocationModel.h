//
//  STLocationModel.h
//  STLocation
//
//  Created by 梁志云 on 16/6/17.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface STLocationModel : NSObject

/* 地点名 */
@property (nonatomic, copy) NSString *locationName;
/* 详细地址 */
@property (nonatomic, copy) NSString *locationAddress;
/* 经纬坐标 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/* 缩略图 */
@property (nonatomic, strong) UIImage *posterImage;

@end
