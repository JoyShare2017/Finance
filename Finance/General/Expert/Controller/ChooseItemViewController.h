//
//  ChooseItemViewController.h
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/19.
//  Copyright © 2017年 赵帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubChooseModel.h"
@interface ChooseItemViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
//列表数据数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//设备选中那些数据数组
@property (nonatomic, strong) NSMutableArray *typeSelectedArr;

//选择的个数
@property (nonatomic,assign) int num;

@property(nonatomic,strong)void (^selectTheseItems)(NSMutableArray*items);

@end
