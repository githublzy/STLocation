//
//  STMapManager.h
//  STLocation
//
//  Created by 梁志云 on 16/6/20.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface STMapManager : NSObject

/**
 *  地图管理单例.
 *
 *  @return 实例.
 */
+ (instancetype)sharedManager;

/**
 *  @brief  当前应用跳转URL.
 */
@property (nonatomic, copy, readonly) NSString * schemesURL;

/**
 *  启动引擎
 *
 *  @param key       申请的有效Key
 *  @param delegate  代理者
 *  @param urlString 应用跳转URL
 *
 *  @return 实例
 */
- (BOOL)start:(NSString *)key generalDelegate:(id<BMKGeneralDelegate>)delegate schemesURL:(NSString *)urlString;

@end
