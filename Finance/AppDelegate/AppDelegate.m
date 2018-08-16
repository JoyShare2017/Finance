//
//  AppDelegate.m
//  CommonProject
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//  20180713 zs修改bug 导航栏底下没有线了最直观

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initWindow];

    
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:KUMeng_APPID];
    [self configUSharePlatforms];
    [self confitUShareSettings];
  
    [self saveDataToLocal];
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    [WXApi registerApp:@"wx8d9ac9748812ef16" enableMTA:YES];
    return YES;
}
-(void)onResp:(BaseResp*)resp{
    NSLog(@"appdelegate resp %d",resp.errCode);
    if (resp.errCode==0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KPayResultKey object:@"1"];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:KPayResultKey object:@"0"];
    }
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;

    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

}

- (void)configUSharePlatforms
{

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KWEICHAT_APPID appSecret:KWEICHAT_SECRET redirectURL:nil];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KQQLOGIN_APPID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:KWEIBOLOGIN_APPID  appSecret:KWEIBOLOGIN_APPSECRET redirectURL:@"https://api.weibo.com/oauth2/default.html"];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            
            //跳转支付宝钱包进行支付，处理支付结果
            
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
                NSLog(@"result = %@",resultDic);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:KPayResultKey object:@"1"];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:KPayResultKey object:@"0"];
                }
            }];
            
        }else if ([url.host isEqualToString:@"pay"]) {
            //微信支付结果
            [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
