//
//  ChooseItemsCell.h
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/19.
//  Copyright © 2017年 赵帅. All rights reserved.
//  单选或者多选某个条目的cell 

#import <UIKit/UIKit.h>

@interface ChooseItemsCell : UITableViewCell
@property(nonatomic,strong)UIViewController*superVC;
@property (nonatomic,strong) UILabel *starLable;
@property (nonatomic,strong) UILabel *titleLable,*theDetail;

//列表数据数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//设备选中那些数据数组
@property (nonatomic, strong) NSMutableArray *typeSelectedArr;

//选择的个数
@property (nonatomic,assign) int num;

@property(nonatomic,strong)void (^selectTheseItemsInCell)(NSMutableArray*items);

@end
