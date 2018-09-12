//
//  RegisterController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "RegisterController.h"
#import "RegExpManager.h"
@interface RegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *verifyTf;



@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTf;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerRunCount;
@property(nonatomic,copy)NSString* yazhengma;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    _yazhengma=@"";
    _passwordTf.secureTextEntry = YES;
}


- (IBAction)sendVerifyCodeAction:(id)sender {
    if (_phoneTf.text.length==0) {
        [self showHint:_phoneTf.placeholder];
        return;
    }
    self.sendbtn.userInteractionEnabled=NO;
    [self showHudInView:self.view];

  /* 接口：member/index/send_phone_code
     参数：00
     @param  string  phoneNum    * 手机号 */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/send_phone_code"];
    NSDictionary *parameter = @{@"phoneNum": self.phoneTf.text};
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        _yazhengma=@"";
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            self.sendbtn.userInteractionEnabled=YES;
        }else{
            self.timerRunCount=60;
            self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
            [self.timer fire];
            [self showHint:@"验证码已发送到手机上"];
            _yazhengma=[NSString stringWithFormat:@"%@",responseObject[@"phonecode"]];

        }
        
    }];
    
}
-(void)timerRun:(NSTimer*)timer{
    self.timerRunCount--;
    [self.sendbtn setTitle:[NSString stringWithFormat:@"%zds",self.timerRunCount] forState:(UIControlStateNormal)];
    if (self.timerRunCount<=0) {
        [self.sendbtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        self.sendbtn.userInteractionEnabled=YES;
        [timer invalidate];

    }


}
- (IBAction)isHidePasswordAction:(UIButton *)sender {
    _passwordTf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}

- (IBAction)seeAgainPwd:(UIButton *)sender {
    _passwordAgainTf.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}


- (IBAction)isReadRegisterProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (IBAction)lookRegisterProtocol:(id)sender {
    [self loadRegisterProtocol];
}


- (void)loadRegisterProtocol{
    
    UIViewController *vc = [UIViewController new];
    vc.title = @"用户注册协议";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:vc.view.frame];
    [vc.view addSubview:webView];
    
    [self showHudInView:vc.view hint:@""];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/agreement"];
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:nil callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            [webView loadHTMLString:responseObject[@"agreement_content"] baseURL:nil];
        }
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)registerAction:(id)sender {
    if (_phoneTf.text.length==0) {
        [self showHint:_phoneTf.placeholder];
        return;
    }
    if (_verifyTf.text.length==0) {
        [self showHint:_verifyTf.placeholder];
        return;
    }
    if (_passwordTf.text.length==0) {
        [self showHint:_passwordTf.placeholder];
        return;
    }
    if (_passwordAgainTf.text.length==0) {
        [self showHint:_passwordAgainTf.placeholder];
        return;
    }
    if (![_verifyTf.text isEqualToString:_yazhengma]) {
        [self showHint:@"验证码不正确,请重新输入"];
        return;
    }
    if (![_passwordAgainTf.text isEqualToString:_passwordTf.text]) {
        [self showHint:@"两次密码不一致,请重新输入"];
        return;
    }
//    if (![RegExpManager validatePassword:_passwordAgainTf.text]) {
//        [self showHint:@"密码不合法,请重新输入"];
//        return;
//    }
    
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/register"];
    /*@param  user_name         * 登录账号
     @param  string  user_phone   * 用户手机号
     @param  string  user_pass        * 登录密码*/
    NSDictionary *parameter = @{@"user_name":self.phoneTf.text,
                               @"user_phone":self.phoneTf.text,
                               @"user_pass":self.passwordTf.text
                                };

    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            [self showHint:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

@end
