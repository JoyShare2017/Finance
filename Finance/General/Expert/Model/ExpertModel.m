//
//  ExpertModel.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/3.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ExpertModel.h"

@implementation ExpertModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _expert_id=@"";
        _expert_images=@"";
        _expert_full_name=@"";
        _expert_zhuanye=@"";
        _expert_id=@"";
        _expert_jianjie=@"";
        _follow_ok=NO;
        _follow_count=@"0";

    }
    return self;
}

@end
