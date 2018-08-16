//
//  ExpertAnswerCell.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertModel.h"
#import "AnswerModel.h"
#import "UserAccount.h"

@interface ExpertAnswerCell : UITableViewCell

@property (nonatomic, strong) ExpertModel *expertModel;
@property (nonatomic, strong) AnswerModel *answerModel;
@property (nonatomic, strong) UserAccount *userModel;
@property (nonatomic, assign) CGFloat cellHeight;

- (CGFloat)cellHeightWithAnswerModel:(AnswerModel *)answerModel
                         expertModel:(ExpertModel *_Nullable)expertModel
                           userModel:(UserAccount *_Nullable)userModel;
@end
