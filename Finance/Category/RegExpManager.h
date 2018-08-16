//
//  RegExpManager.h
//  ErShouJi
//
//  Created by  apple on 13-6-8.
//  Copyright (c) 2013年  apple. All rights reserved.
//

/*!
 @class         RegExpManager
 @author        刘圣杰
 @version       1.0
 @discussion	正则表达式管理器。
 */
#import <Foundation/Foundation.h>

@interface RegExpManager : NSObject
+(BOOL)validateNumberWithoutZero:(NSString*)str;
+(BOOL)validateNumber:(NSString*)str;
+(BOOL)validatePrice:(NSString*)str;
+(BOOL)validateJiXingAndJiHao:(NSString*)str;
/**
 *  检查是否是有效的日期
 *
 *  @param str 日期字符串
 *
 *  @return YES:有效,NO:无效
 */
+(BOOL)validateDate:(NSString*)str;
/**
 *  检查是否是有效的联系人号码:可以是固定电话或者手机

 */
+(BOOL)validateContactPhone:(NSString*)str;
/**
 *  判断小时数的正则

 */
+(BOOL)validateHour:(NSString*)str;

/**
 *  判断手机号的正则
 *
 */
+ (BOOL)valiMobile:(NSString *)mobile;


+(BOOL)validatePassword:(NSString*)str;


@end
