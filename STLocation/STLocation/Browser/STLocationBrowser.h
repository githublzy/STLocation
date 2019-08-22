//
//  STLocationBrowser.h
//  STLocation
//
//  Created by 梁志云 on 16/6/23.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有头文件

@class STLocationModel;

@interface STLocationBrowser : UIViewController

/**
 *  初始化方法
 *
 *  @param locationModel 位置模型
 *
 *  @return 实例
 */
- (instancetype)initWithLocationModel:(STLocationModel *)locationModel;



@end
