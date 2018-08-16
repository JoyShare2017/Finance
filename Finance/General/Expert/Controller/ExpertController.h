//
//  ExpertController.h
//  Finance
//
//  Created by 郝旭珊 on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertController : UIViewController
@property (nonatomic, copy) NSString *searchExpert;
@property (nonatomic, copy) void (^finishedSearchExpert)(NSString *searchCount);

@end
