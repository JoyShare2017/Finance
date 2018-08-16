//
//  ForgetPasswordController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ForgetPasswordController.h"

@interface ForgetPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *verifyTf;
@property (weak, nonatomic) IBOutlet UITextField *lastestPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTf;

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    _lastestPasswordTf.secureTextEntry = YES;
    _confirmPasswordTf.secureTextEntry = YES;
}


- (IBAction)sendVerifyCodeAction:(id)sender {
    [self showHint:@"验证码已发送到手机上"];
    /* 接口：member/index/send_phone_code
     参数：
     @param  string  phoneNum    * 手机号 */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/send_phone_code"];
    NSDictionary *parameter = @{@"phoneNum": self.phoneTf.text};
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            [self showHint:[NSString stringWithFormat:@"您的验证码是%@",responseObject[@"phonecode"]]];
            DebugLog(@"验证码是: %@",responseObject);
        }
        
    }];
}

- (IBAction)isHideLastestPasswordAction:(UIButton *)sender {
    _lastestPasswordTf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;

}


- (IBAction)isHideConfirmPasswordAction:(UIButton *)sender {
    _confirmPasswordTf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}


- (IBAction)resetPasswordAction:(id)sender {
  /* 接口：member/index/forget_password
     参数：
     @param     string        user_name        * 用户名（只传这个值，会发短信到该账号）
     @param    string        phone_code         * 手机验证码
     @param    string        new_password    * 新密码
     @param    string        rnew_password    * 重复新密码   */
   NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/forget_password"];
    NSDictionary *parameter = @{@"user_name":self.phoneTf.text,
                                @"phone_code":self.verifyTf.text,
                                @"new_password":self.lastestPasswordTf.text,
                                @"rnew_password":self.confirmPasswordTf.text
                                };
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            [self showHint:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}

@end
