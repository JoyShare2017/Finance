//
//  ExpertConsultListController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/24.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ExpertConsultListController.h"
#import "ExpertCell.h"
#import "ExpertModel.h"
#import "ConsultDetailCell.h"
#import "ConsultDetailModel.h"
#import "ConsultController.h"

#define ExpertCell_Height 140
#define ConsultDetailCell_Identifier  @"consultDetailCellIdentifier"

///专家详情-图文咨询
@interface ExpertConsultListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ExpertModel *expertModel;
@property (nonatomic, copy) NSString *consultOrderId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *consultInfos;

@end

@implementation ExpertConsultListController

- (NSMutableArray *)consultInfos{
    if (_consultInfos == nil){
        _consultInfos = [NSMutableArray array];
    }
    return _consultInfos;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ExpertCell_Height, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-ExpertCell_Height-BUTTON_HEIGHT) style:UITableViewStylePlain];
        [_tableView registerClass:[ConsultDetailCell class] forCellReuseIdentifier:ConsultDetailCell_Identifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.rowHeight=100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.severName;
    self.view.backgroundColor = WHITECOLOR;
    [self.view addSubview:self.tableView];
    if (!_zixunId) { _zixunId=@""; }
    if (!_severName) { _severName=@""; }

    [self loadExpertInfo];
    [self loadConsultList];
    UIButton *consultButton = [UIButton buttonWithFrame:CGRectMake(0, USEABLE_VIEW_HEIGHT-BUTTON_HEIGHT, SCREEN_WIDTH, BUTTON_HEIGHT) title:@"我要咨询" font:FONT_NORMAL titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"goToConsult"];
    [self.view addSubview:consultButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    DebugLog(@"ExpertConsultListController 销毁了");
}

- (void)goToConsult{
    ConsultController *vc = [ConsultController new];
    vc.severName = self.severName;
    vc.expertId=self.expertModel.expert_user_id;
    vc.mco_id=self.zixunId;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)setupExpertUI:(ExpertModel *)expertModel{
    ExpertCell *cell = [[ExpertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpertCell"];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, ExpertCell_Height);
    cell.expertModel = expertModel;
    cell.contentView.backgroundColor = MAJORCOLOR;
    for (UIView *subview in cell.contentView.subviews){
        if ([subview isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)subview;
            label.textColor = WHITECOLOR;
        }else if ([subview isKindOfClass:[UIButton class]]){
            

        }
    }
    for (UILabel*skiv in cell.skilledView.subviews) {
        if ([skiv isKindOfClass:[UILabel class]]){
            skiv.layer.borderColor=WHITECOLOR.CGColor;
            skiv.textColor=WHITECOLOR;
        }
    }
    [self.view addSubview:cell];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.consultInfos.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultDetailModel *model = self.consultInfos[indexPath.row];
    CGFloat height = 5+70+5;//头像+SHANGXIABIANJU
    CGFloat contentHeight=[NSString heightWithString:model.mcm_content size:CGSizeMake(SCREEN_WIDTH-2*MARGIN, 500) font:14];
    height+=contentHeight;
    height+=5+5;
    
    CGFloat heightIMGS=0;
    NSInteger imgRowCount= (model.mcm_images.count/3)+((model.mcm_images.count%3)>0?1:0);
    if (imgRowCount>0) {
        heightIMGS+=imgRowCount*((SCREEN_WIDTH-2*MARGIN-10)/3)+imgRowCount*5;
        height+=heightIMGS;
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConsultDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsultDetailCell_Identifier];
    cell.consultDetailModel = self.consultInfos[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadExpertInfo{
    /*接口：member/index/member_consult_expert_show
     参数：
     @param  int        user_id        * 用户的id
     @param  string     user_name    * 用户名
     @param  string      mco_id        * 咨询订单服务的主键*/
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_consult_expert_show"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;

    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"mco_id":self.zixunId
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }else{
            ExpertModel *model = [ExpertModel mj_objectWithKeyValues:responseObject];
            self.expertModel = model;
            [self setupExpertUI:model];
        }
    }];
}


- (void)loadConsultList{
    /*接口：member/index/member_consult_msg_show
     参数：
     @param  string      mco_id        * 咨询订单服务的主键
     */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_consult_msg_show"];
    NSDictionary *parameter = @{
                                @"mco_id":self.zixunId
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }else{
            for (NSDictionary *dict in responseObject){
                ConsultDetailModel *model = [ConsultDetailModel mj_objectWithKeyValues:dict];
                [self.consultInfos addObject:model];
            }
            [self.tableView reloadData];


        }
    }];
}

@end
