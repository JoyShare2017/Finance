//
//  UserAccountManager.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "UserAccountManager.h"

@interface UserAccountManager()
@property (nonatomic, copy) NSString *accountPath;
@end


@implementation UserAccountManager

- (BOOL)isUserLogin{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.accountPath]){
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)accountPath{
    if (_accountPath == nil){
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, true).lastObject;
        _accountPath = [documentPath stringByAppendingString:@"account.plist"];
    }
    
    return _accountPath;
}


+ (instancetype) sharedManager{
    static UserAccountManager *instance;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init] ;
        if (!instance.userAccount) {
            instance.userAccount=[[UserAccount alloc]init];
        }
        instance.isUserLogin=[instance.userAccount.isUserAcountLogin isEqualToString:@"1"];
        
    });
    return instance;
}


+ (id) allocWithZone:(struct _NSZone *)zone{
    return [UserAccountManager sharedManager];
}


- (id) copyWithZone:(struct _NSZone *)zone{
    return [UserAccountManager sharedManager];
}


- (instancetype)init{
    if (self = [super init]){
        if (self.accountPath){
            self.userAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:self.accountPath];
        }
    }
    return self;
}


- (void)saveAccount{
    DebugLog(@"用户数据保存路径:%@",self.accountPath);
    [NSKeyedArchiver archiveRootObject:self.userAccount toFile:self.accountPath];
    self.isUserLogin=YES;
    DebugLog(@"保存用户数据成功");
}


- (void)deleteAccount{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager removeItemAtPath:self.accountPath error:nil]){
        DebugLog(@"删除用户数据成功");
        self.isUserLogin=NO;
        [self.userAccount accountReset];
    }else{
        DebugLog(@"删除用户数据失败");
    }
    
}


@end
