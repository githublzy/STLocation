//
//  STPaoPaoView.m
//  STLocation
//
//  Created by 梁志云 on 16/6/23.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STPaoPaoView.h"
#import "STLocationModel.h"
#import "NSString+STFrame.h"

@interface STPaoPaoView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *navigationButton;

@property (nonatomic, strong) STLocationModel *locationModel;

@property (nonatomic, copy) STPaoPaoViewNavigationActionHandler actonHandler;

@end

@implementation STPaoPaoView

- (instancetype)initWithLocationModel:(STLocationModel *)locationModel
{
    self = [super init];
    if (self) {
        [self setLocationModel:locationModel];
        [self ST_initUserInterface];
    }
    return self;
}

- (void)setActionHandler:(STPaoPaoViewNavigationActionHandler) actionHandler
{
    _actonHandler = actionHandler;
}

- (void)ST_initUserInterface
{
    
    NSString *longString = [_locationModel.locationName length] > [_locationModel.locationAddress length]?_locationModel.locationName:_locationModel.locationAddress;
    
    CGSize titleSize = [_locationModel.locationName sizeWithFont:[UIFont systemFontOfSize:17.0] maxSize:CGSizeMake(200, MAXFLOAT)];
    
    CGSize size = [longString sizeWithFont:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(200, MAXFLOAT)];
    
    if (titleSize.width > size.width) {
        size.width = titleSize.width;
    }
    
    CGRect frame = CGRectMake(0, 0, size.width + 80, size.height + 80);
    [self setFrame:frame];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width, 20)];
    _titleLabel.textColor = [UIColor whiteColor];
    if ([self locationModel].locationName) {
        _titleLabel.text = [self locationModel].locationName;
    }
    else {
        _titleLabel.text = @"位置分享";
    }
    [self addSubview:_titleLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 6, size.width, size.height)];
    _addressLabel.font = [UIFont systemFontOfSize:13.0];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.text = [self locationModel].locationAddress;
    _addressLabel.numberOfLines = 2;
    [self addSubview:_addressLabel];
    
    frame.size.height = CGRectGetMaxY(_addressLabel.frame) + 30;
    [self setFrame:frame];
    
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 20)];
    [_backgroundView setBackgroundColor:[UIColor blackColor]];
    [_backgroundView setAlpha:0.7];
    [[_backgroundView layer] setCornerRadius:6.0];
    [_backgroundView setClipsToBounds:YES];
    [self addSubview:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 52, 6, 1, CGRectGetHeight(self.frame) - 6 * 2 - 20)];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    
    _navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationButton setFrame:CGRectMake(CGRectGetWidth(self.frame) - 51, 0, 51, CGRectGetHeight(self.frame) - 20)];
    [_navigationButton addTarget:self action:@selector(onClickedNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationButton setImage:[UIImage imageNamed:@"mapapi.bundle/custom/location_nav"] forState:UIControlStateNormal];
    [self addSubview:_navigationButton];
    
    UIImage *pointImage = [UIImage imageNamed:@"mapapi.bundle/custom/location_point.png"];
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 11, CGRectGetMaxY(_backgroundView.frame), 22.5, 14.)];
    pointImageView.image = pointImage;
    
    [self addSubview:pointImageView];
}

- (void)onClickedNavigationButton:(UIButton *)sender
{
    if ([self actonHandler]) {
        self.actonHandler();
    }
}

@end