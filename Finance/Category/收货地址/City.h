//
//  City.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Province.h"
@interface City : NSObject
@property (nonatomic,assign) int   id_self;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,strong) NSMutableArray* countrys;
@property (nonatomic,strong) Province* province;
@end
