//
//  UserAccount.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject
@property (nonatomic , copy) NSString              * user_leave;
@property (nonatomic , copy) NSString              * user_nick_name;
@property (nonatomic , copy) NSString              * user_lock;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * user_name;
@property (nonatomic , copy) NSString              * user_phone;
@property (nonatomic , copy) NSString              * user_image;
//zs 新加4个
@property (nonatomic , copy) NSString              *user_qianming;
@property (nonatomic , copy) NSString              *user_industry;
@property (nonatomic , copy) NSString              *user_position;//职位
@property (nonatomic , copy) NSString              *user_area;
@property (nonatomic, copy)  NSString              *isUserAcountLogin;

-(void)accountReset;
@end
