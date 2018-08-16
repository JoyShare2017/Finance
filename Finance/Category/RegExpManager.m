//
//  RegExpManager.m
//  ErShouJi
//
//  Created by  apple on 13-6-8.
//  Copyright (c) 2013年  apple. All rights reserved.
//

#import "RegExpManager.h"

@implementation RegExpManager

//是否符合 1-9
+(BOOL)validateNumberWithoutZero:(NSString*)str
{
    //正则
    NSString* patternStr = @"^[1-9]$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}
+(BOOL)validateNumber:(NSString*)str
{
    NSString* patternStr = @"^[0-9]$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}
+(BOOL)validatePrice:(NSString*)str
{
    NSString* patternStr = @"^[1-9][0-9]{0,9}(\\.?|\\.[0-9]{0,2})$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
//        NSLog(@"str.length is %d and numberOfMatch is %d",str.length,numberOfMatch);
        return YES;
    }
    return NO;
}
+(BOOL)validateJiXingAndJiHao:(NSString*)str
{
    NSString* patternStr = @"^[0-9a-zA-Z\\/\\-]{1,20}$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}
/**
 *  检查是否是有效的日期
 *
 *  @param str 日期字符串
 *
 *  @return YES:有效,NO:无效
 */
+(BOOL)validateDate:(NSString*)str
{
    NSString* patternStr =  @"^[2-9][0-9]{3}-(0[1-9]|1[0-2])-((0[1-9])|((1|2)[0-9])|30|31)$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}
/**
 *  检查是否是有效的手机号码
 */
+(BOOL)validateContactPhone:(NSString*)str
{
    NSString* patternStr =  @"^1[0-9]{10}$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}

+(BOOL)validateHour:(NSString*)str
{
    NSString* patternStr = @"^[1-9][0-9]{0,9}(\\.?|\\.[0-9]{0,1})$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        //        NSLog(@"str.length is %d and numberOfMatch is %d",str.length,numberOfMatch);
        return YES;
    }
    return NO;
}

+ (BOOL )valiMobile:(NSString *)mobile

{
    //20180125 刘圣杰 修改
    //先换成11位
//    NSString* patternStr =  @"^1[0-9]{10}$";
    NSString* patternStr =  @"^1[3-9][0-9]{9}$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:mobile options:NSMatchingReportProgress range:NSMakeRange(0, mobile.length)];
    if(numberOfMatch > 0){
        return YES;
    }
    return NO;
    /*
    if (mobile.length < 11)
    {
        return NO;
    }else{
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
     */
}
//是否是合法的密码 数字和字母特殊字符组合
+(BOOL)validatePassword:(NSString*)str
{
    //    至少六位必须包括数字、字母、特殊符号
    NSString* patternStr = @"^(?![^a-zA-Z]+$)(?!\\D+$)(?![^@#$%^&*_]+$).{6,20}$";
    NSRegularExpression* regexp = [[NSRegularExpression alloc]initWithPattern:patternStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [regexp numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if(numberOfMatch > 0)
    {
        return YES;
    }
    return NO;
}
@end
