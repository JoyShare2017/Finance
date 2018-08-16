//
//  LoginController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "ForgetPasswordController.h"
#import "UserAccountManager.h"
#import "RootTabBarController.h"


@interface LoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end

@implementation LoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    _phoneTf.delegate = self;
    _passwordTf.delegate = self;
    _passwordTf.secureTextEntry = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


- (IBAction)isHidePasswordAction:(UIButton *)sender {
    _passwordTf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}


- (IBAction)loginAction:(id)sender {
    [self showHudInView:self.view hint:@""];
    /* 接口：member/index/login
     参数：
     @param  string  user_name         * 登录账号
     @param  string  user_pass        * 登录密码   */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/login"];
    NSDictionary *parameter = @{@"user_name": self.phoneTf.text,
                                @"user_pass": self.passwordTf.text};
    
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters: parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            
        }else{
            [self showHint:@"登录成功"];
            
            //保存用户数据
            [UserAccountManager sharedManager].userAccount = [UserAccount mj_objectWithKeyValues:responseObject];
            [UserAccountManager sharedManager].userAccount.isUserAcountLogin=@"1";
            [[UserAccountManager sharedManager] saveAccount];
            
//            [UIApplication sharedApplication].keyWindow.rootViewController = [RootTabBarController new];
            if (self.loginSuc) {
                self.loginSuc(@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
            [KCommonNetRequest getMyInfoDetailAndComplete:^(BOOL success, id obj) {

            }];
        }
    }];
}


- (IBAction)registerAction:(id)sender {
    RegisterController *vc = [RegisterController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)forgetPasswordAction:(id)sender {
    ForgetPasswordController *vc = [ForgetPasswordController new];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
