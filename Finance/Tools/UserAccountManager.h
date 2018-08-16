//
//  UserAccountManager.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"

@interface UserAccountManager : NSObject

@property (nonatomic, strong) UserAccount *userAccount;
@property (nonatomic, assign) BOOL isUserLogin;

+ (instancetype) sharedManager;
- (void)saveAccount;
- (void)deleteAccount;
@end
