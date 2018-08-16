//
//  AppDelegate+AppService.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "UserAccountManager.h"
#import "LoginController.h"

@implementation AppDelegate (AppService)


#pragma mark  初始化window
- (void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = WHITECOLOR;
    
//    if ([UserAccountManager sharedManager].isUserLogin){
        RootTabBarController *tabBarVc = [[RootTabBarController alloc]init];
        self.window.rootViewController = tabBarVc;
//    }else{
//        LoginController *loginVc = [LoginController new];
//        RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:loginVc];
//        self.window.rootViewController = nav;
//    }
    
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];

    
}


- (void)saveDataToLocal{
    [self loadAllExpertCondition];
}


- (void)loadAllExpertCondition{
    NSArray *urls = @[@"expert_hangye_list",@"expert_zizhi_list",@"expert_lingyu_list"];
    dispatch_group_t group = dispatch_group_create();

    NSMutableArray *industrys = [NSMutableArray array];
    NSMutableArray *qualifieds = [NSMutableArray array];
    NSMutableArray *skilleds = [NSMutableArray array];


    for (int i=0;i<urls.count;i++){
        NSString *urlStr = [OPENAPIHOST stringByAppendingFormat:@"member/index/%@",urls[i]];
        //进组
        dispatch_group_enter(group);
        [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:nil callback:^(NetworkResult resultCode, id responseObject) {
            if (resultCode != NetworkResultSuceess){
                DebugLog(@"%@", (NSString *)responseObject);
                return;  //出现错误,退出循环
            }else{
                //出组
                dispatch_group_leave(group);
                NSArray *nameFields = @[@"meh_name",@"mez_name",@"mel_name"];
                NSArray *idFields = @[@"meh_id",@"mez_id",@"mel_id"];
                for (NSDictionary *dict in responseObject){
                    NSNumber *idValue = dict[idFields[i]];
                    NSString *nameValue = dict[nameFields[i]];
                    NSDictionary *idNameDict = @{idValue:nameValue};
                    if (i==0){
                        [industrys addObject:idNameDict];
                    }else if (i == 1){
                        [qualifieds addObject:idNameDict];
                    }else{
                        [skilleds addObject:idNameDict];
                    }
                }
            }
        }];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSDictionary *allConditions = @{KEY_EXPERT_INDUSTRY:industrys,
                                        KEY_EXPERT_QUALIFIED:qualifieds,
                                        KEY_EXPERT_SKILLED:skilleds
                                        };
//        [allConditions addObject:@{KEY_EXPERT_INDUSTRY:industrys}];
//        [allConditions addObject:@{KEY_EXPERT_QUALIFIED:qualifieds}];
//        [allConditions addObject:@{KEY_EXPERT_SKILLED:skilleds}];

        //保存至 plist 文件
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"expertCondition.plist"];
        DebugLog(@"%@",plistPath);
        [allConditions writeToFile:plistPath atomically:YES];
    });

}


//- (void)handleResponseObject:(id)responseObject index:(int)i{
////    NSArray *titles = @[@"全部",@"全部",@"全部"];
//    //@[@"全部行业",@"全部资质",@"全部领域"];
////    NSMutableArray *conditionNameArray = [NSMutableArray arrayWithObject:titles[i]];
////    NSMutableArray *conditionIndexArray = [NSMutableArray arrayWithObject:@(0)];
//
//    for (NSDictionary *dict in responseObject){
//        //{1:行业1}
//        NSDictionary *idNameDict = @{idFields[i]:nameFields[i]};
//        if (i==0){
//            [industrys addObject:idNameDict];
//        }else if (i == 1){
//            [qualifieds addObject:idNameDict];
//        }else{
//            [qualifieds addObject:idNameDict];
//        }
////        [conditionNameArray addObject:dict[conditionNameFields[i]]];
////        [conditionIndexArray addObject:dict[indexFields[i]]];
//    }
//
////    //行业
////    if (i==0){
////        [USERDEFAULTS setObject:conditionNameArray forKey:USERDEFAULT_EXPERT_INDUSTRY];
////    //资质
////    }else if (i==1){
////        [USERDEFAULTS setObject:conditionNameArray forKey:USERDEFAULT_EXPERT_QUALIFIED];
////    //领域
////    }else{
////        [USERDEFAULTS setObject:conditionNameArray forKey:USERDEFAULT_EXPERT_SKILLED];
////    }
////    [USERDEFAULTS synchronize];
//
//}


- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


- (UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

@end
