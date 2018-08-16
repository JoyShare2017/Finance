//
//  UserAccount.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "UserAccount.h"

#define account_user_id @"user_id"       //用户主键
#define account_user_name @"user_name"     //用户账号
#define account_user_nick_name  @"user_nick_name"      //用户昵称
#define account_user_phone   @"user_phone"     //用户手机
#define account_user_leave   @"user_leave"     //用户等级（1：普通用户、2：vip用户、3：Svip用户、4：专家）
#define account_user_image  @"user_image"      //用户头像
#define account_user_lock @"user_lock"       //用户是否被锁定，0：不锁定；1：登录锁定

#define account_user_qianming @"user_qianming"       //用户签名
#define account_user_area @"user_area"       //用户地区
#define account_uuser_industry @"user_industry"       //用户行业
#define account_user_position @"user_position"       //用户职位
#define account_isUserAcountLogin @"isUserAcountLogin" //是否登录

@interface UserAccount()<NSCoding>


@end


@implementation UserAccount


-(instancetype)init{
    self=[super init];
    if (self) {
        [self accountReset];

    }
    return self;
}

-(void)accountReset{
    _isUserAcountLogin=@"";
    _user_id=@"";
    _user_name=@"";
    _user_nick_name=@"";
    _user_qianming=@"";
    _user_position=@"";
    _user_industry=@"";
    _user_area=@"";
    _user_lock=@"";
    _user_image=@"";
    _user_leave=@"";
    _isUserAcountLogin=@"";
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
}


//当进行归档操作的时候就会调用该方法
//在该方法中要写清楚要存储对象的那些属性
- (void) encodeWithCoder:(NSCoder *)aCoder{
    DebugLog(@"调用了encodeWithCoder方法");
    [aCoder encodeObject:_user_id forKey:account_user_id];
    [aCoder encodeObject:_user_name forKey:account_user_name];
    [aCoder encodeObject:_user_nick_name forKey:account_user_nick_name];
    [aCoder encodeObject:_user_phone forKey:account_user_phone];
    [aCoder encodeObject:_user_leave forKey:account_user_leave];
    [aCoder encodeObject:_user_image forKey:account_user_image];
    [aCoder encodeObject:_user_lock forKey:account_user_lock];
    //zs add
    [aCoder encodeObject:_user_area forKey:account_user_area];
    [aCoder encodeObject:_user_industry forKey:account_uuser_industry];
    [aCoder encodeObject:_user_position forKey:account_user_position];
    [aCoder encodeObject:_user_qianming forKey:account_user_qianming];
    [aCoder encodeObject:_isUserAcountLogin forKey:account_isUserAcountLogin];

    
}

//当进行解档操作的时候就会调用该方法
//在该方法中要写清楚要提取对象的哪些属性
- (id)initWithCoder:(NSCoder *)aDecoder{
    NSLog(@"调用了initWithCoder方法");
    if (self = [super init]) {
        self.user_id = [aDecoder decodeObjectForKey:account_user_id];
        self.user_name = [aDecoder decodeObjectForKey:account_user_name];
        self.user_nick_name = [aDecoder decodeObjectForKey:account_user_nick_name];
        self.user_phone = [aDecoder decodeObjectForKey:account_user_phone];
        self.user_leave = [aDecoder decodeObjectForKey:account_user_leave];
        self.user_image = [aDecoder decodeObjectForKey:account_user_image];
        self.user_lock = [aDecoder decodeObjectForKey:account_user_lock];

      self.user_qianming = [aDecoder decodeObjectForKey:account_user_qianming];
      self.user_industry = [aDecoder decodeObjectForKey:account_uuser_industry];
        self.user_position = [aDecoder decodeObjectForKey:account_user_position];
      self.user_area = [aDecoder decodeObjectForKey:account_user_area];
        self.isUserAcountLogin = [aDecoder decodeObjectForKey:account_isUserAcountLogin];

    }
    return self;
}


@end
