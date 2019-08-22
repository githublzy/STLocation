//
//  STLocationAddressCell.h
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKPoiInfo;

@interface STLocationAddressCell : UITableViewCell

- (void)refreshCellWithPoiInfo:(BMKPoiInfo *)poiInfo isSelected:(BOOL)isSelected;

@end
