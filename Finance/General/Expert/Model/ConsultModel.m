
//
//  ConsultModel.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/15.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ConsultModel.h"

@implementation ConsultModel
-(instancetype)init{
    self=[super init];
    if (self) {
        _mes_name=@"";
        _mes_unit=@"";
        _mes_price=@"";
        _mes_state=@"";
    }
    return self;
}
@end
