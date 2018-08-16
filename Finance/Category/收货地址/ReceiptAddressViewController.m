//
//  ReceiptAddressViewController.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/18.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "ReceiptAddressViewController.h"
#import "ReceiptAddressCell.h"
#import "RegionParserTool.h"
#import "AddAddressViewController.h"
@interface ReceiptAddressViewController ()
@property(nonatomic,strong)UBButton *reloadBtn;

@end

@implementation ReceiptAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收货地址";
    self.view.backgroundColor=[UIColor whiteColor];

    [self makeUI];
    
}
-(void)makeUI{
 
    //tableview
    
    __weak typeof(self) weakSelf = self;
    self.tableView=[[UBTableviewTool alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-50) style:(UITableViewStyleGrouped)];
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    } else {
        // Fallback on earlier versions
    }
    self.tableView.numberOfSection=^NSInteger(UITableView*tv){
        return weakSelf.dataArr.count;
    };
    
    
    self.tableView.numberOfRow=^NSInteger(UITableView*tv,NSInteger section){
        
        
        return 1;
        
        
    };
    
    self.tableView.heightForRow=^CGFloat(UITableView*tv,NSIndexPath*index){
     
            return 100;
        
    };
    
    self.tableView.heightHeader=^CGFloat(UITableView*tv,NSInteger section){
        return  section==0?0.1:15;
    };
    
    self.tableView.cellForRow=^UITableViewCell*(UITableView*tv,NSIndexPath*index){
        
        static NSString*cellId=@"cellid";
        ReceiptAddressCell*cell=[tv dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell=[[ReceiptAddressCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        }
        cell.mySuperVc=weakSelf;
        cell.addModel=weakSelf.dataArr[index.section];
        return cell;
        
        
    };
    self.tableView.selectRow = ^(UITableView *tv, NSIndexPath *index) {
        AddressModel*test=weakSelf.dataArr[index.section ];
        NSLog(@"click %@",test.us_name);
        if (weakSelf.selectThisAddress) {
           weakSelf.selectThisAddress(weakSelf.dataArr[index.section]);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.tableView];
    
    
    
    
   MJRefreshNormalHeader*header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAddressList];
    }];
    self.tableView.mj_header=  header;
    
    
    //完成按钮
    
    
    UBButton*completeBtn=[[UBButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT-50, SCREEN_WIDTH, 50)];
    [completeBtn setTitle:@"添加新地址" forState:(UIControlStateNormal)];
    completeBtn.selected=YES;
    completeBtn.backgroundColor=MAJORCOLOR;
    [completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal )];
    [completeBtn addAction:^(UBButton *button) {
        
        AddAddressViewController*addvc=[AddAddressViewController new];
        addvc.updateSuccess = ^(id obj) {
            [weakSelf getAddressList];
            if (weakSelf.addressChanged) {
                weakSelf.addressChanged(@"");
            }
        };
        [weakSelf.navigationController pushViewController:addvc animated:YES];
        
        
    }];
    
    [self.view addSubview:completeBtn];
    
}
-(void)getAddressList{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/user_address_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name};
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (self.dataArr) {
            [self.dataArr removeAllObjects];
        }else{
            self.dataArr=[NSMutableArray array];            
        }
        [self.tableView.mj_header endRefreshing];
        if (resultCode==NetworkResultSuceess) {
            for (NSDictionary*dic in responseObject) {
                AddressModel*model=[AddressModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
        }
        [self.tableView reloadData];
    }];
}

-(UBButton *)reloadBtn{
    __weak typeof(self) weakSelf = self;
    if (!_reloadBtn) {
        _reloadBtn=[[UBButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-100, 60, 200, 40)];
        [_reloadBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_reloadBtn setTitle:@"暂无数据，点击重试" forState:(UIControlStateNormal)];
        _reloadBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _reloadBtn.hidden=YES;
        [_tableView addSubview:_reloadBtn];
        [_reloadBtn addAction:^(UBButton *button) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }
    return _reloadBtn;
    
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
