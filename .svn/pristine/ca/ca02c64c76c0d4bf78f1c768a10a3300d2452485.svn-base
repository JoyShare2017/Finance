//
//  UIButton+XSExtension.h
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ButtonImagePosition) {
    ButtonImagePositionTop, // image在上，label在下
    ButtonImagePositionLeft, // image在左，label在右
    ButtonImagePositionBottom, // image在下，label在上
    ButtonImagePositionRight // image在右，label在左
};

@interface UIButton (XSExtension)


#pragma mark - Autolayout
/**
 * 只设置文字格式,无 title, 无 image
 */
+ (UIButton * _Nonnull)buttonWithFont:(UIFont *_Nonnull)font
                           titleColor:(UIColor *_Nonnull)titleColor;


/**
 * 只title
 */
+ (UIButton * _Nonnull)buttonWithTitle:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor;
/**
 * 只 image(点赞 转发)
 */
+ (UIButton * _Nonnull)buttonWithFont:(UIFont *_Nonnull)font
                           titleColor:(UIColor *_Nonnull)titleColor
                            imageName:(NSString *_Nonnull)imageName;
/**
 * title,image 都有
 *
 */
+ (UIButton * _Nonnull)buttonWithTitle:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                             imageName:(NSString *_Nonnull)imageName;





#pragma mark - 底部按钮
/**
 * 底部按钮(含backgroundImage)
 */
+ (UIButton * _Nonnull)buttonWithFrame:(CGRect)frame
                                 title:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                       backgroundImage:(NSString *_Nonnull)imageName                               target:(id _Nonnull)anyObject
                            actionName:(NSString *_Nullable)actionName;



/**
 * 底部按钮(含backgroundColor)
 */
+ (UIButton * _Nonnull)buttonWithFrame:(CGRect)frame
                                 title:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                       backgroundColor:(UIColor *_Nonnull)backgroundColor                                target:(id _Nonnull)anyObject
                            actionName:(NSString *_Nullable)actionName;


#pragma mark - 九宫格
/**
 * 九宫格(含image)
 */
+ (UIButton *_Nullable)buttonWithFrame:(CGRect)frame
                                 title:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                             imageName:(NSString *_Nonnull)imageName
                                target:(id _Nonnull)anyObject
                            actionName:(NSString *_Nullable)actionName;

/**
 * 设置文字
 */
- (void)setTitle:(NSString *_Nonnull)title
            font:(UIFont *_Nonnull)font
      titleColor:(UIColor *_Nonnull)titleColor;


/**
 * 九宫格
 */
- (void)setTitle:(NSString* _Nonnull)title
            font:(UIFont* _Nonnull)font
      titleColor:(UIColor* _Nonnull)titleColor
       imageName:(NSString* _Nonnull)imageName
          target:(id _Nonnull)anyObject
      actionName:(NSString* _Nullable)actionName;


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param Position titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithImagePosition:(ButtonImagePosition)Position
                      imageTitleSpace:(CGFloat)space;

@end

