//
//  QuestionFullCell.h
//  Finance
//
//  Created by 赵帅 on 2018/4/23.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionDetailModel.h"


@interface QuestionFullCell : UITableViewCell
//@property (nonatomic, strong) QuestionModel *questionModel;
-(CGFloat)setQuestionDataWithModel:(QuestionDetailModel*)questionModel;
@property (nonatomic, strong) UIViewController *superVC;




@end
