//
//  MyCollectVC.m
//  Finance
//
//  Created by 赵帅 on 2018/4/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyCollectVC.h"
#import "QuestionCell.h"
#import "QuestionModel.h"
#import "BookCell.h"
#import "BookModel.h"
#import "TopicListCell.h"
#import "TopicListModel.h"
#import "SwitchButtonView.h"
#import "QuestionDetailController.h"
#import "BookDetailController.h"
#import "TopicDetailNewVC.h"
@interface MyCollectVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, assign) NSInteger selectedIndex ;
@property (nonatomic, assign) NSInteger pageQuestion ;
@property (nonatomic, assign) NSInteger pagetopic;
@property (nonatomic, assign) NSInteger pageBook;
@end

@implementation MyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";

    self.questions=[NSMutableArray array];
    self.topics=[NSMutableArray array];
    self.books=[NSMutableArray array];
    self.pageQuestion=1;
    self.pagetopic=1;
    self.pageBook=1;


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];

    SwitchButtonView *switchButtonView = [[SwitchButtonView alloc] initWithTitles:@[@"问题",@"专题",@"书籍"]];
    switchButtonView.buttonSwitch = ^(UIButton *sender) {
        self.tableView.allowsMultipleSelection = YES;
        _tableView.estimatedRowHeight = 100.0f;
        self.selectedIndex = sender.tag;
        [self hideCommonEmptyViewWithView:self.tableView];
        if (sender.tag==1) {
            if (self.topics.count <= 0) {
                //请求专题
                [self.tableView.mj_header beginRefreshing];
            }

        }else if (sender.tag==2){
            if (self.books.count <= 0) {
                //请求书籍
                [self.tableView.mj_header beginRefreshing];
            }
        }else{
            if (self.questions.count <= 0) {
                //请求问题
                [self.tableView.mj_header beginRefreshing];
            }

        }
        [self.tableView reloadData];

    };
    [self.view addSubview:switchButtonView];

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, switchButtonView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT-switchButtonView.frame.size.height)
                                               style:(UITableViewStyleGrouped)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableView.allowsMultipleSelection = YES;
//    self.tableView.bounces = NO;
//    _tableView.estimatedRowHeight = 100.0f;//推测高度，必须有，可以随便写多少
//
//    _tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    [self.view addSubview:self.tableView];
    [self addrefreshControl];//添加刷新控件
    [_tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];//默认进来加载问题列表
    [self setupDeleteView];
}

-(void)addrefreshControl{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.selectedIndex==1) {
            self.pagetopic=1;
            [self getCollectTopicList];
        }else if (self.selectedIndex==2){
            self.pageBook=1;
            [self getCollectBookList];
        }else{
            self.pageQuestion=1;
            [self getCollectQuestionList];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.selectedIndex==1) {
            self.pagetopic++;
            [self getCollectTopicList];
        }else if (self.selectedIndex==2){
            self.pageBook++;
            [self getCollectBookList];
        }else{
            self.pageQuestion++;
            [self getCollectQuestionList];
        }
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    //在没有数据时不显示下拉加载更多
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer=footer;
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

- (void)edit:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"编辑"]) {
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

- (void)selectAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected){
        if (self.selectedIndex==1) {
            for (TopicListModel*theM in self.topics) {
                theM.isEditSelected=YES;
            }
        }else if (self.selectedIndex==2){
            for (BookModel*theM in self.books) {
                theM.isEditSelected=YES;
            }
        }else{
            for (QuestionModel*theM in self.questions) {
                theM.isEditSelected=YES;
            }

        }
        [self.tableView reloadData];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        if (self.selectedIndex==1) {
            for (TopicListModel*theM in self.topics) {
                theM.isEditSelected=NO;
            }
        }else if (self.selectedIndex==2){
            for (BookModel*theM in self.books) {
                theM.isEditSelected=NO;
            }
        }else{
            for (QuestionModel*theM in self.questions) {
                theM.isEditSelected=NO;
            }
        }
        [self.tableView reloadData];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}
- (void)deleteAction{
    if (self.selectedIndex==0) {
        [self commitDeleteQuestions];
    }else if (self.selectedIndex==1){
        [self commitDeleteTopics];
    }else{
        [self commitDeleteBooks];
    }
}

-(void)commitDeleteQuestions{
    NSMutableArray *idArray = [NSMutableArray array];
    for (QuestionModel*ex in self.questions) {
        if (ex.isEditSelected) {
            [idArray addObject:ex.question_id];
        }
    }
    
    if (idArray.count<=0) {
        [self showHint:@"请选择问题"];
        return;
    }
    
    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    [KCommonNetRequest deleteSubjectFollowWithQuestion_id:idsStr andComplete:^(BOOL success, id obj) {
        [self hideHud];
        if (success) {
            [self showHint:@"删除成功"];
            self.pagetopic=1;
//            self.tableView.editing=NO;
            [self getCollectQuestionList];
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
    
    
}
-(void)commitDeleteTopics{
    NSMutableArray *idArray = [NSMutableArray array];
    for (TopicListModel*ex in self.topics) {
        if (ex.isEditSelected) {
            [idArray addObject:ex.subject_id];
        }
    }
    if (idArray.count<=0) {
        [self showHint:@"请选择专题"];
        return;
    }

    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    [KCommonNetRequest followOrDeleteSubjectFollowWithSubject_id:idsStr andISFollow:NO andComplete:^(BOOL success, id obj) {

        [self hideHud];
        if (success) {
            [self showHint:@"删除成功"];
            self.pagetopic=1;
            [self getCollectTopicList];
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
}
-(void)commitDeleteBooks{
    NSMutableArray *idArray = [NSMutableArray array];
    for (BookModel*ex in self.books) {
        if (ex.isEditSelected) {
            [idArray addObject:ex.book_id];
        }
    }
    if (idArray.count<=0) {
        [self showHint:@"请选择图书"];
        return;
    }

    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    [KCommonNetRequest deleteSubjectFollowWithBook_id:idsStr andISFollow:NO andComplete:^(BOOL success, id obj) {

        [self hideHud];
        if (success) {
            [self showHint:@"删除成功"];
            self.pageBook=1;
            [self getCollectBookList];
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedIndex == 0){
        return self.questions.count;
    }else if (self.selectedIndex == 1){
        return self.topics.count;
    }else{
        return self.books.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedIndex==0) {
        QuestionModel*model=self.questions[indexPath.row];
        CGFloat heightcell=70;//上间隙+标题
        NSInteger imgRowCount= (model.question_images.count/3)+(model.question_images.count%3)>0?1:0;
        heightcell+=imgRowCount*((SCREEN_WIDTH-MARGIN-10)/3)+imgRowCount*10;
        CGFloat contentHeight=[NSString heightWithString:model.question_describe size:CGSizeMake(SCREEN_WIDTH-20, 50) font:12];
        heightcell+=contentHeight+30;

        return heightcell;
    }
    if (self.selectedIndex==1) {
        TopicListModel*topicModel=self.topics[indexPath.row];
        CGFloat height=[NSString heightWithString:topicModel.subject_content_gainian size:CGSizeMake(SCREEN_WIDTH-2*MARGIN, 60) font: 14];
        if (height<20) {
            height=20;
        }

        return 30+height+10;
    }
    if (self.selectedIndex==2) {
        return 180;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex==0) {
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
        if (cell == nil){
            cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
        }
        cell.questionModel = self.questions[indexPath.row];
        return cell;
    }else if (self.selectedIndex==1){
        TopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicListCell"];
        if (cell == nil){
            cell = [[TopicListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicListCell"];

        }
        if (self.topics.count>0) {
            cell.topicModel=self.topics[indexPath.row];
        }

        return cell;
    }else if (self.selectedIndex==2){
        BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
        if (cell == nil){
            cell = [[BookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookCell"];
        }
        cell.bookModel = self.books[indexPath.row];
        cell.superVC=self;

        return cell;
    }
    return nil;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.isEditing){
        if (self.selectedIndex==1) {
            TopicListModel*theModel=self.topics[indexPath.row];
            theModel.isEditSelected=!theModel.isEditSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (self.selectedIndex==2){
            BookModel*theModel=self.books[indexPath.row];
            [theModel setIsEditSelected:!theModel.isEditSelected];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            QuestionModel*theModel=self.questions[indexPath.row];
            [theModel setIsEditSelected:!theModel.isEditSelected];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
            
        


    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.selectedIndex==0) {
            QuestionDetailController *vc = [QuestionDetailController new];
            QuestionModel *model = self.questions[indexPath.row];
            vc.questionId = model.question_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.selectedIndex==1){
            
            TopicListModel*content=self.topics[indexPath.row];
            TopicDetailNewVC*detail=[TopicDetailNewVC new];
            detail.topicId=content.subject_id;
            [self.navigationController pushViewController:detail animated:YES];
        }else if (self.selectedIndex==2){
            BookModel*book=self.books[indexPath.row];
            BookDetailController*bookdetail=[BookDetailController new];
            bookdetail.bookId=book.book_id;
            [self.navigationController pushViewController:bookdetail animated:YES];
        }
    }

}
#pragma mark - 多选删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)getCollectQuestionList{
    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_question_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.pageQuestion),
                                @"page_size":@(6)
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (resultCode != NetworkResultSuceess){
//            [self showHint:(NSString *)responseObject];
            if (self.pageQuestion==1&&  resultCode==NetworkResultNODATASUCCESS) {
                //删除了都
                [weakSelf.questions removeAllObjects];
                [weakSelf.tableView reloadData];
            }
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.questions.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf getCollectQuestionList];
            }];
            return;

        }else{
            if (self.pageQuestion==1) {
                [self.questions removeAllObjects];
            }
            for (NSDictionary *dict in responseObject){
                QuestionModel *model = [QuestionModel mj_objectWithKeyValues:dict];
                [self.questions addObject:model];
            }
            [self.tableView reloadData];
            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];


        }

    }];
}
-(void)getCollectTopicList{
    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_subject_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.pagetopic
                                    ),
                                @"page_size":@(6)
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (resultCode != NetworkResultSuceess){
            if (self.pagetopic==1&&  resultCode==NetworkResultNODATASUCCESS) {
                //删除了都
                [weakSelf.topics removeAllObjects];
                [weakSelf.tableView reloadData];
            }
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.topics.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf getCollectTopicList];
            }];
            return;

        }else{
            if (self.pagetopic==1) {
                [self.topics removeAllObjects];
            }
            for (NSDictionary *dict in responseObject){

                TopicListModel *model = [TopicListModel mj_objectWithKeyValues:dict];
                [self.topics addObject:model];

            }

            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
            [self.tableView reloadData];
        }

    }];
}
-(void)getCollectBookList{
    __weak typeof(self) weakSelf = self;

//    [self showHudInView:self.tableView];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_book_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.pageBook),
                                @"page_size":@(6)
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (resultCode != NetworkResultSuceess){
            if (self.pageBook==1&&  resultCode==NetworkResultNODATASUCCESS) {
                //删除了都
                [weakSelf.books removeAllObjects];
                [weakSelf.tableView reloadData];
            }
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.books.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf getCollectQuestionList];
            }];
            return;

        }else{
            if (self.pageBook==1) {
                [self.books removeAllObjects];
            }
            for (NSDictionary *dict in responseObject){
                BookModel *model = [BookModel mj_objectWithKeyValues:dict];
                [self.books addObject:model];
            }
            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
            [self.tableView reloadData];
        }

    }];
}
@end
