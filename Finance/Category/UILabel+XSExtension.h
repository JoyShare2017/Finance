//
//  UILabel+XSExtension.h
//  jiaoquaner
//
//  Created by 郝旭珊 on 2017/10/28.
//  Copyright © 2017年 yimofang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XSExtension)

/**
 * Frame-无 title(模型赋值)
 */
+(instancetype)labelWithFrame:(CGRect)frame
                     textFont:(UIFont *)font
                 textColor:(UIColor *)color;


/**
 * frame 固定(我的钱包)
 *
 */
+ (instancetype)labelWithFrame:(CGRect)frame
                          text:(NSString *)text
                      textFont:(UIFont *)font
                     textColor:(UIColor *)textColor;


/**
 * 首行缩进 Label
 */
+ (instancetype)labelWithFirstIndent:(CGFloat)indent
                               frame:(CGRect)frame
                                text:(NSString *)text
                            textFont:(UIFont *)font
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor;

/**
 * 首行缩进
 */
- (void)setFirstLineIndent:(CGFloat)indent;



/**
 * Autolayout-无 title(模型赋值)
 */
+(instancetype)labelWithTextFont:(UIFont *)font
                    textColor:(UIColor *)color;


/**
 * 多行 Label (默认行宽 screenW-20)
 */
+(instancetype)labelWithOrigin:(CGPoint)origin
                          text:(NSString *)text
                      textFont:(UIFont *)font
                     textColor:(UIColor *)textColor;

/**
 * 多行 Label-AttributedString(默认行宽 screenW-20)
 */
+(instancetype)labelWithOrigin:(CGPoint)origin
                attributedText:(NSMutableAttributedString *)attributedText
                      textFont:(UIFont *)font;


/**
 * 普通 Label
 */
- (instancetype)setText:(NSString*)text
               textFont:(UIFont *)font
              textColor:(UIColor *)color;

/**
 为UILabel首部设置图片标签
 
 @param text 文本
 @param images 标签数组
 @param span 标签间距
 */
-(void)setText:(NSString *)text
   frontImages:(NSArray<UIImage *> *)images
    headIndent:(CGFloat)headIndent
     imageSpan:(CGFloat)span;


@end
