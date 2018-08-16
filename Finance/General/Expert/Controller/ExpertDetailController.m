//
//  ExpertDetailController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/5.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ExpertDetailController.h"
#import "SwitchButtonView.h"
#import "ConsultController.h"
#import "QuestionDetailController.h"
#import "BookDetailController.h"
#import "ExpertConsultListController.h"
#import "ConsultCell.h"
#import "AnswerCell.h"
#import "BookCell.h"

#import "ExpertDetailModel.h"
#import "ConsultModel.h"
#import "AnswerModel.h"
#import "BookModel.h"


#define cell_consult @"consultCellReuseIdentifier"
#define cell_answer @"answerCellReuseIdentifier"
#define cell_book @"bookCellReuseIdentifier"

@interface ExpertDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ExpertDetailModel *experDetailModel;
@property (nonatomic, strong) NSMutableArray *consults;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, assign) NSInteger selectedTag;
@property (nonatomic, strong) UIWebView *tablefooterWebview;

@end

@implementation ExpertDetailController


- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ConsultCell class] forCellReuseIdentifier:cell_consult];
        [_tableView registerClass:[AnswerCell class] forCellReuseIdentifier:cell_answer];
        [_tableView registerClass:[BookCell class] forCellReuseIdentifier:cell_book];
        
        _tableView.bounces = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView=self.tablefooterWebview;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];

    [self.view addSubview:self.tableView];
    
    [self loadExpertDetail];
    [self loadAnswerList];
    [self loadBookList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 界面

- (void)setupHeaderView{
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 450)];
    UIImageView *imageView = [self setupExpertBasicInfo];
    [containerView addSubview:imageView];
    
    UIView *desribeView = [self setupExpertDesribe];
    [containerView addSubview:desribeView];
    containerView.height = desribeView.maxY;
    
    self.tableView.tableHeaderView = containerView;
}

- (UIView *)setupExpertDesribe{
    UIView *describeView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 150)];
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
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.experDetailModel.expert_jianjie attributes:dict];
    UILabel *describeLabel = [UILabel labelWithOrigin:CGPointMake(MARGIN, headerLabel.maxY+MARGIN_BIG) attributedText:attr textFont:FONT_SMALL];

    [describeView addSubview:headerLabel];
    [describeView addSubview:describeLabel];
    describeView.height = describeLabel.maxY + MARGIN_BIG;

    return describeView;
}


- (UIImageView *)setupExpertBasicInfo{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    imageView.backgroundColor = MAJORCOLOR;
    
    imageView.userInteractionEnabled = YES;

    ExpertDetailModel *model = self.experDetailModel;
    CGSize imageSize = CGSizeMake(80, 80);
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-imageSize.width)/2, MARGIN_BIG, imageSize.width, imageSize.height)];
    NSURL * headUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",OPENAPIHOST,model.expert_images]];
    [headerImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"header_default_big"]];
 headerImageView.layer.cornerRadius=headerImageView.frame.size.height/2;
    headerImageView.layer.masksToBounds=YES;
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(MARGIN_BIG, headerImageView.maxY+MARGIN, SCREEN_WIDTH-MARGIN_BIG*2, 20) text:model.expert_full_name textFont:FONT_BIG textColor:BLACKCOLOR];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *jobText = [NSString stringWithFormat:@"%@  %@",model.expert_zhiwei, model.expert_zhuanye];
    UILabel *jobLabel = [UILabel labelWithFrame:CGRectMake(MARGIN_BIG, nameLabel.maxY+MARGIN, SCREEN_WIDTH-MARGIN_BIG*2, 20) text:jobText textFont:FONT_NORMAL textColor:BLACKCOLOR];
    jobLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *skilledView = [self configureSkilledLabel:model.expert_zhuanye];
    skilledView.centerX = imageView.centerX;
    skilledView.y = jobLabel.maxY + MARGIN_BIG;
    
    UIButton  *concernButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, skilledView.maxY+MARGIN_BIG, 100, 40)];
    [concernButton setImage:[UIImage imageNamed:@"concern"] forState:UIControlStateNormal];
    [concernButton setImage:[UIImage imageNamed:@"concern_selected_white"] forState:UIControlStateSelected];
    concernButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    concernButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [concernButton addTarget:self action:@selector(concern:) forControlEvents:UIControlEventTouchUpInside];
    concernButton.selected = model.follow_ok;
    
    [imageView addSubview:headerImageView];
    [imageView addSubview:nameLabel];
    [imageView addSubview:jobLabel];
    [imageView addSubview:concernButton];
    [imageView addSubview:skilledView];
    
    return imageView;
}

-(void)share{
    [self shareWebPageWithUrl:nil andTitle:nil andShareCallback:^(NSString *type, id data) {

    }];
}
- (void)concern:(UIButton *)sender{

    if (![self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {
        [self loadExpertDetail];
    }]) {
        return;
    }
    __weak typeof(self) weakSelf = self;

    if (sender.selected==YES) {

        [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"提示" CancelTitle:@"取消" ConfirmTitle:@"确认" message:@"确认取关该专家？" cancelBlock:^(id obj) {

        } confirmBlock:^(id obj) {
            [self showHudInView:self.view];
            //取关
            [KCommonNetRequest deleteMemberFollowWithExpertID:self.expertUserId andComplete:^(BOOL success, id obj) {
                [weakSelf hideHud];
                if (success) {
                    sender.selected=NO;
                    [self showHint:@"取关成功"];
                }else{
                    [self showHint:(NSString*)obj];
                }
            }];

        }];


    }else{
        //关注
        [self showHudInView:self.view];
        [KCommonNetRequest addMemberFollowWithExpertID:self.expertUserId andComplete:^(BOOL success, id obj) {
            [weakSelf hideHud];
            if (success) {
                sender.selected=YES;
                [self showHint:@"关注成功"];
            }else{
                [self showHint:(NSString*)obj];
            }
        }];
    }

}


- (UIView *)configureSkilledLabel:(NSString *)skilledString{
    UIView *skilledView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    NSArray *texts = [skilledString componentsSeparatedByString:@" "];
    //    NSArray *texts = @[@"税务分析",@"IPO前政务管理"];
    CGFloat labelX = 0;
    for (int i=0;i<texts.count;i++){
        UILabel *skilledLabel = [UILabel labelWithOrigin:CGPointMake(labelX, 0) text:texts[i] textFont:FONT_SMALL textColor:WHITECOLOR];
        skilledLabel.width = skilledLabel.width + 10;
        skilledLabel.height = 24;
        skilledLabel.x = skilledLabel.x-5;
        skilledLabel.textAlignment = NSTextAlignmentCenter;
        skilledLabel.layer.cornerRadius = 2;
        skilledLabel.layer.masksToBounds = YES;
        skilledLabel.layer.borderColor = WHITECOLOR.CGColor;
        skilledLabel.layer.borderWidth = 1;
        [skilledView addSubview:skilledLabel];
        labelX = skilledLabel.maxX+MARGIN;
    }
    skilledView.width = labelX;
    return skilledView;
}


#pragma mark - 代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SwitchButtonView *buttonView = [[SwitchButtonView alloc]initWithTitles:@[@"专家服务",@"专家回答",@"专家著作"]];
    buttonView.buttonSwitch = ^(UIButton *sender) {
        self.selectedTag = sender.tag;
        if (self.selectedTag==0) {
            self.tableView.tableFooterView =self.tablefooterWebview;
        }else{
            self.tableView.tableFooterView =nil;;
        }
        [self.tableView reloadData];
      
    };
    //避免刷新后 buttonView 的选中恢复成第一个
    buttonView.selectedIndex = self.selectedTag;
    return buttonView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SWITCH_BUTTON_VIEW_HEIGHT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedTag == 0){
        return self.consults.count;
    }else if (self.selectedTag == 1){
        return self.answers.count;
    }else{
        return self.books.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTag == 0){
        ConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_consult];
        cell.consultModel = self.consults[indexPath.row];
        cell.superVC=self;
        cell.expertuserid=self.expertUserId;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else
        if (self.selectedTag == 1){
        AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_answer];
        cell.answerModel = self.answers[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

        
    }else{
        BookCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_book];
        cell.bookModel = self.books[indexPath.row];
        cell.superVC=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTag == 0){
        return 90;
        
    }else if (self.selectedTag == 1){
        AnswerCell *cell = [[AnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_answer];
        AnswerModel *model = self.answers[indexPath.row];
        return [cell cellHeightWithModel:model];
    }
    return 180;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.selectedTag == 0){
//        ExpertConsultListController *vc = [ExpertConsultListController new];
//        ConsultModel *model = self.consults[indexPath.row];
//        vc.expertUserId = self.expertUserId;
//        vc.severName = model.mes_name;
//        [self.navigationController pushViewController:vc animated:YES];
//    }

    if (self.selectedTag == 1){
        QuestionDetailController *vc = [QuestionDetailController new];
        AnswerModel *model = self.answers[indexPath.row];
        vc.questionId = model.answer_question_id;
        [self.navigationController pushViewController:vc animated:YES];

    }
//    else if (self.selectedTag == 2){
//
//    }
}


- (void)loadExpertDetail{
    [self showHudInView:self.view];

    /*接口：index/expert_info
     参数：
     @param  int        expert_user_id        * 专家的用户id【就是列表里expert_user_id字段的值】示例：
    */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_info"];
    NSDictionary *parameter =
   @{
        @"expert_user_id":@([self.expertUserId integerValue]),
        @"user_id":[UserAccountManager sharedManager].userAccount.user_id,
        @"user_name":[UserAccountManager sharedManager].userAccount.user_name
    };

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            ExpertDetailModel *model = [ExpertDetailModel mj_objectWithKeyValues:responseObject];
            self.experDetailModel = model;
            [self.tablefooterWebview loadHTMLString:model.baozhang baseURL:nil];
            [self setupHeaderView];

            [self.consults removeAllObjects];
            for (ConsultModel *consultModel in model.expert_server){
                [self.consults addObject:consultModel];
            }
            [self.tableView reloadData];
        }
    }];
}


- (void)loadAnswerList{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_info_answer"];
    NSDictionary *parameter = @{@"user_id":self.expertUserId,
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            
        }else{
            for (NSDictionary *dict in responseObject){
                AnswerModel *model = [AnswerModel mj_objectWithKeyValues:dict];
                [self.answers addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
    
}


- (void)loadBookList{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_info_book"];
    NSDictionary *parameter = @{@"user_id":@([self.expertUserId integerValue]),
                                @"page":@(1),
                                @"page_size":@(100)
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            
        }else{
            
            for (NSDictionary *dict in responseObject){
                BookModel *model = [BookModel mj_objectWithKeyValues:dict];
                [self.books addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - 数据懒加载
-(UIWebView *)tablefooterWebview{
    if (!_tablefooterWebview) {
        _tablefooterWebview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
       _tablefooterWebview.backgroundColor=GRAYCOLOR_BACKGROUND;

    }
    return _tablefooterWebview;
}

- (NSMutableArray *)consults{
    if (_consults == nil){
        _consults = [NSMutableArray array];
    }
    return _consults;
}

- (NSMutableArray *)answers{
    if (_answers == nil){
        _answers = [NSMutableArray array];
    }
    return _answers;
}


- (NSMutableArray *)books{
    if (_books == nil){
        _books = [NSMutableArray array];
    }
    return _books;
}



@end
