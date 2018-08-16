//
//  EmptyReceiptCell.h
//  Finance
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//  未选择收货地址 有个收货地址按钮的cell

#import <UIKit/UIKit.h>

@interface EmptyReceiptCell : UITableViewCell
@property (nonatomic, strong) void (^clickAddBtn)(id obj);
@end
