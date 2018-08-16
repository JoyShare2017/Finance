//
//  ChooseAddressViewController.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//  添加或者编辑地址选择区域页面控制器

#import <UIKit/UIKit.h>
#import "Province.h"
#import "City.h"
#import "Country.h"
@interface ChooseAddressViewController : UIViewController
@property(nonatomic,strong)void (^SelectTheRegion)(Province*province , City*city ,Country*county);


@end
