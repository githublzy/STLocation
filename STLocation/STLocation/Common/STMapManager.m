//
//  STMapManager.m
//  STLocation
//
//  Created by 梁志云 on 16/6/20.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STMapManager.h"

@interface STMapManager ()

@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, copy) NSString * schemesURL;

@end

@implementation STMapManager

+ (instancetype)sharedManager {
    static STMapManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[STMapManager alloc] init];
    });
    return _manager;
}

- (BOOL)start:(NSString *)key generalDelegate:(id<BMKGeneralDelegate>)delegate schemesURL:(NSString *)urlString {
    _schemesURL = urlString;
    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:key generalDelegate:delegate];
    
    if (!ret) {
#if DEBUG
        NSLog(@"manager start failed!");
#endif
    }
    return ret;
}


@end
