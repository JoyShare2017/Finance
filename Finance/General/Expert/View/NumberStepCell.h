//
//  NumberStepCell.h
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/18.
//  Copyright © 2017年 赵帅. All rights reserved.
//

/**************************************************************
 @header NumberStepCell
 @version 1.0
 创建时间:2017年07月18日
 @author 赵帅
 @abstract 类似购物车的选择个数
 @discussion 
 变更历史:
 
 **************************************************************/



#import <UIKit/UIKit.h>

@interface NumberStepCell : UITableViewCell
@property (nonatomic,strong) UILabel *starLable;
@property (nonatomic,strong) UILabel *titleLable;

@property (assign, nonatomic) NSInteger  currentNum;//默认显示的数字  默认是1
@property (assign, nonatomic) NSInteger  upLimit;//最大值
@property (assign, nonatomic) NSInteger  downLimit;//最小值
@property (assign, nonatomic) NSInteger  stepCount;//每一步加减的值

@property (nonatomic,strong) UILabel *subTextLabel;
@property (nonatomic, strong) void (^countChanged)(NSInteger count);
@end
