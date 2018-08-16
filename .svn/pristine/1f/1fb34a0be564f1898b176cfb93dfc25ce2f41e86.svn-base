//
//  NSString+Extension.m
//  KOFACS
//
//  Created by 董天文 on 16/8/11.
//  Copyright © 2016年  apple. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(CGFloat)widthOfTheString:(NSString *)string withFont:(CGFloat)font
{
    CGSize size = [string sizeWithAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName: [UIFont systemFontOfSize:font]}];
    
    return size.width + 15;
}
+(CGFloat)heightWithString:(NSString *)string size:(CGSize)size font:(CGFloat)font
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size.height;
}




+(CGFloat)bolderHeightWithString:(NSString *)string size:(CGSize)size font:(CGFloat)font
{
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:font]} context:nil].size.height+5;
}



@end
