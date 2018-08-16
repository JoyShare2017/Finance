//
//  EditServiceCell.h
//  Finance
//
//  Created by 赵帅 on 2018/4/20.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//  已经成为专家后 显示的 cell 可以暂时关闭或者打开

#import <UIKit/UIKit.h>
#import "ConsultModel.h"

@interface EditServiceCell : UITableViewCell
@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, strong) ConsultModel *theModel;
@end
