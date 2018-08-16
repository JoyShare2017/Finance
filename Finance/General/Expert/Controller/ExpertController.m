//
//  ExpertController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ExpertController.h"
#import "ExpertCell.h"
#import "ExpertModel.h"
#import "SearchController.h"
#import <CFDropDownMenuView/CFDropDownMenuView.h>
#import "ExpertDetailController.h"
#import "MessageController.h"
#import "AskController.h"
#import "HasBecomeExpertController.h"

#define DownMenuView_Height 45

@interface ExpertController ()<CFDropDownMenuViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *conditions;
@property (nonatomic, strong) NSMutableArray *conditionIndexs;
@property (nonatomic, strong) NSMutableDictionary *conditionParameter;
@property (nonatomic, strong) NSMutableArray *experts;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) NSInteger page;


@end

@implementation ExpertController

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DownMenuView_Height, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-DownMenuView_Height-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = GRAYCOLOR_BORDER;
        _tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
    }
    return _tableView;
}

- (NSMutableArray *)experts{
    if (_experts == nil){
        _experts = [NSMutableArray array];
    }
    return _experts;
}


- (NSMutableArray *)conditionIndexs{
    if (_conditionIndexs == nil){
        _conditionIndexs = [NSMutableArray array];
    }
    return _conditionIndexs;
}


- (NSMutableDictionary *)conditionParameter{
    if (_conditionParameter == nil){
        _conditionParameter = [NSMutableDictionary dictionary];
    }
    return _conditionParameter;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    [self setNavgationItem];
    self.isFirstLoad = YES;
    [self.view addSubview:self.tableView];

    CFDropDownMenuView *conditionView = [self setConditionView];
    [self.view addSubview:conditionView];
    self.tableView.tableFooterView=[UIView new];
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshWithHeaderBlock:^{
        weakSelf.page = 1;
        [weakSelf.experts removeAllObjects];
        [weakSelf loadExpertList];
    } footerBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf loadExpertList];
    }];
    [self.tableView.mj_header beginRefreshing];

    [[UserAccountManager sharedManager] addObserver:self forKeyPath:@"isUserLogin" options:(NSKeyValueObservingOptionNew) context:nil];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.tableView.y = self.tableView.y + 45;
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 专家筛选

- (CFDropDownMenuView *)setConditionView{
    //  创建
    CFDropDownMenuView *dropDownMenuView = [[CFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, DownMenuView_Height)];
    dropDownMenuView.backgroundColor = GRAYCOLOR_BACKGROUND;
    dropDownMenuView.stateConfigDict = @{
                                         @"selected" : @[MAJORCOLOR, @"triangle_solid_selected"],
                                         @"normal" : @[GRAYCOLOR_TEXT, @"triangle_solid"]
                                         };
    /**
     *  stateConfigDict 属性 格式 详见CFDropDownMenuView.h文件
     *  可不传  使用默认样式  /   也可自定义样式
     */
    // 注: 需先赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    NSMutableArray *conditions = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];

    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"expertCondition.plist"];
    NSDictionary *allConditions = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    if (!allConditions) {
        dropDownMenuView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0);
         _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-49);
        return nil;
    }
    NSArray *industrys = allConditions[KEY_EXPERT_INDUSTRY];
    NSArray *qualifieds = allConditions[KEY_EXPERT_QUALIFIED];
    NSArray *skilleds = allConditions[KEY_EXPERT_SKILLED];

    if (industrys){
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        [nameArray addObject:@"全部"];
        [idArray addObject:@"0"];
        for(NSDictionary *dict in industrys){
            [nameArray addObject:[dict allValues][0]];
            [idArray addObject:[dict allKeys][0]];
        }
        [conditions addObject:nameArray];
        [titles addObject:@"选择行业专家"];
        [self.conditionIndexs addObject:idArray];
    }

    if (qualifieds){
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        [nameArray addObject:@"全部"];
        [idArray addObject:@"0"];
        for(NSDictionary *dict in qualifieds){
            [nameArray addObject:[dict allValues][0]];
            [idArray addObject:[dict allKeys][0]];
        }
        [conditions addObject:nameArray];
        [titles addObject:@"选择专家资质"];
        [self.conditionIndexs addObject:idArray];
    }

    if (skilleds){
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *idArray = [NSMutableArray array];
        [nameArray addObject:@"全部"];
        [idArray addObject:@"0"];
        for(NSDictionary *dict in skilleds){
            [nameArray addObject:[dict allValues][0]];
            [idArray addObject:[dict allKeys][0]];
        }
        [conditions addObject:nameArray];
        [titles addObject:@"选择擅长领域"];
        [self.conditionIndexs addObject:idArray];
    }

    if (!conditions) {
        conditions=[NSMutableArray array];
    }
    if (!titles) {
        titles=[NSMutableArray array];
    }
    dropDownMenuView.dataSourceArr = conditions;
    dropDownMenuView.defaulTitleArray = titles;

//    dropDownMenuView.dataSourceArr = self.conditions.mutableCopy;
//    dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"选择行业专家",@"选择专家资质", @"选择擅长领域", nil];
    // 设置代理
    dropDownMenuView.delegate = self;
    // 下拉列表 起始y
    dropDownMenuView.startY = CGRectGetMaxY(dropDownMenuView.frame);
    
    /**
     *  获取点击事件
     */
    __weak typeof(self) weakSelf = self;
    dropDownMenuView.chooseConditionBlock = ^(NSInteger currentTitleIndex, NSString *currentTitle, NSArray *currentTitleArray,NSInteger index){
        
        NSArray *fields = @[@"expert_hangye",@"expert_dengji",@"expert_lingyu"];
        if (index != 0){
            [weakSelf.conditionParameter setObject:self.conditionIndexs[currentTitleIndex][index] forKey:fields[currentTitleIndex]];
        }else{
            [weakSelf.conditionParameter removeObjectForKey:fields[currentTitleIndex]];
        }

        [self.experts removeAllObjects];
        self.page = 1;
        [self loadExpertList];
    };
    
    return dropDownMenuView;
}


//- (void)loadAllExpertCondition{
//    //防止网络未连接->重新连接, 刷新条件视图,但是conditionParameter 仍然保持上次的选择结果, 导致界面没有选中任何条件但是网络请求中包含条件的 bug
//    [self.conditionParameter removeAllObjects];
//
//    NSArray *urls = @[@"expert_hangye_list",@"expert_zizhi_list",@"expert_lingyu_list"];
//    dispatch_group_t group = dispatch_group_create();
//    __weak typeof(self) weakself = self;
//    [self showHudInView:self.view];
//
//    for (int i=0;i<urls.count;i++){
//        NSString *urlStr = [OPENAPIHOST stringByAppendingFormat:@"member/index/%@",urls[i]];
//        //进组
//        dispatch_group_enter(group);
//        [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:nil callback:^(NetworkResult resultCode, id responseObject) {
//            if (resultCode != NetworkResultSuceess){
////                [self showHint:(NSString *)responseObject];
//                return;  //出现错误,退出循环
//            }else{
//                //出组
//                dispatch_group_leave(group);
//                [self handleResponseObject:responseObject index:i];
//            }
//        }];
//    }
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        CFDropDownMenuView *conditionView = [self setConditionView];
//        [self.view addSubview:conditionView];
//
//        [self loadExpertList];
//    });
//
//}
//
//
//- (void)handleResponseObject:(id)responseObject index:(int)i{
//    NSArray *conditionNameFields = @[@"meh_name",@"mez_name",@"mel_name",@"es_name"];
//    NSArray *indexFields = @[@"meh_id",@"mez_id",@"mel_id"];
//    NSArray *titles = @[@"全部",@"全部",@"全部"];
//    //@[@"全部行业",@"全部资质",@"全部领域"];
//    NSMutableArray *conditionNameArray = [NSMutableArray arrayWithObject:titles[i]];
//    NSMutableArray *conditionIndexArray = [NSMutableArray arrayWithObject:@(0)];
//
//    for (NSDictionary *dict in responseObject){
//        [conditionNameArray addObject:dict[conditionNameFields[i]]];
//        [conditionIndexArray addObject:dict[indexFields[i]]];
//    }
//
//    [self.conditions replaceObjectAtIndex:i withObject:conditionNameArray];
//    [self.conditionIndexs replaceObjectAtIndex:i withObject:conditionIndexArray];
//    //        [self.conditions insertObject:mArray atIndex:i];
//
//}


#pragma mark - 界面

- (void)setNavgationItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"clock"] style:UIBarButtonItemStylePlain target:self action:@selector(showMessage)];
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

- (void)showMessage{
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        MessageController *vc = [MessageController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 45;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [self setConditionView];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [tableView tableViewDisplayViewForRowCount:self.experts.count reloadEvent:^{
////        [self loadAllExpertCondition];
//        [self loadExpertList];
//    }];

    if (self.isFirstLoad){
        self.tableView.backgroundView = nil;
    }
    return self.experts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[ExpertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.experts.count>indexPath.row) {
        ExpertModel *model = self.experts[indexPath.row];
        cell.expertModel = model;
    }
    cell.superVC=self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ExpertModel *model = self.experts[indexPath.row];
    if ([model.expert_user_id isEqualToString:[UserAccountManager sharedManager].userAccount.user_id]) {
        HasBecomeExpertController *vc = [HasBecomeExpertController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ExpertDetailController *vc = [ExpertDetailController new];
        vc.expertUserId = model.expert_user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }

}



- (void)loadExpertList{
    __weak typeof(self) weakSelf = self;

    /*接口：index/expert_list
     参数：
     @param  int     user_id        用户的id
     @param  string      user_name      用户名
     @param  int        page           第几页(默认第1页)
     @param  int       page_size 每页几条数据(默认6条)
     @param  int         expert_hangye       专家的行业
     @param  int         expert_dengji       专家的资质
     @param  int         expert_lingyu       专家的领域
     @param  string     search_expert       搜索专家*/
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!user) {
        user=[[UserAccount alloc]init];
    }
    //防止searchTitle 不传时崩溃
    NSString *searchExpertName = self.searchExpert == nil ? @"" : self.searchExpert;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.page),
                                @"page_size":@(10),
                                @"search_expert":searchExpertName
                                };

    NSMutableDictionary *mParameter = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if(self.conditionParameter.count){
        [mParameter addEntriesFromDictionary: self.conditionParameter];
    }
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:mParameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        self.isFirstLoad = NO;

        //停止上拉刷新
        if (self.tableView.mj_header.isRefreshing){
            [self.tableView.mj_header endRefreshing];
        }

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            [self.tableView reloadData];
            //停止下拉加载更多
            if (self.tableView.mj_footer.isRefreshing){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.tableView andDataCount:weakSelf.experts.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf loadExpertList];
            }];

            
        }else{
            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
            NSArray *array;
            if ([responseObject isKindOfClass:[NSDictionary class]]){
                array = responseObject[@"data_list"];
                NSString *searchCount = responseObject[@"search_count"];
                if (self.finishedSearchExpert){
                    self.finishedSearchExpert(searchCount);
                }
            }else{
                array = (NSArray *)responseObject;
            }
            self.tableView.mj_footer.hidden=array.count<10;
            for (NSDictionary *dict in array) {
                ExpertModel *model = [ExpertModel mj_objectWithKeyValues:dict];
                [self.experts addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.page=1;
    [self.tableView.mj_header beginRefreshing];
}

-(void)dealloc{
    [[UserAccountManager sharedManager]removeObserver:self forKeyPath:@"isUserLogin" context:nil];
}

@end
