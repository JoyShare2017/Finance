//
//  ChannelButton.h
//  D1CM
//
//  Created by 赵帅 on 2017/10/16.
//  Copyright © 2017年 lsj. All rights reserved.
//  设置频道的button

#import "UBButton.h"

@interface ChannelButton : UBButton

@property(nonatomic,assign)NSInteger channel_id;
@property(nonatomic,strong)UBButton*closeBtn;

@property(nonatomic)BOOL canEdit;
@property(nonatomic)BOOL isNeedShowCloseBtn;
@end
