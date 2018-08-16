//
//  QuestionDetailController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/11.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "QuestionDetailController.h"
#import "QuestionDetailModel.h"
#import "QuestionModel.h"
#import "QuestionFullCell.h"
#import "BookCell.h"
#import "BookModel.h"
#import "ExpertCell.h"
#import "ExpertModel.h"
#import "AnswerModel.h"
#import "ExpertAnswerCell.h"
#import "ZhuanjiadayiModel.h"

#import "AnswerController.h"
#import "AllAnswerController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#define cell_expertAnswer @"expertCellReuseIdentifier"
#define cell_book @"bookCellReuseIdentifier"
#define cell_question @"questionCellReuseIdentifier"
#define button_height 40
#define section_height 30

@interface QuestionDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, strong) NSMutableArray *questions;
//是否显示无专家解答的 view
@property (nonatomic) BOOL isNeedShowNoAnswer;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UILabel *answerCountL;

@end

@implementation QuestionDetailController
{
    QuestionFullCell *cell;
}
- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-button_height-HOME_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = WHITECOLOR;

        [_tableView registerClass:[ExpertAnswerCell class] forCellReuseIdentifier:cell_expertAnswer];
        [_tableView registerClass:[BookCell class] forCellReuseIdentifier:cell_book];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cell_question];
        
         _tableView.sectionFooterHeight = 0;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问答详情";
    self.view.backgroundColor=[UIColor whiteColor];

    _collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_white"] forState:(UIControlStateNormal)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_red"] forState:(UIControlStateSelected)];
    [_collectBtn addTarget:self action:@selector(collect) forControlEvents:(UIControlEventTouchUpInside)];

    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];

    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    self.navigationItem.rightBarButtonItems = @[forwardItem,collectItem];

    [self loadExpertDetail];
    [self.view addSubview:self.tableView];
    [self makeUI];


}

- (void)dealloc{
    
}


-(void)makeUI{


    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.maxY, SCREEN_WIDTH, button_height)];
    backView.backgroundColor = WHITECOLOR;
    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(MARGIN, 5, SCREEN_WIDTH-80-MARGIN, button_height-10) title:@"我来解答" font:FONT_BIG titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"answer"];
    [backView addSubview:answerButton];

    UIButton *messageButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, button_height)];
    [messageButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(jumpToMessageList) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:messageButton];

    _answerCountL=[[UILabel alloc]initWithFrame:CGRectMake(messageButton.frame.size.width-40, 0, 40, 20)];
    _answerCountL.font=FONT_SMALL;
    [_answerCountL setTextAlignment:(NSTextAlignmentCenter)];
    _answerCountL.textColor=MAJORCOLOR;
    [messageButton addSubview:_answerCountL];
    [self.view addSubview:backView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setupUI:(QuestionDetailModel *)model{

    [cell removeFromSuperview];
    cell=[[QuestionFullCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"QuestionFullCell"];
    CGFloat cellH=  [cell setQuestionDataWithModel:model];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, cellH+1);
    cell.superVC=self;
    self.tableView.tableHeaderView = cell;
    self.collectBtn.selected=model.collection_check;

    if (model.answer_count<=0) {
        self.answerCountL.text=@"";
    }else{
        self.answerCountL.text=[NSString stringWithFormat:@"%zd",model.answer_count<=0?0:model.answer_count];
    }


}


#pragma mark - 响应事件

- (void)answer {
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        AnswerController *vc = [AnswerController new];
        vc.questionId = [self.questionId integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)jumpToMessageList{
    AllAnswerController *vc = [AllAnswerController new];
    vc.questionId = [self.questionId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collect{

    if (![self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {
        [self loadExpertDetail];
    }]) {
        return;
    }
    if (self.collectBtn.selected) {//取消收藏
        NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_question_del"];
        UserAccount *user = [UserAccountManager sharedManager].userAccount;
        NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                    @"user_name":user.user_name,
                                    @"question_id":@([self.questionId intValue])
                                    };
        [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
            if (resultCode != NetworkResultSuceess){
                [self showHint:(NSString *)responseObject];
                return;
            }
            if (resultCode==NetworkResultSuceess) {
                self.collectBtn.selected=NO;
                [self showHint:@"取消收藏成功"];
            }

        }];

    }else{
        //收藏

        NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_question"];
        UserAccount *user = [UserAccountManager sharedManager].userAccount;
        NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                    @"user_name":user.user_name,
                                    @"question_id":@([self.questionId intValue])
                                    };
        [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
            if (resultCode != NetworkResultSuceess){
                [self showHint:(NSString *)responseObject];
                return;
            }
            if (resultCode==NetworkResultSuceess) {
                [self showHint:@"收藏成功"];
                self.collectBtn.selected=YES;
            }



        }];
    }
}

- (void)forward{
    [self shareWebPageWithUrl:nil andTitle:nil andShareCallback:^(NSString *type, id data) {

    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titles = @[@"专家答疑",@"相关图书",@"相关问题"];
    NSArray *imageNames = @[@"answer",@"book",@"question"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [label setFont:FONT_NORMAL];
    [label setTextColor:MAJORCOLOR];
    label.backgroundColor = GRAYCOLOR_BACKGROUND;
    UIImage *image = [UIImage imageNamed:imageNames[section]];
    [label setText:titles[section] frontImages:@[image] headIndent:MARGIN_SMALL imageSpan:MARGIN_SMALL];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0 && self.answers.count>0){
        return section_height;
    }

    if (section==1 && self.books.count>0){
        return section_height;
    }

    if (section==2 && self.questions.count>0){
        return section_height;
    }

    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        if (self.answers.count>0) {
            return self.answers.count;
        }else
            return 1;


    }else if (section == 1){
        return self.books.count;
    }else{
        return self.questions.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    if (section == 0){
        if (self.answers.count>0) {
            ExpertAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_expertAnswer];
            ZhuanjiadayiModel *model = self.answers[indexPath.row];
            cell.expertModel = model.zhuanjia;
            cell.answerModel = model.daan;
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            return cell;
        }else{
            NoDataCell*cell0=[tableView dequeueReusableCellWithIdentifier:@"NoDataCell"];
            if (!cell0) {
                cell0=[[NoDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataCell"];
                [cell0 setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            }
            cell0.noAnswerButton.hidden=!self.isNeedShowNoAnswer;
            return cell0;

        }

        
    }else if (section == 1){
        BookCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_book];
        cell.bookModel = self.books[indexPath.row];
        cell.superVC=self;
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_question];
        if (self.questions.count>indexPath.row) {
            
            cell.textLabel.text = ((QuestionModel*)self.questions[indexPath.row]).question_title;
        }
        cell.textLabel.textColor = GRAYCOLOR_TEXT;
        cell.textLabel.font = FONT_NORMAL;
        return cell;
    }
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (self.answers.count>0) {

            ExpertAnswerCell *cell = [[ExpertAnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_expertAnswer];
            ZhuanjiadayiModel *model = self.answers[indexPath.row];
            CGFloat height = [cell cellHeightWithAnswerModel:model.daan expertModel:model.zhuanjia userModel:nil];
            return height;
        }else
            return 80;
        
    }else if (indexPath.section == 1){
        return 180;
        
    }else{
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {//相关问题.

        if (self.questions.count>indexPath.row) {
            
            QuestionModel*theQue= self.questions[indexPath.row];
            self.questionId=theQue.question_id;
            [self reset];
            [self loadExpertDetail];
        }

    }
}




- (void)loadExpertDetail{
    [self showHudInView:self.tableView];
    /*接口：index/show_question
     参数：
     @param  int       user_id         用户的id
     @param  string      user_name       用户名
     @param  int         question_id     * 问题的主键*/
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/show_question"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!user) {
        user=[[UserAccount alloc]init];
    }
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"question_id":@([self.questionId intValue])
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }
        self.isNeedShowNoAnswer=YES;
        QuestionDetailModel *questionDetailModel = [QuestionDetailModel mj_objectWithKeyValues:responseObject];
        [self setupUI:questionDetailModel];

        for (BookModel *model in questionDetailModel.xiangguantushu){
            [self.books addObject:model];
        }

        for (NSDictionary *dict in questionDetailModel.xiangguanwenti){
            [self.questions addObject:[QuestionModel mj_objectWithKeyValues:dict]];
        }

        [self.answers addObject:questionDetailModel.zhuanjiadayi];
        [self.tableView reloadData];
    }];
    
}


-(void)reset{
    //清空数据
    [self.answers removeAllObjects];
    [self.books removeAllObjects];
    [self.questions removeAllObjects];
}
#pragma mark - 数据懒加载

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

- (NSMutableArray *)questions{
    if (_questions == nil){
        _questions = [NSMutableArray array];
    }
    return _questions;
}


@end
