//
//  NSDate+XSExtension.h
//  Finance
//
//  Created by 郝旭珊 on 2017/12/28.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XSExtension)

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
+ (NSString *)dateStringFromInteger:(NSInteger)timeInteger withFormat:(NSString *)format;
+ (NSString *)dateStringFromInteger:(NSInteger)timeInteger;
- (NSString *)dateToString:(NSString *)format;
- (NSString *)dateWeekString;
- (NSString *)dateHolidayWithLunarAndSolar;
- (NSString *)dateToFriendlyTime;


@end
