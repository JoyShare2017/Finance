//
//  ChoseServeController.h
//  Finance
//
//  Created by 郝旭珊 on 2018/2/1.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertDetailModel.h"
@interface ChoseServeController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic, strong) ExpertDetailModel *oldExpert;//只用于选择开通的服务

@end
