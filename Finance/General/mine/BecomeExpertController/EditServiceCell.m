//
//  EditServiceCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/20.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "EditServiceCell.h"

@interface EditServiceCell()
@property (nonatomic, strong) UILabel *serviceNameLB;

@property (nonatomic, strong) UBButton *editBtn;

@end
@implementation EditServiceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    self.serviceNameLB=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 35)];
    self.serviceNameLB.font=[UIFont systemFontOfSize:16];
    self.serviceNameLB.backgroundColor=[UIColor colorWithHexString:@"3A3A3A"];
    self.serviceNameLB.textColor=WHITECOLOR;
    [self.serviceNameLB setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:self.serviceNameLB];

    self.editBtn=[[UBButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 80, 35)];
    self.editBtn.layer.cornerRadius = 5;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderColor = MAJORCOLOR.CGColor;
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.backgroundColor = WHITECOLOR;
    [self.editBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:MAJORCOLOR forState:(UIControlStateNormal)];
    [self.editBtn setBackgroundImage:[UIImage imageWithColor:WHITECOLOR size:self.editBtn.frame.size] forState:(UIControlStateNormal)];
    [self.editBtn setTitleColor:WHITECOLOR forState:(UIControlStateSelected)];

    [self.editBtn setTitle:@"已开通" forState:UIControlStateSelected];
    [self.editBtn setBackgroundImage:[UIImage imageWithColor:MAJORCOLOR size:self.editBtn.frame.size] forState:(UIControlStateSelected)];
    [self addSubview:self.editBtn];
    __weak typeof(self) weakSelf = self;

    [self.editBtn addAction:^(UBButton *button) {
        [weakSelf.superVC showHudInView:weakSelf.superVC.view];
        [KCommonNetRequest switchExpertServerWithServerId:weakSelf.theModel.mes_id andComplete:^(BOOL success, id obj) {
            [weakSelf.superVC hideHud];
            if (success) {
                weakSelf.editBtn.selected=!weakSelf.editBtn.selected;
            }else{
                [weakSelf.superVC showHint:(NSString *)obj];
            }

        }];
    }];

}
-(void)layoutSubviews{
    self.serviceNameLB.text=self.theModel.mes_name;
    self.editBtn.selected=[self.theModel.mes_state isEqualToString:@"99"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
