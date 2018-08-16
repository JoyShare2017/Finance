//
//  QuestionController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/25.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "QuestionController.h"
#import "SearchController.h"
#import "SwitchButtonView.h"
#import "QuestionCell.h"
#import "QuestionDetailController.h"
#import "QuestionModel.h"
#import "AskController.h"

@interface QuestionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *questionHotList,*questionLatestList;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) NSInteger pageHot;
@property (nonatomic, assign) NSInteger pageLatest;
@property (nonatomic, assign)BOOL isLatestIndex;
@end

@implementation QuestionController
{

}
- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SWITCH_BUTTON_VIEW_HEIGHT, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-SWITCH_BUTTON_VIEW_HEIGHT-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSMutableArray *)questionHotList{
    if (_questionHotList == nil){
        _questionHotList = [NSMutableArray array];
    }
    return _questionHotList;
}
-(NSMutableArray *)questionLatestList{
    if (!_questionLatestList) {
        _questionLatestList = [NSMutableArray new];
    }
    return  _questionLatestList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFirstLoad = YES;
    [self setNavgationItem];
    
    SwitchButtonView *switchButtonView = [[SwitchButtonView alloc]initWithTitles:@[@"热门",@"最新"]];
    switchButtonView.buttonSwitch = ^(UIButton *button) {
        self.isLatestIndex=!(button.tag == 0);

        if (self.isLatestIndex) {
            if (self.questionLatestList.count==0) {
                [self loadQuestionListDataWithType:2];
            }
       }else if (self.isLatestIndex==NO){
           if (self.questionHotList.count==0) {
               [self loadQuestionListDataWithType:1];
           }
        }
        [self.tableView reloadData];
    };
    [self.view addSubview:switchButtonView];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self loadQuestionListDataWithType:1];          
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshWithHeaderBlock:^{
        if (weakSelf.isLatestIndex) {
            weakSelf.pageLatest=1;
            [weakSelf loadQuestionListDataWithType:2];
        }else{
            weakSelf.pageHot = 1;
            [weakSelf loadQuestionListDataWithType: 1];
        }

        
    } footerBlock:^{
        if (weakSelf.isLatestIndex) {
            weakSelf.pageLatest++;
            [weakSelf loadQuestionListDataWithType:2];
        }else{
            weakSelf.pageHot++;
            [weakSelf loadQuestionListDataWithType: 1];
        }
    }];
}


- (void)dealloc{
    DebugLog(@"QuestionController 销毁了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setNavgationItem{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tag"] style:UIBarButtonItemStylePlain target:self action:@selector(showTag)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pen"] style:UIBarButtonItemStylePlain target:self action:@selector(writeQuestion)];
    self.navigationItem.titleView = [self customSearchBar];
    
}


- (UIButton *)customSearchBar{
    UIButton *searchButton = [UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 30) title:@"搜索财务内容" font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT imageName:@"search"  target:self actionName:@"search"];
    searchButton.backgroundColor = WHITECOLOR;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.layer.masksToBounds = YES;
    return searchButton;
}


#pragma mark - 响应事件

- (void)showTag{
    
    
}

- (void)writeQuestion{
    AskController *vc = [AskController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)search{
    SearchController *vc = [SearchController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionDetailController *vc = [QuestionDetailController new];
    if (self.isLatestIndex) {
        QuestionModel *model = self.questionLatestList[indexPath.row];
        vc.questionId = model.question_id;
    }else{
        QuestionModel *model = self.questionHotList[indexPath.row];
        vc.questionId = model.question_id;
    }

    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    if (self.isLatestIndex) {
//        [tableView tableViewDisplayViewForRowCount:self.questionLatestList.count reloadEvent:^{
//       }];
//    }else{
//        [tableView tableViewDisplayViewForRowCount:self.questionHotList.count reloadEvent:^{
//        }];
//    }

    if (self.isFirstLoad){
        self.tableView.backgroundView = nil;
    }
    if (self.isLatestIndex) {
        return self.questionLatestList.count;
    }else{
        return self.questionHotList.count;
    }
    return self.questionHotList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.isLatestIndex) {
        cell.questionModel = self.questionLatestList[indexPath.row];

    }else{

        cell.questionModel = self.questionHotList[indexPath.row];
    }
    return cell;
}


#pragma mark - 网络

- (void)loadQuestionListDataWithType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer.hidden=YES;
    if ([self.tableView.mj_header isRefreshing] | [self.tableView.mj_footer isRefreshing] ){

    }else{
        [self showHudInView:self.view];
    }

    /*接口：index/question_list
     参数：
     @param  int  page           第几页(默认第1页)
     @param  int  page_size      每页几条数据(默认6条)
     @param  int  chose_list    列表分类，1:热门、2:最新。默认:2
     @param  string  search_tile    搜索问题关键字（只能用于最新列表。也就是chose_list为2时）*/
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/question_list"];
    //防止searchTitle 不传时崩溃
    NSString *searchText = self.searchTitle == nil ? @"" : self.searchTitle;
    NSInteger pageRequest =self.isLatestIndex?self.pageLatest:self.pageHot;

    NSDictionary *parameter = @{@"page":@(pageRequest),
                                @"page_size":@(10),
                                @"chose_list":@(type),
                                @"search_tile":searchText
                                };

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        self.isFirstLoad = NO;
        [self hideHud];
        
        if (self.tableView.mj_header.isRefreshing){
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.isRefreshing){
            [self.tableView.mj_footer endRefreshing];
        }

        if (self.isLatestIndex==NO&&self.pageHot == 1){
            [self.questionHotList removeAllObjects];
        }
        if (self.isLatestIndex==YES&&self.pageLatest==1){
            [self.questionLatestList removeAllObjects];
        }
        
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            [self.tableView reloadData];
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.isLatestIndex?weakSelf.questionLatestList.count:weakSelf.questionHotList.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf loadQuestionListDataWithType:weakSelf.isLatestIndex?2:1];


            }];
            return;
            
        }else{
            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
            NSArray *array;
            if ([responseObject isKindOfClass:[NSDictionary class]]){
                array = responseObject[@"data_list"];
                NSString *searchCount = responseObject[@"search_count"];
                if (self.finishedSearchQuestion){
                    self.finishedSearchQuestion(searchCount);
                }
            }else{
                array = (NSArray *)responseObject;
            }
            self.tableView.mj_footer.hidden=array.count <10;
            for (NSDictionary *dict in array){
                QuestionModel *model = [QuestionModel mj_objectWithKeyValues:dict];
                if (self.isLatestIndex) {
                    [self.questionLatestList addObject:model];
                }else{
                    [self.questionHotList addObject:model];

                }
            }
            [self.tableView reloadData];
        }
    }];
    
}


@end
