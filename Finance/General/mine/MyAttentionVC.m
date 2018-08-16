//
//  MyAttentionVC.m
//  Finance
//
//  Created by 赵帅 on 2018/4/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyAttentionVC.h"
#import "MyAttentionCell.h"
#import "ExpertModel.h"
#import "ExpertDetailController.h"
@interface MyAttentionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *expertsArr;

@end

@implementation MyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的关注";
    self.expertsArr=[NSMutableArray array];
    self.page=1;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT)
                                         style:(UITableViewStyleGrouped)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;

    self.tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.tableView];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getMyAttentionExperts];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self getMyAttentionExperts];
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    //在没有数据时不显示下拉加载更多
    [footer setTitle:@"" forState:MJRefreshStateIdle];

    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    [self setupDeleteView];
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
        for (ExpertModel*theM in self.expertsArr) {
            theM.isEditSelected=YES;
        }
        [self.tableView  reloadData];
//        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }];
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else{
        for (ExpertModel*theM in self.expertsArr) {
            theM.isEditSelected=NO;
        }
        [self.tableView reloadData];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
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
    self.tableView.sectionHeaderHeight=10;
}

- (void)deleteAction{

 NSMutableArray *idArray = [NSMutableArray array];
    for (ExpertModel*ex in self.expertsArr) {
        if (ex.isEditSelected) {
            [idArray addObject:ex.expert_user_id];
        }
    }
    if (idArray.count<=0) {
        [self showHint:@"请选择专家"];
        return;
    }

    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];
    [KCommonNetRequest deleteMemberFollowWithExpertID:idsStr andComplete:^(BOOL success, id obj) {
        [self hideHud];
        if (success) {
            [self showHint:@"删除成功"];
            self.page=1;
            [self getMyAttentionExperts];
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expertsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionCell"];
    if (cell == nil){
        cell = [[MyAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAttentionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ExpertModel *model = self.expertsArr[indexPath.row];
    cell.expertModel = model;
    cell.superVC=self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing){
        ExpertModel*theModel=self.expertsArr[indexPath.row];
        theModel.isEditSelected=!theModel.isEditSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        return;
    }
    ExpertDetailController *vc = [ExpertDetailController new];
    ExpertModel *model = self.expertsArr[indexPath.row];
    vc.expertUserId = model.expert_user_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 多选删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)getMyAttentionExperts{
//    [self showHudInView:self.tableView];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_follow_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.page),
                                @"page_size":@(6)
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        __weak typeof(self) weakSelf = self;

        if (resultCode != NetworkResultSuceess){
//            [self showHint:(NSString *)responseObject];
            [weakSelf showEmptyDataWithErrorCode:resultCode andView:weakSelf.view andDataCount:weakSelf.expertsArr.count andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf getMyAttentionExperts];

            }];
            return;

        }else{
            if (self.page==1) {
                [self.expertsArr removeAllObjects];
            }
            for (NSDictionary *dict in responseObject){
                ExpertModel *model = [ExpertModel mj_objectWithKeyValues:dict];
                [self.expertsArr addObject:model];
            }
            [self.tableView reloadData];
            [self hideCommonEmptyViewWithView:self.view];
        }

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
