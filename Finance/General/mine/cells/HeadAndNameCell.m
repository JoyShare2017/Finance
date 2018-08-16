//
//  HeadAndNameCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "HeadAndNameCell.h"
#import "LoginController.h"
#import "MyDetailInfoVC.h"
#import "UIButton+WebCache.h"
@implementation HeadAndNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    self.backgroundColor=MAJORCOLOR;
    self.headBtn=[[UBButton alloc]initWithFrame:CGRectMake(20, 15, 60, 60)];
    [self.headBtn setImage:[UIImage imageNamed:@"touxiang"] forState:(UIControlStateNormal)];
    self.headBtn.layer.cornerRadius=self.headBtn.frame.size.height*0.5;
    self.headBtn.layer.masksToBounds=YES;
    __weak typeof(self) weakSelf = self;

    [self.headBtn addAction:^(UBButton *button) {
        if ([UserAccountManager sharedManager].isUserLogin) {
            MyDetailInfoVC*detail=[MyDetailInfoVC new];
            detail.didChangedMyInfo = ^(id obj) {
                [weakSelf layoutSubviews];
            };
            [[weakSelf viewController].navigationController pushViewController:detail animated:YES];
        }
    }];
    [self addSubview:self.headBtn];

    self.loginBtn=[[UBButton alloc]initWithFrame:CGRectMake(90, 30, 60, 30)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addAction:^(UBButton *button) {
        if (![UserAccountManager sharedManager].isUserLogin) {
            [weakSelf.superVc.navigationController pushViewController:[LoginController new] animated:YES];
        }
    }];
    [self addSubview:self.loginBtn];

//    self.exitBtn=[[UBButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 40, 40)];
//    [self.exitBtn setImage:[UIImage imageNamed:@"tuichu"] forState:(UIControlStateNormal)];
//    [self.exitBtn addAction:^(UBButton *button) {
//        if ([UserAccountManager sharedManager].isUserLogin) {
//            [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"确定退出账号?" CancelTitle:@"取消" ConfirmTitle:@"确认" message:@"" cancelBlock:^(id obj) {
//
//            } confirmBlock:^(id obj) {
//                [[UserAccountManager sharedManager] deleteAccount];
//                [weakSelf layoutSubviews];
//            }];
//        }
//    }];
//    [self addSubview:self.exitBtn];

    self.nameLb=[[UILabel alloc]initWithFrame:CGRectMake(90, 15, SCREEN_WIDTH-140, 30)];
    self.nameLb.textColor=[UIColor darkGrayColor];
    self.nameLb.font=[UIFont systemFontOfSize:17];
    [self addSubview:self.nameLb];

    self.qianminglb=[[UILabel alloc]initWithFrame:CGRectMake(90, 45, SCREEN_WIDTH-100, 30)];
    self.qianminglb.textColor=[UIColor darkGrayColor];
    self.qianminglb.font=[UIFont systemFontOfSize:17];
    [self addSubview:self.qianminglb];



}



- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);

    return nil;
}
-(void)alertWithString:(NSString *)string{

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertC addAction:otherAction];
    //    [self presentViewController:alertC animated:YES completion:nil];


}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.loginBtn.hidden=[UserAccountManager sharedManager].isUserLogin;
//    self.exitBtn.hidden=![UserAccountManager sharedManager].isUserLogin;
    self.nameLb.hidden=![UserAccountManager sharedManager].isUserLogin;
    self.qianminglb.hidden=![UserAccountManager sharedManager].isUserLogin;

    self.nameLb.text=[UserAccountManager sharedManager].userAccount.user_nick_name;
    self.qianminglb.text=[UserAccountManager sharedManager].userAccount.user_qianming;
    NSURL*fullHeadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",OPENAPIHOST,[UserAccountManager sharedManager].userAccount.user_image]];
    [self.headBtn sd_setImageWithURL:fullHeadUrl forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"touxiang"]];
    //    [self.headerImage setContentMode:(UIViewContentModeScaleToFill)];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
