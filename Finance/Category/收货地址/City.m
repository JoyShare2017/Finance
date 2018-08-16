//
//  City.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "City.h"

@implementation City
-(id)init
{
    self = [super init];
    if(self)
    {
        _countrys = [[NSMutableArray alloc]init];
        _province = [[Province alloc] init];
    }
    return self;
}
@end
