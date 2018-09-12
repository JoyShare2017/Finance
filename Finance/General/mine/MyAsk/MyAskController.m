//
//  MyAskController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/30.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyAskController.h"
#import "QuestionModel.h"
#import "MyConsultCell.h"
#import "SwitchButtonView.h"
#import "MyAskCell.h"
#import "QuestionDetailController.h"
#import "ExpertConsultListController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BecomeExpertController.h"

@interface MyAskController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *asks;
@property (nonatomic, strong) NSMutableArray *consults;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *footerView;


@end

@implementation MyAskController

- (NSMutableArray *)asks{
    if (_asks == nil){
        _asks = [NSMutableArray array];
    }
    return _asks;
}

- (NSMutableArray *)consults{
    if (_consults == nil){
        _consults = [NSMutableArray array];
    }
    return _consults;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.allowsMultipleSelection = YES;
        [_tableView registerClass:[MyAskCell class] forCellReuseIdentifier:@"MyAskCell"];
        [_tableView registerClass:[MyConsultCell class] forCellReuseIdentifier:@"MyConsultCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;

    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的提问";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];


//    SwitchButtonView *switchButtonView = [[SwitchButtonView alloc] initWithTitles:@[@"我的提问",@"我的咨询"]];
//     __weak typeof(self) weakSelf = self;
//    switchButtonView.buttonSwitch = ^(UIButton *sender) {
//        [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
//        self.selectedIndex = sender.tag;
//        if (sender.tag == 1 && self.consults.count <= 0){
//            [self loadMyConsultDataList];
//        }
//        [self.tableView reloadData];
//    };
//    [self.view addSubview:switchButtonView];
    [self.view addSubview:self.tableView];
//    self.tableView.emptyDataSetSource=self;
//    self.tableView.emptyDataSetDelegate=self;
    [self setupDeleteView];
    [self loadMyAskDataList];
}


- (void)setupDeleteView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BUTTON_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT, SCREEN_WIDTH, BUTTON_HEIGHT)];
    footerView.backgroundColor = WHITECOLOR;
    footerView.hidden = YES;
    self.footerView = footerView;

    UIButton *selectAllButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, footerView.height)];
    selectAllButton.titleLabel.font = FONT_NORMAL;
    [selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllButton setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [selectAllButton setImage:[UIImage imageNamed:@"circle_empty"] forState:UIControlStateNormal];
    [selectAllButton setImage:[UIImage imageNamed:@"circle_tick_orange"] forState:UIControlStateSelected];
    selectAllButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [selectAllButton addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 90, footerView.height)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = FONT_NORMAL;
    deleteButton.backgroundColor = MAJORCOLOR;
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];

    [footerView addSubview:selectAllButton];
    [footerView addSubview:deleteButton];
    [self.view addSubview:footerView];
}


- (void)deleteAction{
    if (self.selectedIndex == 0){
        [self commitDeleteMyAsks];
    }else{
        [self commitDeleteMyConsults];
    }
}


- (void)selectAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        [self.tableView reloadData];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}



- (void)edit:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"编辑"]) {
//        if (self.asks.count == 0) {
//            return;
//        }
        item.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, BUTTON_HEIGHT, 0);
        self.footerView.hidden = NO;
    }else{
        item.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.footerView.hidden = YES;
    }
}


#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"no_info"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"还没有消息内容" attributes:@{NSFontAttributeName:FONT_NORMAL,NSForegroundColorAttributeName:GRAYCOLOR_TEXT}];
    return attr;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"成为专家" attributes:@{NSFontAttributeName:FONT_BIG,NSForegroundColorAttributeName:MAJORCOLOR}];
    return attr;

}


- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return [UIImage imageNamed:@"button_border"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    BecomeExpertController *vc = [[UIStoryboard storyboardWithName:@"BecomeExpertController" bundle:nil] instantiateViewControllerWithIdentifier:@"BecomeExpert"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -100;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedIndex == 0){
        return self.asks.count;
    }else{
        return self.consults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == 0){
        MyAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAskCell"];
        cell.textLabel.textColor = BLACKCOLOR;
        cell.textLabel.font = FONT_NORMAL;
        cell.imageView.image=[UIImage imageNamed:@"question"];
        QuestionModel *model = self.asks[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@?",model.question_title];
        cell.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        cell.tintColor=MAJORCOLOR;
        return cell;
    }else{
        MyConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyConsultCell"];
        cell.myConsultModel = self.consults[indexPath.row];
        cell.tintColor=MAJORCOLOR;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == 0){
        return 60;
    }else{
        return 60;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing){
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedIndex == 0){
        QuestionDetailController *vc = [QuestionDetailController new];
        QuestionModel *model = self.asks[indexPath.row];
        vc.questionId = model.question_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ExpertConsultListController *vc = [ExpertConsultListController new];
        MyConsultModel *model = self.consults[indexPath.row];
        vc.zixunId=model.mco_id;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


#pragma mark - 多选删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)deleteMessage{
    NSArray *selectedIndexPaths = self.tableView.indexPathsForSelectedRows;
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *targetArray = self.selectedIndex == 0 ? self.asks :self.consults;

    [targetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isSame = NO;
        for (NSIndexPath *indexPath in selectedIndexPaths){
            if (indexPath.row == idx){
                isSame = YES;
                break; //退出内层的for循环
            }
        }
        if (isSame == NO){
            if (self.selectedIndex == 0) {
                [tempArray addObject:self.asks[idx]];
                
            }else{
                [tempArray addObject:self.consults[idx]];
            }
        }
    }];


    if (self.selectedIndex == 0){
        self.asks = tempArray;
    }else{
        self.consults = tempArray;
    }
    [self.tableView reloadData];

}


- (void)commitDeleteMyAsks{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *idArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths){
        QuestionModel *model = self.asks[indexPath.row];
        [idArray addObject:model.question_id];
    }
    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    /*
     接口：member/index/member_question_del
     参数：
     @param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  string    question_id     * 问题的主键（多个，逗号隔开）
     */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_question_del"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"question_id":idsStr
                                };

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }
        [self deleteMessage];
    }];
}


- (void)commitDeleteMyConsults{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *idArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths){
        MyConsultModel *model = self.consults[indexPath.row];
        [idArray addObject:model.mco_id];
    }
    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    /*
     接口：member/index/member_consult_del
     参数：
     @param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  string    consult_id         * 咨询的id（多个逗号隔开）
     */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_consult_del"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"consult_id":idsStr
                                };

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }
        [self deleteMessage];
    }];
}



- (void)loadMyAskDataList{
    /*
     接口：member/index/member_question_list
     参数：
     @param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  int        chose_typ        要获取的列表：1:提问中、2:已解决(默认:1)
     @param  int  page         第几页(默认第1页)
     @param  int  page_size     每页几条数据(默认6条)
     */
    [self showHudInView:self.view];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_question_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                    @"user_name":user.user_name,
                                @"chose_type":@(self.selectedIndex+1),
                                @"page":@(1),
                                @"page_size":@(100)
                                };
    __weak typeof(self) weakSelf = self;

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
//            [self showHint:(NSString *)responseObject];
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.asks.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf loadMyAskDataList];
                return ;
            }];
            [self.tableView reloadData];
            return;
        }
        [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
        for (NSDictionary *dict in responseObject){
            QuestionModel *model = [QuestionModel mj_objectWithKeyValues:dict];
            [self.asks addObject:model];
        }
//        self.tableView.emptyDataSetSource = self;
//        self.tableView.emptyDataSetDelegate = self;

        [self.tableView reloadData];
    }];
}


- (void)loadMyConsultDataList{
    /*
     接口：member/index/member_consult_list
     参数：
     @param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  int  page         第几页(默认第1页)
     @param  int  page_size     每页几条数据(默认6条)
     */
    [self showHudInView:self.view];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_consult_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(1),
                                @"page_size":@(100)
                                };
    __weak typeof(self) weakSelf = self;

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
//            [self showHint:(NSString *)responseObject];
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.consults.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf loadMyConsultDataList];
                return ;
            }];
            [self.tableView reloadData];
            return;
        }

        [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
        for (NSDictionary *dict in responseObject){
            MyConsultModel *model = [MyConsultModel mj_objectWithKeyValues:dict];
            [self.consults addObject:model];
        }
        [self.tableView reloadData];
    }];
}

@end
