
###iOS端配置
####APP_KEY配置
在Flutter工程下的ios/Runner/Info.plist文件中配置appKey键值对，如下：
```xml
<key>com.openinstall.APP_KEY</key>
<string>openinstall 分配给应用的 appkey</string>
```
####以下为 一键拉起 功能相关配置和代码
#####universal links相关配置

* 开启Associated Domains服务

对于iOS，为确保能正常跳转，AppID必须开启Associated Domains功能，请到[苹果开发者网站](https://developer.apple.com/ "苹果开发者网站")，选择Certificate, Identifiers & Profiles，选择相应的AppID，开启Associated Domains。注意：当AppID重新编辑过之后，需要更新相应的mobileprovision证书。(图文配置步骤请看[iOS集成指南](https://www.openinstall.io/doc/ios_sdk.html "iOS集成指南"))。

* 配置universal links关联域名（iOS 9以后推荐使用）

关联域名(Associated Domains) 的值请在openinstall控制台获取（openinstall应用控制台->iOS集成->iOS应用配置）

该文件是给iOS平台配置的文件，在ios/Runner目录下创建文件名为Runner.entitlements的文件，Runner.entitlements内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key><!--固定key值-->
    <array>
        <!--这里换成你在openinstall后台的关联域名(Associated Domains)-->
        <string>applinks:xxxxxx.openinstall.io</string>
    </array>
</dict>
</plist>
```

* 在 ios/Runner/AppDelegate.m 中添加通用链接（Universal Link）回调方法，委托插件来处理：

在头部引入
```objective-c
#import <openinstall_flutter_plugin/OpeninstallFlutterPlugin.h>

```
添加如下方法
```objective-c
//添加此方法以获取拉起参数
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpeninstallFlutterPlugin continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}
```

#####scheme配置
在ios/Runner/Info.plist文件中，在CFBundleURLTypes数组中添加应用对应的scheme，或者在工程“TARGETS -> Info -> URL Types”里快速添加，图文配置请看[iOS集成指南](https://www.openinstall.io/doc/ios_sdk.html "iOS集成指南")
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>openinstall</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>"从openinstall官网后台获取应用的scheme"</string>
        </array>
    </dict>
</array>
```

在ios/Runner/AppDelegate.m中头部引入：
```objective-c
#import <openinstall_flutter_plugin/OpeninstallFlutterPlugin.h>

```
在 ios/Runner/AppDelegate.m 中添加方法：
```objective-c
//适用目前所有iOS版本
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //判断是否通过OpenInstall URL Scheme 唤起App
    if([OpeninstallFlutterPlugin handLinkURL:url]){//必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}
//iOS9以上，会优先走这个方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options{
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpeninstallFlutterPlugin handLinkURL:url]){//必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}
```
