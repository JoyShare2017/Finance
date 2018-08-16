//
//  UIViewController+JudegLogin.m
//  Finance
//
//  Created by 赵帅 on 2018/4/17.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "UIViewController+JudegLogin.h"
#import "LoginController.h"
@implementation UIViewController (JudegLogin)
-(BOOL)judegLoginWithSuperVc:(UIViewController*)superVc{
    if ([UserAccountManager sharedManager].isUserLogin) {
        return YES;
    }else{
        [superVc.navigationController pushViewController:[LoginController new] animated:YES];
        return NO;
    }
    return NO;
}
-(BOOL)TestjudegLoginWithSuperVc:(UIViewController*)superVc andLoginSucceed:(void(^)(id obj))loginSuc{
    if ([UserAccountManager sharedManager].isUserLogin) {
        return YES;
    }else{
        LoginController*log=[LoginController new];
        log.loginSuc = ^(id obj) {
            loginSuc(@"");

        };
        [superVc.navigationController pushViewController:log animated:YES];
        return NO;
    }
    return NO;
}
@end
