//
//  STLocationSendTableViewPresenter.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class STLocationAddressCell;
@class BMKPoiInfo;

typedef void (^STLocationSendCellConfigureBlock)(STLocationAddressCell *communicationCell, BMKPoiInfo *poiInfo, NSIndexPath *indexPath);

typedef void (^STLocationSendTableViewSelectedBlock)(BMKPoiInfo *poiInfo, NSIndexPath *indexPath);

@interface STLocationSendTableViewPresenter : NSObject <UITableViewDelegate, UITableViewDataSource>

/* 聊天室实体数组 */
@property (nonatomic, copy) NSArray *poiInfos;

/**
 *  初始化方法
 *
 *  @param poiInfoArray       列表数据
 *  @param cellIdentifier     实例组标识
 *  @param cellConfigureBlock 配置Cell的回调
 *  @param selectedBlock      选中回调
 *
 *  @return 实例
 */
- (instancetype)initWithPoiInfoArray:(NSArray *)poiInfoArray
                      cellIdentifier:(NSString *)cellIdentifier
                  configureCellBlock:(STLocationSendCellConfigureBlock)cellConfigureBlock
                       selectedBlock:(STLocationSendTableViewSelectedBlock)selectedBlock;

@end
