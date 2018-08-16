//
//  ReceiptAddressCell.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/18.
//  Copyright © 2016年 lsj. All rights reserved.
//  收货地址的cell

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "ReceiptAddressViewController.h"

@interface ReceiptAddressCell : UITableViewCell
@property(nonatomic,strong)ReceiptAddressViewController*mySuperVc;
@property(nonatomic,strong)AddressModel*addModel;
@property(nonatomic)BOOL isTheOnlyOne;

@end
