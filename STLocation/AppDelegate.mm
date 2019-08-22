//
//  AppDelegate.m
//  STLocation
//
//  Created by 梁志云 on 16/6/17.
//  Copyright © 2016年 梁志运. All rights reserved.
//

/**
 *  位置发送模块集成说明.支持ios7.0及以上版本
 *
 1、先申请百度地图SDK KEY http://developer.baidu.com/map/index.php?title=iossdk/guide/key
 
 2、把项目中的YSLocation（里面那个）目录拖进需集成的项目中
 
 3、设置一个.mm的文件或将Xcode的Project -> Edit Active Target -> Build -> GCC4.2 - Language -> Compile Sources As设置为"Objective-C++
 
 4、将所需的BaiduMapAPI_*.framework 添加到 TARGETS->Build Phases-> Link Binary With Libaries
 
 5、还需引入CoreLocation.framework和QuartzCore.framework、OpenGLES.framework、SystemConfiguration.framework、CoreGraphics.framework、Security.framework、libsqlite3.0.tbd（xcode7以前为 libsqlite3.0.dylib）、CoreTelephony.framework 、libstdc++.6.0.9.tbd（xcode7以前为libstdc++.6.0.9.dylib）。
 
 6、在TARGETS->Build Settings->Other Linker Flags 中添加-ObjC。
 （2到6步可参考 http://developer.baidu.com/map/index.php?title=iossdk/guide/buildproject）
 
 7、配置应用跳转URL，在Info配置页中的URL types 新增一条记录，并在初始化地图（YSMapManager）时配置上去
 
 8、使用方法可参考 ViewController.m  - (void)onClicked:(UIButton *)sender 这方法的具体实现
 
 */


#import "AppDelegate.h"
#import "STMapManager.h"

@interface AppDelegate () <BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    STMapManager *mapManager = [STMapManager sharedManager];
    [mapManager start:@"pW8gHebyHmBs6GSwxroyN7s4z5haNRcm" generalDelegate:self schemesURL:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - BMKGeneralDelegate
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"百度返回网络错误:%d", iError);
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"百度返回授权验证错误:%d", iError);
        //  如网络引超的授权失败需在网络恢复时重新授权一次
        //        // 要使用百度地图，请先启动BaiduMapManager
        //        BOOL ret = [[YSMapManager sharedManager] start:@"QQapOypj8H1CQOP3aQ8e5VeP" generalDelegate:self schemesURL:@"cloudsoar://com.cloudsoar.map"];
        //
        //        if (!ret) {
        //            NSLog(@"manager start failed!");
        //        }
    }
}


@end
