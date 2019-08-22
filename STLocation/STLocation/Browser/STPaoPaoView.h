//
//  STPaoPaoView.h
//  STLocation
//
//  Created by 梁志云 on 16/6/23.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STLocationModel;

typedef void (^STPaoPaoViewNavigationActionHandler)();

@interface STPaoPaoView : UIView

/**
 *  初始化方法
 *
 *  @param loactionModel 位置模型
 *
 *  @return 实例
 */
- (instancetype)initWithLocationModel:(STLocationModel *)locationModel;

/**
 *  设置导航按钮回调Block
 *
 *  @param actionHandler 回调
 */
- (void)setActionHandler:(STPaoPaoViewNavigationActionHandler)actionHandler;

@end
