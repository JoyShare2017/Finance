//
//  Province.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property (nonatomic,assign) int   id_self;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSMutableArray* citys;
@end
