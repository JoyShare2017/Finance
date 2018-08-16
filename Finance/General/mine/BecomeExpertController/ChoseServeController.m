//
//  ChoseServeController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/1.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ChoseServeController.h"
#import "ChoseServeCell.h"

@interface ChoseServeController ()
@property (nonatomic, strong) NSMutableArray *services;
@end

@implementation ChoseServeController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"成为专家";
    [self.tableView registerNib:[UINib nibWithNibName:@"ChoseServeCell" bundle:nil] forCellReuseIdentifier:@"ChoseServeCellIdentity"];
    self.tableView.backgroundColor = GRAYCOLOR_BACKGROUND;
    self.tableView.separatorColor = GRAYCOLOR_BORDER;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);

    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BUTTON_HEIGHT+30)];
    footerView.backgroundColor = GRAYCOLOR_BACKGROUND;
    UIButton *commitButton = [UIButton buttonWithFrame:CGRectMake(MARGIN_BIG, 30, SCREEN_WIDTH-MARGIN_BIG*2, BUTTON_HEIGHT) title:@"确认提交" font:FONT_NORMAL titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"uploadInfo"];
    [footerView addSubview:commitButton];
    self.tableView.tableFooterView = footerView;
    __weak typeof(self) weakSelf = self;

    [KCommonNetRequest getExpertServerListAndComplete:^(BOOL success, id obj) {
        if (success) {
            if ([obj isKindOfClass:[NSMutableArray class]]) {
                weakSelf.services=obj;
                [weakSelf.tableView reloadData];
            }
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.services.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoseServeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoseServeCellIdentity"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.theModel=self.services[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


- (void)uploadInfo{
    [self showHudInView:self.view];
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/upgrade_expert"];

    NSMutableArray *selectedIDs = [NSMutableArray array];

    for (ConsultModel*selModel in self.services) {
        if (selModel.add_ok) {
            [selectedIDs addObject:selModel.es_id];
        }
    }
    NSString *selectedSeverIDStr = [selectedIDs componentsJoinedByString:@","];
    [self.infoDict setObject:selectedSeverIDStr forKey:@"expert_server"];

    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{
                                @"user_id": user.user_id,
                                @"user_name": user.user_name
                                };
    NSMutableDictionary *finalParameter = [NSMutableDictionary dictionary];
    [finalParameter addEntriesFromDictionary:self.infoDict];
    [finalParameter addEntriesFromDictionary:parameter];


    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:finalParameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }

        [self showHint:@"提交成功"];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }];
}

@end
