//
//  MyDetailInfoVC.m
//  Finance
//
//  Created by 赵帅 on 2018/4/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyDetailInfoVC.h"
#import "MyHeadCell.h"
#import "MyInfoCell.h"
@interface MyDetailInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableInfo;
@property (nonatomic, strong) NSArray *itemArr,*contentArr;

@property (nonatomic, copy) NSString *imgSeverUrl;

@end

@implementation MyDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=WHITECOLOR;
    self.title=@"我的资料";
    if (!self.imgSeverUrl) {
        self.imgSeverUrl=[UserAccountManager sharedManager].userAccount.user_image;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.tableInfo=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT) style:(UITableViewStyleGrouped)];
    self.tableInfo.delegate=self;
    self.tableInfo.dataSource=self;
    [self.view addSubview:self.tableInfo];
    self.tableInfo.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath. section==0) {
        return 80;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString*cellId=@"MyHeadCell";
        MyHeadCell*cell=[tableView dequeueReusableCellWithIdentifier:cellId];

        if (!cell) {
            cell=[[MyHeadCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        }
        cell.superVc=self;
        cell.itemLb.text=@"头   像";
        __weak typeof(self) weakSelf = self;

        cell.getTheHeadImgUrl = ^(NSString *imgUrl) {
            weakSelf.imgSeverUrl=imgUrl;

        } ;
        return cell;

    }else{

        static NSString*cellId=@"MyInfoCell";
        MyInfoCell*cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell=[[MyInfoCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        }
        cell.itemLb.text=self.itemArr[indexPath.row];
        cell.contentTF.placeholder=[NSString stringWithFormat:@"请输入%@",self.itemArr[indexPath.row]];
        cell.contentTF.text=self.contentArr[indexPath.row];
        return cell;
    }
    return nil;
}




-(void)save{
    [self showHudInView:self.view];
    [self.view endEditing:YES];
    MyInfoCell*cellname=[self.tableInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    MyInfoCell*cellqianming=[self.tableInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    MyInfoCell*cellarea=[self.tableInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    MyInfoCell*cellindustry=[self.tableInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    MyInfoCell*celljob=[self.tableInfo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/update_member"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"user_qianming":cellqianming.contentTF.text,
                                @"user_nick_name":cellname.contentTF.text,
                                @"user_area":cellarea.contentTF.text,
                                @"user_industry":cellindustry.contentTF.text,
                                @"user_position":celljob.contentTF.text,
                                @"user_image":self.imgSeverUrl,

                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;

        }else{
            [self showHint:@"修改成功"];
            NSLog(@"修改成功%@",self.imgSeverUrl);
            [[UserAccountManager sharedManager].userAccount setUser_nick_name:cellname.contentTF.text];
            [[UserAccountManager sharedManager].userAccount setUser_qianming:cellqianming.contentTF.text];
            [[UserAccountManager sharedManager].userAccount setUser_area:cellarea.contentTF.text];
            [[UserAccountManager sharedManager].userAccount setUser_industry:cellindustry.contentTF.text];
            [[UserAccountManager sharedManager].userAccount setUser_position:celljob.contentTF.text];
            [[UserAccountManager sharedManager].userAccount setUser_image:self.imgSeverUrl];
            [[UserAccountManager sharedManager] saveAccount];
            if (self.didChangedMyInfo) {
                self.didChangedMyInfo(@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];


    if (keyboardF.origin.y > self.view.height) {
        // 键盘的Y值已经远远超过了控制器view的高度
        //键盘退下，View恢复原状
        [UIView animateWithDuration:duration animations:^{
            self.view.y = NAVGATION_MAXY;
        }];
    }
    else
    {
        //键盘弹出，判断键盘有没有遮住当前选中的文本框，如果有遮住View往上移动，这里216是键盘高度，加60是让文本框离键盘最顶部又一段距离。
        CGFloat offset = USEABLE_VIEW_HEIGHT-320-keyboardF.size.height;
        if (offset <= 0) {
            [UIView animateWithDuration:duration animations:^{
                self.view.y = offset;
            }];
        }
    }
}





-(NSArray *)itemArr{
    if (!_itemArr) {
        _itemArr=@[@"用户名",@"签   名",@"地   区",@"行   业",@"职   位"];
    }
    return _itemArr;
}
-(NSArray *)contentArr{
    if (!_contentArr) {
        UserAccount*account=[UserAccountManager sharedManager].userAccount;
        _contentArr=@[account.user_nick_name?account.user_nick_name:@"",
                      account.user_qianming?account.user_qianming:@"",
                      account.user_area?account.user_area:@"",
                      account.user_industry?account.user_industry:@"",
                      account.user_position?account.user_position:@""];
    }
    return _contentArr;
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
