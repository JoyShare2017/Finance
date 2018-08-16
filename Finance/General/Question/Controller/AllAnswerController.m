//
//  AllAnswerController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/13.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "AllAnswerController.h"
#import "AllAnswerModel.h"
#import "AnswerModel.h"
#import "ExpertCell.h"
#import "ExpertAnswerCell.h"
#import "AnswerController.h"
#import "MoreAnswerCell.h"
#import "MoreAnswerCell.h"
#define expertAnswerCell @"expertAnswerCellReuseIdentifier"

@interface AllAnswerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) AnswerModel *answerTop;
@property(nonatomic)NSInteger page;
@end

@implementation AllAnswerController

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-BUTTON_HEIGHT-2*MARGIN_SMALL-HOME_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        
    }
    return _tableView;
}


- (NSMutableArray *)answers{
    if (_answers == nil){
        _answers = [NSMutableArray array];
    }
    return _answers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多回答";
    [self.view addSubview:self.tableView];
    self.page=1;
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshWithHeaderBlock:^{
        weakSelf.page = 1;
        [weakSelf.answers removeAllObjects];
        [weakSelf loadAllAnswerList];
    } footerBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf loadAllAnswerList];
    }];
    [self.tableView.mj_header beginRefreshing];


    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(MARGIN, self.tableView.maxY+MARGIN_SMALL, SCREEN_WIDTH-MARGIN*2, BUTTON_HEIGHT) title:@"我来解答" font:FONT_NORMAL titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"answer"];
    [self.view addSubview:answerButton];
}


- (void)answer{
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        AnswerController *vc = [AnswerController new];
        vc.questionId = self.questionId;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.answers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreAnswerCell"];
    if (!cell) {
        cell=[[MoreAnswerCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MoreAnswerCell"];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    if (self.answers.count>indexPath.row) {
       cell.answerModel = self.answers[indexPath.row];
    }

    cell.superVC=self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    AnswerModel *model = self.answers[indexPath.row];
    CGFloat height = 5+70+5;//头像+SHANGXIABIANJU
    CGFloat contentHeight=[NSString heightWithString:model.answer_content size:CGSizeMake(SCREEN_WIDTH-2*MARGIN, 500) font:14];
    height+=contentHeight;
    height+=5+5;

    CGFloat heightIMGS=0;
    NSInteger imgRowCount= (model.answer_images.count/3)+((model.answer_images.count%3)>0?1:0);
    if (imgRowCount>0) {
        heightIMGS+=imgRowCount*((SCREEN_WIDTH-2*MARGIN-10)/3)+imgRowCount*5;
        height+=heightIMGS;
    }

    return height;

    
}

- (void)loadAllAnswerList{
    /*接口：index/answer_list
     参数：
     @param  int     question_id     * 问题的主键
     @param  int  page          第几页(默认第1页)
     @param  int     page_size    每页几条数据(默认6条)
*/

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/answer_list"];
    NSDictionary *parameter = @{@"question_id":@(self.questionId),
                                @"page":@(self.page),
                                @"page_size":@(10)
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return ;
        }


        if (self.page==1) {
            [self.answers removeAllObjects];
        }
        AllAnswerModel *allAnswer = [AllAnswerModel mj_objectWithKeyValues:responseObject];
        if (allAnswer.answer_top){
            [self.answers insertObject:allAnswer.answer_top atIndex:0];
        }
        
        for (NSDictionary *dict in allAnswer.answer_list){
            AnswerModel *model = [AnswerModel mj_objectWithKeyValues:dict];
            [self.answers addObject:model];
        }
        self.tableView.mj_footer.hidden=allAnswer.answer_list.count<10;
        [self.tableView reloadData];
    }];
}

@end
