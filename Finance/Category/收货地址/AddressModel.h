//
//  AddressModel.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/18.
//  Copyright © 2016年 lsj. All rights reserved.
//  收货地址的model类

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property(nonatomic,copy)NSString* us_id;
@property(nonatomic,copy)NSString* us_user_id;
@property(nonatomic,assign)int     us_addtime;
@property(nonatomic,copy)NSString* us_phone;
@property(nonatomic,copy)NSString* us_name;

@property(nonatomic,copy)NSString* us_address;
@property(nonatomic,copy)NSString* sheng,*shi,*qu,*jiedao;

@property(nonatomic,assign)int     us_default;
@end
