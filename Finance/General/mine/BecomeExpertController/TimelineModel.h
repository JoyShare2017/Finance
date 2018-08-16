//
//  TimelineModel.h
//  Finance
//
//  Created by 赵帅 on 2018/4/18.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineModel : NSObject
@property (nonatomic, copy) NSString *title,*content,*content_care,*time,*expert_progress;
@property(nonatomic,assign)NSInteger index;
@end

