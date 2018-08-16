//
//  MyDetailInfoVC.h
//  Finance
//
//  Created by 赵帅 on 2018/4/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDetailInfoVC : UIViewController
@property (nonatomic, strong) void (^didChangedMyInfo)(id obj);

@end
