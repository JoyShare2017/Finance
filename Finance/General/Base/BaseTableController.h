//
//  BaseTableController.h
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableController : UITableViewController

@property (nonatomic, assign) NSInteger page;
/**
 *  实现上下拉刷新
 */
- (void)addRefreshWithHeaderBlock:(void (^)())headerBlock footerBlock:(void (^)())footerBlock;

@end
