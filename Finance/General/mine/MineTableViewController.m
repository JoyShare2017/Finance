//
//  MineTableViewController.m
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "MineTableViewController.h"
#import "MineItemTableViewCell.h"
#import "HeadAndNameCell.h"
#import "MyAskController.h"
#import "MyAnswerController.h"
#import "MyCollectVC.h"
#import "MyAttentionVC.h"
#import "BecomeExpertController.h"
#import "HasBecomeExpertController.h"
#import "MyTagViewController.h"
#import "LoginController.h"
#import "ExpertDetailModel.h"
#import "ReviewController.h"//审核进度
#import "MessageController.h"
@interface MineTableViewController ()
@property (nonatomic, strong) UBButton *collectBtn;
@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:250/255.0 alpha:1];
    self.tableView.bounces = NO;
    //去掉cell多余分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //去掉自带分割线
    self.tableView.separatorStyle = NO;
    
    //解决tabbleview底部被遮挡问题
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"MineItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineItemTableViewCell"];

    [[UserAccountManager sharedManager] addObserver:self forKeyPath:@"isUserLogin" options:(NSKeyValueObservingOptionNew) context:nil];

    [self makeLeftAndRightBtnItems];

    
}

-(void)makeLeftAndRightBtnItems{

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"clock"] style:UIBarButtonItemStylePlain target:self action:@selector(showMessage)];
    //退出按钮
    _collectBtn=[[UBButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_collectBtn setImage:[UIImage imageNamed:@"tuichu"] forState:(UIControlStateNormal)];
    [_collectBtn addAction:^(UBButton *button) {
        if ([UserAccountManager sharedManager].isUserLogin) {
            [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"确定退出账号?" CancelTitle:@"取消" ConfirmTitle:@"确认" message:@"" cancelBlock:^(id obj) {

            } confirmBlock:^(id obj) {
                [[UserAccountManager sharedManager] deleteAccount];
            }];
        }
    }];

    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];
    self.navigationItem.rightBarButtonItem =collectItem;
    self.collectBtn.hidden=![[UserAccountManager sharedManager]isUserLogin];

}

- (void)showMessage{
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        MessageController *vc = [MessageController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12)];
    headerView.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:250/255.0 alpha:1];
    return headerView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 3;
    }else if(section == 3){
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HeadAndNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadAndNameCell"];
        if (!cell) {
            cell=[[HeadAndNameCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HeadAndNameCell"];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.superVc=self;
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        // Configure the cell...
        
        return cell;
    }else{
        MineItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemTableViewCell" forIndexPath:indexPath];

        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.itemImage.image = [UIImage imageNamed:@"tiwen"];
                cell.itemLabel.text = @"我的提问";
            }else if(indexPath.row == 1){
                cell.itemImage.image = [UIImage imageNamed:@"huida"];
                cell.itemLabel.text = @"我的回答";
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                cell.itemImage.image = [UIImage imageNamed:@"sholucang"];
                cell.itemLabel.text = @"我的收藏";
            }else if(indexPath.row == 1){
                cell.itemImage.image = [UIImage imageNamed:@"guanzhu"];
                cell.itemLabel.text = @"我的关注";
            }else if(indexPath.row == 2){
                cell.itemImage.image = [UIImage imageNamed:@"guanzhu"];
                cell.itemLabel.text = @"我的标签";
            }
        }else if(indexPath.section == 3){
            if (indexPath.row == 0) {
                cell.itemImage.image = [UIImage imageNamed:@"chengweizhuanjia"];
                cell.itemLabel.text = @"成为专家";
            }else if(indexPath.row == 1){
                cell.itemImage.image = [UIImage imageNamed:@"fenxiang"];
                cell.itemLabel.text = @"分享APP";
            }
        }
        
        return cell;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else{
        return 45;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 12;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if (indexPath.section==1||indexPath.section==2||(indexPath.section==3&&indexPath.row==0)) {
            if (![self judegLoginWithSuperVc:self]) {
                return;
            }

            
        }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MyAskController *vc = [MyAskController new];
            [self.navigationController pushViewController:vc animated:YES];

        }else if(indexPath.row == 1){
            MyAnswerController *vc = [MyAnswerController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            MyCollectVC *vc = [MyCollectVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            MyAttentionVC *vc = [MyAttentionVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            //我的标签
            [self.navigationController pushViewController:[MyTagViewController new] animated:YES];

        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {

            [self showHudInView:self.view];
            [KCommonNetRequest getExpertInfoWithExpertId:nil andComplete:^(BOOL success, id obj) {
                [self hideHud];
                if (success) {
                    if ([obj isKindOfClass:[ExpertDetailModel class]]) {
                        ExpertDetailModel*model=(ExpertDetailModel*)obj;
                        if ([model.expert_progress isEqualToString:@"99"]) {
                          HasBecomeExpertController *vc = [HasBecomeExpertController new];
                         [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            ReviewController *vc = [ReviewController new];
                            vc.oldModel=model;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }else{
                    BecomeExpertController *vc = [[UIStoryboard storyboardWithName:@"BecomeExpertController" bundle:nil] instantiateViewControllerWithIdentifier:@"BecomeExpert"];
                        [self.navigationController pushViewController:vc animated:YES];
                }
                
            }];

        }else if(indexPath.row == 1){
            [self shareWebPageWithUrl:nil andTitle:nil  andShareCallback:^(NSString *type, id data) {
            }];
        }
    }

}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.collectBtn.hidden=![[UserAccountManager sharedManager]isUserLogin];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[UserAccountManager sharedManager]removeObserver:self forKeyPath:@"isUserLogin" context:nil];
}
@end
