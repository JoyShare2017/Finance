//
//  BookOrderCell.h
//  Finance
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//  封面 标题 价格数量

#import <UIKit/UIKit.h>
#import "BookModel.h"
@interface BookOrderCell : UITableViewCell
@property (nonatomic, strong) BookModel *bookModel;
@property (nonatomic, strong) UILabel *priceLabel;
@property(nonatomic,assign)NSInteger count;
@end
