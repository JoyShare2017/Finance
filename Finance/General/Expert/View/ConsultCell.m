//
//  ConsultCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/15.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ConsultCell.h"
#import "ExpertConsultListController.h"
#import "AppointExpertVC.h"
#import "AlphaAlertView.h"
#import "RegExpManager.h"
#define cell_height 90

@interface ConsultCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *priceLabel;

@end


@implementation ConsultCell

- (void)setConsultModel:(ConsultModel *)consultModel{
    _consultModel=consultModel;
    ConsultModel *model = consultModel;
    self.nameLabel.text = model.mes_name;
//    self.priceLabel.text=[NSString stringWithFormat:@"¥%@/%@",model.mes_price,model.mes_unit];
    self.button.selected=[model.mes_state isEqualToString:@"99"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI{
    CGSize lSize = CGSizeMake(80, 50);
    self.nameLabel = [UILabel labelWithFrame:CGRectMake(MARGIN, (cell_height-lSize.height)/2, lSize.width, lSize.height) textFont:FONT_BIG textColor:BLACKCOLOR];
    self.nameLabel.font=[UIFont boldSystemFontOfSize:FONT_BIG.pointSize];
//    self.nameLabel.backgroundColor = GRAYCOLOR_TEXT;
//    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];

//    self.priceLabel = [UILabel labelWithFrame:CGRectMake(MARGIN+CGRectGetMaxX(_nameLabel.frame)+MARGIN, (cell_height-lSize.height)/2, lSize.width, lSize.height) textFont:FONT_NORMAL textColor:MAJORCOLOR];
//    [self.contentView addSubview:self.priceLabel];


    CGSize size = CGSizeMake(70, 40);
    CGRect frame = CGRectMake(SCREEN_WIDTH-size.width-MARGIN, (cell_height-size.height)/2, size.width, size.height);
    self.button = [UIButton buttonWithFrame:frame title:@"约专家" font:FONT_NORMAL titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"consult:"];
    self.button.layer.cornerRadius=5;
    self.button.layer.masksToBounds=YES;
    self.button.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [self.button setTitle:@"约专家" forState:(UIControlStateSelected)];
    [self.button setTitle:@"暂未开通" forState:(UIControlStateNormal)];
    [self.button setBackgroundImage:[UIImage imageWithColor:GRAYCOLOR_BACKGROUND_DEEP size:size] forState:(UIControlStateNormal)];
    [self.button setBackgroundImage:[UIImage imageWithColor:MAJORCOLOR size:size] forState:(UIControlStateSelected)];

    [self.contentView addSubview:self.button];
    
    UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, cell_height-1, SCREEN_WIDTH-MARGIN*2, 1)];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
    
}


- (void)consult:(UIButton*)btn{
    if (![self.superVC judegLoginWithSuperVc:self.superVC]){
        return;
    }
    __block typeof(self) weakSelf=self;
    if (btn.selected) {
        //弹出页面
        AlphaAlertView*alp =[[AlphaAlertView alloc]initWithNoAccessAndSupervc:self.superVC];
        [[UIApplication sharedApplication].keyWindow addSubview:alp];
        __block AlphaAlertView* weakAlp =alp;
        alp.confirmBlock = ^(NSString *name, NSString *phone, NSString *text) {
            if (name.length==0) {
                [self.superVC showHint:@"请输入姓名"];
                return ;
            }
            if (phone.length==0) {
                [self.superVC showHint:@"请输入手机号"];
                return ;
            }
            if (![RegExpManager valiMobile:phone]) {
                [self.superVC showHint:@"请输入正确的手机号"];
                return ;
            }
            if (text.length==0) {
                [self.superVC showHint:@"请输入描述"];
                return ;
            }
            NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/member_add_expert_consult"];
            UserAccount *user = [UserAccountManager sharedManager].userAccount;
            NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                        @"user_name":user.user_name,
                                        @"expert_user_id":self.expertuserid,
                                        @"server_name":self.consultModel.mes_name,
                                        @"price":self.consultModel.mes_price,
                                        @"unit":self.consultModel.mes_unit,
                                        @"xingming":name,
                                        @"dianhua":phone,
                                        @"wentimiaoshu":text,
                                        };
            [self.superVC showHudInView:weakAlp];
            [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
                [self.superVC hideHud];
                if (resultCode==NetworkResultSuceess) {
                    [weakAlp removeFromSuperview];
                    AlphaAlertView*alp =[[AlphaAlertView alloc]initCommonAlertWithSupervc:weakSelf.superVC andTitle:@"提交成功" andContent:@"您的信息已提交成功\n请耐心等待专家回复" andCancelBtnTitle:@"好的" andConfirmBlock:^(id obj) {
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:alp];
                } else {
                    [self.superVC showHint:(NSString *)responseObject];
                }
            }];
        };
//        if ([self.consultModel.mes_id isEqualToString:@"3"]) {
//            [self.superVC.navigationController pushViewController:[AppointExpertVC new] animated:YES];
//        }else{
//            [self creatConsult];
//        }
    }
}

- (void)creatConsult{
    [self.superVC showHudInView:self.superVC.view];
    /*接口：index/add_member_consult
     参数：
     @param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  int         expert_user_id        * 专家的id，专家主键
     @param  string  server_name    * 咨询的服务名称
     @param  string  price        咨询价格，默认0。
     @param  string  unit        咨询单位，默认‘次’。*/
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/add_member_consult"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;

    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"expert_user_id":@([self.expertuserid integerValue]),
                                @"server_name":self.consultModel.mes_name,
                                @"price":self.consultModel.mes_price,
                                @"unit":self.consultModel.mes_unit
                                };
    __weak typeof(self) weakSelf = self;

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [weakSelf.superVC hideHud];

        if (resultCode == NetworkResultSuceess){
            NSString* consultOrderId = [NSString stringWithFormat:@"%@",responseObject];
            ExpertConsultListController*consult=[ExpertConsultListController new];
            consult.zixunId=consultOrderId;
            consult.severName=self.consultModel.mes_name;
            [weakSelf.superVC.navigationController pushViewController:consult animated:YES];
        }else{
            return;
        }
    }];
}




@end
