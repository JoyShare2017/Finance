//
//  ReceiptAddressViewController.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/18.
//  Copyright © 2016年 lsj. All rights reserved.
//  收货地址页面控制器

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIViewController+HUD.h"
#import "AddressModel.h"
@interface ReceiptAddressViewController : UIViewController
@property(nonatomic,strong)UBTableviewTool*tableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic, strong) void (^selectThisAddress)(AddressModel*address);

@property (nonatomic, strong) void (^addressChanged)(id obj);

@end
