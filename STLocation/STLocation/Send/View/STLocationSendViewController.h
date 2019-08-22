//
//  STLocationSendViewController.h
//  STLocation
//
//  Created by 梁志云 on 16/6/17.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import "STLocationSendModuleDelegate.h"

@class STLocationModel;

/* 发送位置后的回调 */
typedef void (^STLocationSendCompletionHandler)(STLocationModel *locationModel);

@interface STLocationSendViewController : UIViewController

/* 模块总代理 */
@property (nonatomic, weak) id <STLocationSendModuleDelegate> moduleDelegate;

/* 对应的视图控制器 */
@property (nonatomic, strong, readonly) UIView *contentontainer;

/**
 *  设置发送位置选择完成时回调
 *
 *  @param completionHandler 完成回调
 */
- (void)setSendCompletion:(STLocationSendCompletionHandler)completionHandler;

@end
