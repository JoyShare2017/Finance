//
//  MoreAnswerCell.h
//  Finance
//
//  Created by 赵帅 on 2018/4/26.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"

@interface MoreAnswerCell : UITableViewCell
@property (nonatomic, strong) AnswerModel *answerModel;
@property (nonatomic, strong) UIViewController *superVC;

@end
