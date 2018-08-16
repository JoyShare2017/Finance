//
//  NSDate+XSExtension.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/28.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "NSDate+XSExtension.h"

@implementation NSDate (XSExtension)

/**
 *  是否为同一天
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


+ (NSString *)dateStringFromInteger:(NSInteger)timeInteger withFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInteger];
    return [date dateToString:format];
}


/**
 * 返回 yyyy-MM-dd 格式的 String
 *
 */
+ (NSString *)dateStringFromInteger:(NSInteger)timeInteger{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInteger];
    return [date dateToString:@"yyyy-MM-dd"];
}


#pragma mark 返回特定格式的时间
- (NSString *)dateToString:(NSString *)format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}



/**
 刚刚(一分钟内)
 X分钟前(一小时内)
 X小时前(当天)
 昨天 HH:mm(昨天)
 MM-dd HH:mm(一年内)
 yyyy-MM-dd HH:mm(更早期)
 */
- (NSString *)dateToFriendlyTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //今天
    if ([calendar isDateInToday:self]){
        NSTimeInterval distance = self.timeIntervalSinceNow;
        if (distance < 60){
            return @"刚刚";
        }
        if (distance < 60*60) {
            return [NSString stringWithFormat:@"(%f)分钟前",distance/60];
        }
        return [NSString stringWithFormat:@"(%f/)小时前",distance/(60*60)];
    }
    
    //今天以前
    NSString *formatterString = @"HH:mm";
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    if ([calendar isDateInYesterday:self]){
        formatterString = [NSString stringWithFormat:@"昨天:%@",formatterString];
        //超过一年
    }else if (components.year >= 1){
        formatterString = @"yyyy-MM-dd HH:mm";
        //一年以内
    }else{
        formatterString = @"MM-dd HH:mm";
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = formatterString;
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    
    return [formatter stringFromDate:self];
}



#pragma mark 通过数字返回星期几
- (NSString *)dateWeekString{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"e";
    int week = [[dateFormatter stringFromDate:self]intValue];
    
    NSString *str_week;
    switch (week) {
        case 1:
            str_week = @"星期日";
            break;
        case 2:
            str_week = @"星期一";
            break;
        case 3:
            str_week = @"星期二";
            break;
        case 4:
            str_week = @"星期三";
            break;
        case 5:
            str_week = @"星期四";
            break;
        case 6:
            str_week = @"星期五";
            break;
        case 7:
            str_week = @"星期六";
            break;
    }
    return str_week;
}


#pragma mark - 获取节日(包含农历和阳历)
- (NSString * _Nullable)dateHolidayWithLunarAndSolar{
    NSString *lunar = [self dateChineseCalendar];
    NSString *lunarHoliday = [self dateLunarHoliday:lunar];
    NSString *solar = [self dateToString:@"MMdd"];
    NSString *solarholiday = [self DateSolarHoliday:solar];
    if (lunarHoliday.length > 0){
        return lunarHoliday;
    }else if (solarholiday.length >0){
        return solarholiday;
    }else{
        return nil;
    }
    
}


#pragma mark - 获取农历月日
- (NSString *)dateChineseCalendar{
    NSArray *chineseMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    NSArray *chineseDays = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    NSString *lunarMonth = [chineseMonths objectAtIndex:localeComp.month - 1];
    NSString *lunarDay = [chineseDays objectAtIndex:localeComp.day - 1];
    return [lunarMonth stringByAppendingString:lunarDay];
}

#pragma mark 判断阴历节日
- (NSString *)dateLunarHoliday:(NSString *)lunarMonthDay{
    NSString *lunarHoliday;
    NSString *lunar = lunarMonthDay;
    if ([lunar isEqualToString:@"正月初一"]) {
        lunarHoliday = @"春节";
    }
    if ([lunar isEqualToString:@"正月十五"]) {
        lunarHoliday = @"元宵";
    }
    if ([lunar isEqualToString:@"二月初二"]) {
        lunarHoliday = @"龙抬头";
    }
    if ([lunar isEqualToString:@"五月初五"]) {
        lunarHoliday = @"端午节";
    }
    if ([lunar isEqualToString:@"七月初七"]) {
        lunarHoliday = @"七夕";
    }
    if ([lunar isEqualToString:@"八月十五"]) {
        lunarHoliday = @"中秋";
    }
    if ([lunar isEqualToString:@"九月初九"]) {
        lunarHoliday = @"重阳节";
    }
    if ([lunar isEqualToString:@"腊月初八"]) {
        lunarHoliday = @"腊八节";
    }
    if ([lunar isEqualToString:@"腊月廿三"]) {
        lunarHoliday = @"小年";
    }
    if ([lunar isEqualToString:@"腊月三十"]) {
        lunarHoliday = @"除夕";
    }
    return lunarHoliday;
}

#pragma mark 判断阳历节日
- (NSString *)DateSolarHoliday:(NSString *)solarMonthDay{
    NSString *dateHoliday;
    NSString *date = solarMonthDay;
    if ([date isEqualToString:@"0101"]) {
        dateHoliday = @"元旦";
    }
    if ([date isEqualToString:@"0214"]) {
        dateHoliday = @"情人节";
    }
    if ([date isEqualToString:@"0308"]) {
        dateHoliday = @"妇女节";
    }
    if ([date isEqualToString:@"0312"]) {
        dateHoliday = @"植树节";
    }
    if ([date isEqualToString:@"0401"]) {
        dateHoliday = @"愚人节";
    }
    if ([date isEqualToString:@"0501"]) {
        dateHoliday = @"劳动节";
    }
    if ([date isEqualToString:@"0601"]) {
        dateHoliday = @"儿童节";
    }
    if ([date isEqualToString:@"0801"]) {
        dateHoliday = @"建军节";
    }
    if ([date isEqualToString:@"0910"]) {
        dateHoliday = @"教师节";
    }
    if ([date isEqualToString:@"1001"]) {
        dateHoliday = @"国庆节";
    }
    if ([date isEqualToString:@"1111"]) {
        dateHoliday = @"光棍节";
    }
    if ([date isEqualToString:@"1224"]) {
        dateHoliday = @"平安夜";
    }
    if ([date isEqualToString:@"1225"]) {
        dateHoliday = @"圣诞节";
    }
    return dateHoliday;
}


@end
