//
//  STLocationSendMapView.m
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationSendMapView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface STLocationSendMapView ()

@property (nonatomic, strong) BMKMapView* mapView;

@property (nonatomic, copy) STLocationSendMapViewActionBlock actionBlock;

@end

@implementation STLocationSendMapView

- (instancetype)initWithFrame:(CGRect)frame actionHandler:(STLocationSendMapViewActionBlock)actionBlock {
    self = [super initWithFrame:frame];
    if (self) {
        _actionBlock = actionBlock;
        [self ST_initUserInterface];
    }
    return self;
}

- (void)ST_initUserInterface {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height / 2.55)];
    _mapView.zoomLevel = 16;
    
    [self addSubview:_mapView];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"mapapi" ofType:@"bundle"];
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:@"images/pin_red.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    pointImageView.center = CGPointMake(CGRectGetWidth(_mapView.frame) / 2, CGRectGetHeight(_mapView.frame) / 2 - CGRectGetHeight(pointImageView.frame) / 2);
    pointImageView.image = image;
    [self addSubview:pointImageView];
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"mapapi.bundle/custom/location_user.png"] forState:UIControlStateNormal];
    [locationButton setFrame:CGRectMake(CGRectGetWidth(_mapView.frame) - 30 - 10, CGRectGetMaxY(_mapView.frame) - 10 - 30, 30, 30)];
    [locationButton addTarget:self action:@selector(onClickedLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locationButton];
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4)];
    shadowImageView.image = [UIImage imageNamed:@"mapapi.bundle/custom/location_shadow.png"];
    [self addSubview:shadowImageView];
}

- (void)onClickedLocationButton:(UIButton *)sender {
    if ([self actionBlock]) {
        self.actionBlock();
    }
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end