//
//  QuestionController.h
//  Finance
//
//  Created by 郝旭珊 on 2017/12/25.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionController : UIViewController
@property (nonatomic, copy) NSString *searchTitle;
@property (nonatomic, copy) void (^finishedSearchQuestion)(NSString *searchCount);

@end
