//
//  EditBookOrderVC.m
//  Finance
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "EditBookOrderVC.h"
#import "EmptyReceiptCell.h"
#import "BookOrderCell.h"
#import "AddressOrderCell.h"
#import "NumberStepCell.h"
#import "TextfieldInsertCell.h"
#import "ChooseItemsCell.h"
#import "SubChooseModel.h"
#import "AddAddressViewController.h"
#import "BottomFuncView.h"
#import "OrderMoneyCell.h"
#import "ReceiptAddressViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface EditBookOrderVC ()
@property (nonatomic, strong) UBTableviewTool *myTableview;
@property (nonatomic, strong) SubChooseModel*chooseModel;
@property (nonatomic, strong) BottomFuncView*bto;
@property (nonatomic, strong) NSMutableArray*addressArr;
@property (nonatomic, strong) AddressModel*theAddress;
@property (nonatomic) BOOL isClickChooseAddress;
@end

@implementation EditBookOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"填写订单";
    [self makeUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payResult:) name:KPayResultKey object:nil];
}
-(void)makeUI{
  
    self.myTableview=[[UBTableviewTool alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT-50) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.myTableview];
    __weak typeof(self) weakSelf = self;
    
    self.myTableview.numberOfRow = ^NSInteger(UITableView *tv, NSInteger section) {
        return 6;
    };
    self.myTableview.heightForRow = ^CGFloat(UITableView *tv, NSIndexPath *index) {
        if (index.row==0) {
            if (weakSelf.theAddress) {
                CGFloat height =[NSString heightWithString:weakSelf.theAddress.us_address size:CGSizeMake(SCREEN_WIDTH-40, 60) font:14];
                return 30+20+height+10;
                
                
            }else
                
                return 70;
            
        }else if (index.row==1){
            return 120;
        }else
          return 44;
    };
    self.myTableview.cellForRow = ^UITableViewCell *(UITableView *tv, NSIndexPath *indexPath) {
        if (indexPath.row==0) {
            
            if (!weakSelf.theAddress) {
                if (weakSelf.addressArr.count>=1) {
                    weakSelf.theAddress=weakSelf.addressArr.firstObject;
                }
            }
            
            if (weakSelf.theAddress) {
                AddressOrderCell*cell=[tv dequeueReusableCellWithIdentifier:@"AddressOrderCell"];
                if (!cell) {
                    cell=[[AddressOrderCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddressOrderCell"];
                    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
                }
                cell.address=weakSelf.theAddress;
                return cell;
            }else{
                EmptyReceiptCell*cell=[tv dequeueReusableCellWithIdentifier:@"EmptyReceiptCell"];
                if (!cell) {
                    cell=[[EmptyReceiptCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"EmptyReceiptCell"];
                }
                cell.clickAddBtn = ^(id obj) {
                    AddAddressViewController*address=[AddAddressViewController new];
                    address.updateSuccess = ^(id obj) {
                        [weakSelf getAddressList];
                    };
                    [weakSelf.navigationController pushViewController:address animated:YES];
                };
                return cell;
            }
            
            
        }else if (indexPath.row==1) {
            BookOrderCell*cell=[tv dequeueReusableCellWithIdentifier:@"BookOrderCell"];
            if (!cell) {
                cell=[[BookOrderCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"BookOrderCell"];
            }
            cell.bookModel=weakSelf.book;
            return cell;
        }else if (indexPath.row==2) {
            NumberStepCell*cell=[tv dequeueReusableCellWithIdentifier:@"NumberStepCell"];
            if (!cell) {
                cell=[[NumberStepCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"NumberStepCell"];
                cell.titleLable.text=@"购买数量";
                cell.upLimit=99;
                cell.downLimit=1;
                cell.countChanged = ^(NSInteger count) {
                    [weakSelf countAndPriceChangeWithCount:count];
                };
            }
            return cell;
        }else if (indexPath.row==3) {
            static NSString *cellIdentify = @"ChooseItemsCell";
            ChooseItemsCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentify];
            if (!cell)
            {
                cell = [[ChooseItemsCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLable.text=@"支付方式";
            cell.num=1;
            cell.dataArray= [weakSelf testArr];
            cell.typeSelectedArr=@[weakSelf.chooseModel].mutableCopy;
            cell.selectTheseItemsInCell = ^(NSMutableArray *items) {
                if (items.count>0) {
                    weakSelf.chooseModel=items.firstObject;
                    NSLog(@"支付方式%@%@",weakSelf.chooseModel.model_id,weakSelf.chooseModel.model_name);
                }
                
            };
            cell.superVC=weakSelf;
            return cell;
        }else if (indexPath.row==4) {
            TextfieldInsertCell*cell=[tv dequeueReusableCellWithIdentifier:@"TextfieldInsertCell"];
            if (!cell) {
                cell=[[TextfieldInsertCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"TextfieldInsertCell"];
                cell.titleLable.text=@"买家留言";
                cell.superVC=weakSelf;
            }
            return cell;
        }else{
            OrderMoneyCell*cell=[tv dequeueReusableCellWithIdentifier:@"OrderMoneyCell"];
            if (!cell) {
                cell=[[OrderMoneyCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"OrderMoneyCell"];
                
            }
            [cell updateCount:1 andMoney:weakSelf.book.book_price];
            return cell;
        }
        
        
    };
    self.myTableview.selectRow = ^(UITableView *tv, NSIndexPath *index) {
        [weakSelf.view endEditing:YES];
        if (index.row==0&&self.theAddress) {
            ReceiptAddressViewController*receipt=[ReceiptAddressViewController new];
            receipt.dataArr=weakSelf.addressArr;
            weakSelf.isClickChooseAddress=NO;
            receipt.selectThisAddress = ^(AddressModel *address) {
                NSLog(@"是多少多大的 %@",address.us_name);
                weakSelf.theAddress=address;
                [weakSelf.myTableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                weakSelf.isClickChooseAddress=YES;
            };
            receipt.addressChanged = ^(id obj) {
                [weakSelf getAddressList];
            };
            [weakSelf.navigationController pushViewController:receipt animated:YES];
        }
    };
    _bto=[[BottomFuncView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT-50, SCREEN_WIDTH, 50)];
    _bto.price=self.book.book_price;
    [self.view addSubview:_bto];
    _bto.clickAgree = ^(id obj) {
      //点击提交订单
       [weakSelf addPayOrder];
    };
    
    //获取默认地址
    [self getAddressList];
}

#pragma mark 提交通用订单获取订单id
-(void)addPayOrder{
    if (!self.theAddress) {
        [self showHint:@"请添加收货地址"];
        return;
    }
    NumberStepCell*cellnum=[self.myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    TextfieldInsertCell*liuyancell=[self.myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/alipay/pay_order_user_book"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"book_id":self.book.book_id,
                                @"num":@(cellnum.currentNum),
                                @"address_id":self.theAddress.us_id,
                                @"user_content":liuyancell.titleLable.text
                                };
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode==NetworkResultSuceess) {
            NSLog(@"订单号%@",responseObject);
            if ([weakSelf.chooseModel.model_name hasPrefix:@"支付宝"]) {
               [weakSelf getPayFullStringWithOrderId:(NSString*)responseObject];
            }else if ([weakSelf.chooseModel.model_name hasPrefix:@"微信"]){
                [weakSelf getWechatPayOrderWithOrderId:(NSString*)responseObject];
            }else{
                [weakSelf showHint:@"请选择支付方式"];
            }
            
        } else {
            [weakSelf showHint:(NSString*)responseObject];
        }
    }];
}


#pragma mark 构建支付宝订单
-(void)getPayFullStringWithOrderId:(NSString*)orderid{
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/alipay/pay_alipay_book"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"pbo_id":orderid
                                };
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode==NetworkResultSuceess) {
            NSString *appScheme = @"com.emof.caisou";
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:[NSString stringWithFormat:@"%@",responseObject] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                if (((NSString*)resultDic[@"memo"]).length>0) {
                    [weakSelf showHint:resultDic[@"memo"]];
                }
                
                
            }];
            NSLog(@"订单签名串%@",responseObject);
           
        } else {
            [weakSelf showHint:(NSString*)responseObject];
        }
    }];
}
#pragma mark 构建微信订单
-(void)getWechatPayOrderWithOrderId:(NSString*)orderid{
    __weak typeof(self) weakSelf = self;
    
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/alipay/wx_alipay_book"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"pbo_id":orderid
                                };
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode==NetworkResultSuceess) {
            
            NSLog(@"微信订单%@",responseObject);
            NSDictionary*dict=responseObject;
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"mch_id"];
            req.prepayId            = [dict objectForKey:@"prepay_id"];
            req.nonceStr            = [dict objectForKey:@"nonce_str"];
            req.timeStamp           = [[dict objectForKey:@"time_stamp"]intValue];
            req.package             = [dict objectForKey:@"package_value"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            
        } else {
            [weakSelf showHint:(NSString*)responseObject];
        }
    }];
}

#pragma mark 监听支付结果的通知
-(void)payResult:(NSNotification*)noti{
    if ([noti.object isEqualToString:@"1"]) {
        [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"提示" message:@"付款成功，我们会尽快为您发货" alertBlock:^(id obj) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:@"提示" message:@"支付失败,请重试" alertBlock:^(id obj) {
            
        }];

    }
}

#pragma mark 更新数量及价格
-(void)countAndPriceChangeWithCount:(NSInteger)count{
    BookOrderCell*cellBook=[self.myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    OrderMoneyCell*cellmoney=[self.myTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
//    cellBook.priceLabel.text=[NSString stringWithFormat:@"%.2lf",[self.book.book_price floatValue]*count ];
    cellBook.count=count;

    [cellmoney updateCount:count andMoney:self.book.book_price];
    _bto.price=[NSString stringWithFormat:@"%.2lf",[self.book.book_price floatValue]*count];;
  
}



-(void)getAddressList{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/user_address_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name};
    
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode==NetworkResultSuceess) {
            self.addressArr=[NSMutableArray array];
            for (NSDictionary*dic in responseObject) {
                AddressModel*model=[AddressModel mj_objectWithKeyValues:dic];
                [self.addressArr addObject:model];
            }
            [self.myTableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        }
    }];
}


-(NSMutableArray*)testArr{
    
    NSMutableArray*theArr=[NSMutableArray array];
    for (int i=0; i<2; i++) {
        SubChooseModel*model=[SubChooseModel new];
        model.model_id=[NSString stringWithFormat:@"%zd",i];
        model.model_name=@[@"支付宝支付",@"微信支付"][i];
        [theArr addObject:model];
        if (!self.chooseModel&&i==0) {
            self.chooseModel=model;
        }
    }
    return theArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.addressArr.count>0) {

        //如果之前选择的地址被删除
        BOOL isExited = NO;
        for (AddressModel*add in self.addressArr) {
            if ([add.us_id isEqualToString:self.theAddress.us_id]) {
                isExited=YES;
                break;
            }
        }
        if (!isExited) {
            self.theAddress=self.addressArr.firstObject;
            [self.myTableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }
        
    }else{
        self.theAddress=nil;
        [self.myTableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KPayResultKey object:nil];
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
