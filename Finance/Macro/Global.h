//
//  Global.h
//  CommonProject
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#ifndef Global_h
#define Global_h


#ifdef DEBUG
#define DebugLog(...) NSLog(@"-------%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DebugLog(...)
#endif

//#define OPENAPIHOST @"http://192.168.2.250:8012/"  //本地地址
#define OPENAPIHOST @"http://caisou.emof.net/" //线上地址

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define KEY_EXPERT_INDUSTRY @"expertIndustryKey" //行业
#define KEY_EXPERT_QUALIFIED  @"expertQualifiedKey" //资质
#define KEY_EXPERT_SKILLED  @"expertSkilledKey" //擅长领域

/// 友盟 appkey
#define KUMeng_APPID @"5ad58c96f43e484c9c000270"
/// QQ分享
#define KQQLOGIN_APPID @"101470265"
#define KQQLOGIN_APPKEY @"585c6148875db4892f7ca20b7c6a1885"

/// 微信
#define KWEICHAT_APPID @"wx8d9ac9748812ef16"
#define KWEICHAT_SECRET @"5938ef5e29efb33abb6324d05adc8eba"

/// 微博

#define KWEIBOLOGIN_APPID @"2496248294"
#define KWEIBOLOGIN_APPSECRET @"4b147fd49ecf3352b96fa8a58be1e6e4"

//软件版本
#define KSOFTVERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]
////行业
//#define USERDEFAULT_EXPERT_INDUSTRY @"expertIndustryUserDefault"
////资质
//#define USERDEFAULT_EXPERT_QUALIFIED  @"expertQualifiedUserDefault"
////擅长领域
//#define USERDEFAULT_EXPERT_SKILLED  @"expertSkilledUserDefault"

#define KPayResultKey @"payresult"


#endif /* Global_h */
