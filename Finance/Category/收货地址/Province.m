//
//  Province.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "Province.h"

@implementation Province
-(id)init
{
    self = [super init];
    if(self)
    {
        _citys = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
