//
//  HasBecomeExpertController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/3.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "HasBecomeExpertController.h"
#import "ExpertDetailModel.h"
#import "ExpertModel.h"
#import "ConsultModel.h"
#import "ExpertCell.h"
#import "EditServiceCell.h"
#import "BecomeExpertController.h"
#import "ReviewController.h"

@interface HasBecomeExpertController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ExpertDetailModel *expertDetailModel;
@property (nonatomic, strong) NSMutableArray *consults;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *severNames;
///服务开通状态的集合
@property (nonatomic, strong) NSMutableArray *serveOpenStatuses;

@end

@implementation HasBecomeExpertController

- (NSMutableArray *)consults{
    if (_consults == nil){
        _consults = [NSMutableArray array];
    }
    return _consults;
}

- (NSArray *)severNames{
    if (_severNames == nil){
        _severNames = @[@"图文咨询",@"考证指导",@"私人财务",@"预约专家"];
    }
    return _severNames;
}

- (NSMutableArray *)serveOpenStatuses{
    if (_serveOpenStatuses == nil){
        NSNumber *number = [NSNumber numberWithBool:NO];
        _serveOpenStatuses = [NSMutableArray arrayWithObjects:number,number,number,number, nil];

    }
    return _serveOpenStatuses;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=WHITECOLOR;
    self.title = @"成为专家";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shenhe"] style:UIBarButtonItemStylePlain target:self action:@selector(lookReviewStatus)];

    [self loadExpertDetailInfo];
}


///查看审核状态
- (void)lookReviewStatus{
    ReviewController *vc = [ReviewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setupUI{
    ExpertCell *basicInfoView = [self setupExpertInfo];
    UIView *describeView = [self setupExpertDesribe];
    UIView *mySeverCutView = [UILabel labelWithFirstIndent:MARGIN frame:CGRectMake(0, describeView.maxY, SCREEN_WIDTH, 40) text:@"我的服务" textFont:FONT_BIG textColor:WHITECOLOR backgroundColor:MAJORCOLOR];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mySeverCutView.maxY, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-mySeverCutView.maxY) style:UITableViewStylePlain];
    [self configueTableView];

    [self.view addSubview:basicInfoView];
    [self.view addSubview:describeView];
    [self.view addSubview:mySeverCutView];
    [self.view addSubview:self.tableView];

}

- (ExpertCell *)setupExpertInfo{
    ExpertCell *cell = [[ExpertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpertCell"];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    cell.expertModel = (ExpertModel *)self.expertDetailModel;

    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 140)];
    coverView.backgroundColor = WHITECOLOR;
    UIImage *editImage = [UIImage imageNamed:@"bianji"];
    CGFloat imageW = editImage.size.width;
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(coverView.width-imageW*4, MARGIN*3, imageW*4, imageW)];
    [editButton setImage:editImage forState:UIControlStateNormal];
    editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [editButton addTarget:self action:@selector(editExpertInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:coverView];
    [coverView addSubview:editButton];

    return cell;
}

- (void)editExpertInfoAction{
    BecomeExpertController *vc = [[UIStoryboard storyboardWithName:@"BecomeExpertController" bundle:nil] instantiateViewControllerWithIdentifier:@"BecomeExpert"];
    vc.oldExpertModel=self.expertDetailModel;
    [self.navigationController pushViewController:vc animated:YES];

}


- (UIView *)setupExpertDesribe{
    UIView *describeView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 150)];
    UILabel *headerLabel = [UILabel labelWithFirstIndent:10 frame:CGRectMake(0, 0, SCREEN_WIDTH, 40) text:@"专家简介" textFont:FONT_SMALL textColor:MAJORCOLOR backgroundColor:GRAYCOLOR_BACKGROUND];

    //段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //首行文本缩进
    paraStyle.firstLineHeadIndent = 30;
    //使用文本段落样式
    //NSParagraphStyleAttributeName:paraStyle,
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:BLACKCOLOR
                           };
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.expertDetailModel.expert_jianjie attributes:dict];
    UILabel *describeLabel = [UILabel labelWithOrigin:CGPointMake(MARGIN, headerLabel.maxY+MARGIN_BIG) attributedText:attr textFont:FONT_SMALL];

    [describeView addSubview:headerLabel];
    [describeView addSubview:describeLabel];
    describeView.height = describeLabel.maxY + MARGIN_BIG;

    return describeView;
}

- (void)configueTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = GRAYCOLOR_BORDER;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
    self.tableView.bounces = NO;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expertDetailModel.expert_server.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditServiceCell"];
    if (!cell) {
        cell=[[EditServiceCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"EditServiceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.superVC=self;

    }
    cell.theModel=self.expertDetailModel.expert_server[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


- (void)loadExpertDetailInfo{
    [self showHudInView:self.view];

    /*接口：index/expert_info
     参数：
     @param  int        expert_user_id        * 专家的用户id【就是列表里expert_user_id字段的值】示例：
     */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_info"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"expert_user_id":@([user.user_id integerValue])};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            ExpertDetailModel *model = [ExpertDetailModel mj_objectWithKeyValues:responseObject];
            self.expertDetailModel = model;
            for (ConsultModel *consultModel in model.expert_server){
                [self.consults addObject:consultModel];
            }
            [self setupUI];

        }
    }];

}



@end
