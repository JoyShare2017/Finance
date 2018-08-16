//
//  ReceiptAddressCell.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/18.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "ReceiptAddressCell.h"
#import "AddAddressViewController.h"
@interface ReceiptAddressCell()
@property(nonatomic,strong)UILabel*nameLb,*phoneLb,*addressLb;
@property(nonatomic,strong)UBButton*defaultAddressBtn,*editBtn,*deleteBtn;

@end



@implementation ReceiptAddressCell
#pragma mark----system Method
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
        
        
    }
    return self;
}
#pragma mark---private methods
-(void)makeUI{
    
    for (int i=0; i<3; i++) {
        UILabel*label =[[UILabel alloc]initWithFrame:CGRectMake(20, i==2?28:0, SCREEN_WIDTH-40, i==2?34:30)];
        label.font=[UIFont systemFontOfSize:14];
        if (i==0) {_nameLb=label; }
        if (i==1) {_phoneLb=label; [_phoneLb setTextAlignment:(NSTextAlignmentRight)];}
        if (i==2) {_addressLb=label; _addressLb.numberOfLines=2;}
        
        [self addSubview:label];
    }
    
    UIView*line =[[UIView alloc]initWithFrame:CGRectMake(20, 62.5, SCREEN_WIDTH-40, 0.6)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:line];
    __block typeof(self) weakSelf=self;
    _defaultAddressBtn=[[UBButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_addressLb.frame), 100, 40)];
    [_defaultAddressBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [_defaultAddressBtn setTitle:@"设为默认" forState:(UIControlStateNormal)];
    [_defaultAddressBtn setImage:[UIImage imageNamed:@"circle_empty"] forState:(UIControlStateNormal)];
    [_defaultAddressBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [_defaultAddressBtn setTitle:@"默认地址" forState:(UIControlStateSelected)];
    [_defaultAddressBtn setImage:[UIImage imageNamed:@"circle_tick_orange"] forState:(UIControlStateSelected)];
    [_defaultAddressBtn setTitleColor:MAJORCOLOR forState:(UIControlStateSelected)];
    _defaultAddressBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    [_defaultAddressBtn addAction:^(UBButton *button) {
        NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/set_default_address"];
        UserAccount *user = [UserAccountManager sharedManager].userAccount;
        NSDictionary *parameter = @{
                                    @"user_id":@([user.user_id integerValue]),
                                    
                                    @"user_name":user.user_name,
                                    @"us_id":weakSelf.addModel.us_id,
                                    @"us_default":button.selected?@"2":@"1"
                                    };
        [weakSelf.mySuperVc showHudInView:weakSelf.mySuperVc.view];
        [[NetworkManager sharedManager]request:POST URLString:urlStr parameters: parameter callback:^(NetworkResult resultCode, id responseObject) {
            [weakSelf.mySuperVc hideHud];
            if (resultCode==NetworkResultSuceess) {
                [weakSelf.mySuperVc.tableView.mj_header beginRefreshing];
            }else{
                [weakSelf.mySuperVc showHint:responseObject];
            }
        }];
        
        
    }];
    [self addSubview:_defaultAddressBtn];
    
    
    for (int i=0; i<2; i++) {
        UBButton*btn =[[UBButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-180+80*i, CGRectGetMaxY(_addressLb.frame), 80, 40)];
        [btn setTitle:@[@"编辑",@"删除"][i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@[@"edit",@"delete-1"][i]] forState:(UIControlStateNormal)];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        if (i==0) {
            _editBtn=btn;
            [_editBtn addAction:^(UBButton *button) {
                AddAddressViewController*addadd=[[AddAddressViewController alloc]init];
                addadd.oldAddress=weakSelf.addModel;
                addadd.updateSuccess = ^(id obj) {
                    [weakSelf.mySuperVc.tableView.mj_header beginRefreshing];
                };
                [weakSelf.mySuperVc.navigationController pushViewController:addadd animated:YES];
                
                
            }];
        }else if (i==1){
            _deleteBtn=btn;
            [_deleteBtn addAction:^(UBButton *button) {
                
                
                [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"提示" CancelTitle:@"取消" ConfirmTitle:@"确定" message:@"确认要删除该地址吗？" cancelBlock:^(id obj) {
                    
                } confirmBlock:^(id obj) {
                    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/user_address_delete"];
                    UserAccount *user = [UserAccountManager sharedManager].userAccount;
                    NSDictionary *parameter = @{
                                                @"user_id":@([user.user_id integerValue]),
                                                
                                                @"user_name":user.user_name,
                                                @"us_id":weakSelf.addModel.us_id,
                                                };
                    [weakSelf.mySuperVc showHudInView:weakSelf.mySuperVc.view];

                    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters: parameter callback:^(NetworkResult resultCode, id responseObject) {
                        [weakSelf.mySuperVc hideHud];
                        if (resultCode==NetworkResultSuceess) {
                            [weakSelf.mySuperVc.tableView.mj_header beginRefreshing];
                        }else{
                            [weakSelf.mySuperVc showHint:responseObject];
                        }
                    }];
                    
                }];
                
            }];
            
        }
        [self addSubview:btn];
    }
 
}


-(void)layoutSubviews{
    
    _nameLb.text=_addModel.us_name;
    _phoneLb.text=_addModel.us_phone;
    _addressLb.text=[NSString stringWithFormat:@"%@",_addModel.us_address];
    if (_addModel.us_default==1) {
        _defaultAddressBtn.selected=YES;
    }else
        _defaultAddressBtn.selected=NO;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
