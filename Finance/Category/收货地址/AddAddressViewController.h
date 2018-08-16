//
//  AddAddressViewController.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/19.
//  Copyright © 2016年 lsj. All rights reserved.
//  添加地址/编辑地址 控制器

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface AddAddressViewController : UIViewController
@property(nonatomic,strong)AddressModel* oldAddress;
@property (nonatomic, strong) void (^updateSuccess)(id obj);
@end
