//
//  MessageController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/27.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "QuestionDetailController.h"
@interface MessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageList;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *noMessageView;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation MessageController


- (NSMutableArray *)messageList{
    if (_messageList == nil){
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT)];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.backgroundColor = GRAYCOLOR_BACKGROUND;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    [self setupDeleteView];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.view bringSubviewToFront:self.footerView];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 90;
    // 编辑模式的时候可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = item;

    self.page = 1;
    self.isFirstLoad = YES;
    [self loadMessageList];
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
    [deleteButton addTarget:self action:@selector(commitDeleteMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:selectAllButton];
    [footerView addSubview:deleteButton];
}


- (void)deleteMessage{
    NSArray *selectedIndexPaths = self.tableView.indexPathsForSelectedRows;
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.messageList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isSame = NO;
        for (NSIndexPath *indexPath in selectedIndexPaths){
            if (indexPath.row == idx){
                isSame = YES;
                break; //退出内层的for循环
            }
        }
        
        if (isSame == NO){
            [tempArray addObject:self.messageList[idx]];
        }
    }];
    
    self.messageList = tempArray;
    [self.tableView reloadData];
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
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
}


- (void)rightBarItemClick:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"编辑"]) {
        if (self.messageList.count == 0) {
            return;
        }
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



//#pragma mark - UITabelViewDataSource
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

//#pragma mark - 左滑出现多个按钮
//
///**
// *  只要实现了这个方法，左滑出现按钮的功能就有了
// (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
// */
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

///**
// *  左滑cell时出现什么按钮
// */
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了关注");
//
//        // 收回左滑出现的按钮(退出编辑模式)
//        tableView.editing = NO;
//    }];
//
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self.messageList removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//
//    return @[action1, action0];
//}

#pragma mark - 实现多选
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     1.单独的 delete 可以实现左滑删除, 只要在commitEditingStyle中判断editingStyle == UITableViewCellEditingStyleDelete再进行删除操作即可
     2.delete 和 insert 组合可以实现多选,但组合情况下不会调用commitEditingStyle
     */

    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.messageList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


//#pragma mark - 插入 cell

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        [self.messageList insertObject:@(10) atIndex:indexPath.row];
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    }
//
//}
//
////修改Delete按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"添加";
//}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayViewForRowCount:self.messageList.count customImage:@"no_info" customText:@"还没有消息内容"];
    if (self.isFirstLoad){
        tableView.backgroundView = nil;
    }
    return self.messageList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.messageModel = self.messageList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing==YES) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel*msg=self.messageList[indexPath.row];
    QuestionDetailController*detail=[QuestionDetailController new];
    detail.questionId=msg.mu_question_id;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)commitDeleteMessage{
    /*接口：member/index/message_notification_del
     参数：
     @param  int        user_id       * 用户的id
     @param  string      user_name    * 用户名
     @param  string      mn_id        * 消息的id，多个逗号隔开*/

    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *idArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths){
        MessageModel *model = self.messageList[indexPath.row];
        [idArray addObject:model.mn_id];
    }
    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"删除中...."];

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/message_notification_del"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{
                                @"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"mn_id":idsStr,
                                };

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }

        [self deleteMessage];
    }];

}


- (void)loadMessageList{
    /*接口：member/index/message_notification_list
     参数：
     @param  int        user_id       * 用户的id
     @param  string      user_name    * 用户名
     @param  int     page           第几页(默认第1页)
     @param  int     page_size     每页几条数据(默认6条)
     */
    [self showHudInView:self.view];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/message_notification_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{
                                @"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"page":@(self.page),
                                @"page_size":@(6)
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        self.isFirstLoad = NO;
        [self hideHud];
        [self.tableView reloadData];

        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }

        for (NSDictionary *dict in responseObject){
            MessageModel *model = [MessageModel mj_objectWithKeyValues:dict];
            [self.messageList addObject:model];
        }
        [self.tableView reloadData];
    }];

}




@end
