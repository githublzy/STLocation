//
//  STLocationAddressCell.m
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationAddressCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#define STLocatonAPPWidth [UIScreen mainScreen].applicationFrame.size.width
#define STLocatonAPPHigth [UIScreen mainScreen].applicationFrame.size.higth

@interface STLocationAddressCell ()

/// 标题名.
@property (nonatomic, strong) UILabel *titleLabel;
/// 详细地址.
@property (nonatomic, strong) UILabel *addressLabel;
/// 选择图片.
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation STLocationAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self YS_initUserInterface];
    }
    return self;
}

- (void)YS_initUserInterface {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, STLocatonAPPWidth - 10 * 2, CGRectGetHeight(self.frame) / 2)];
    _titleLabel.font = [UIFont systemFontOfSize:16.];
    _titleLabel.textColor = [UIColor blackColor];
    [[self contentView] addSubview:_titleLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame))];
    _addressLabel.font = [UIFont systemFontOfSize:13.0];
    _addressLabel.textColor = [UIColor grayColor];
    [[self contentView] addSubview:_addressLabel];
    
    _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(STLocatonAPPWidth - 10 - 12.5, (CGRectGetHeight(self.frame) - 10 ) / 2, 12.5, 10)];
    [[self contentView] addSubview:_selectedImageView];
}

- (void)refreshCellWithPoiInfo:(BMKPoiInfo *)poiInfo isSelected:(BOOL)isSelected {
    _titleLabel.text = [poiInfo name];
    _addressLabel.text = [poiInfo address];
    if (isSelected) {
        _selectedImageView.image = [UIImage imageNamed:@"mapapi.bundle/custom/location_selected.png"];
//        _titleLabel.textColor = [UIColor colorWithRed:68./255 green:181./255 blue:4./255 alpha:1];
//        _addressLabel.textColor = [UIColor colorWithRed:68./255 green:181./255 blue:4./255 alpha:1];
        _titleLabel.textColor = [UIColor colorWithRed:47./255. green:178./255. blue:242./255. alpha:1.];
        _addressLabel.textColor = [UIColor colorWithRed:47./255. green:178./255. blue:242./255. alpha:1.];
    } else {
        _titleLabel.textColor = [UIColor blackColor];
        _addressLabel.textColor = [UIColor grayColor];
        _selectedImageView.image = nil;
    }
}

@end
