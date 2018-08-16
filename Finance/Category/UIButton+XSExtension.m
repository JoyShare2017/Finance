//
//  UIButton+XSExtension.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "UIButton+XSExtension.h"

@implementation UIButton (XSExtension)

+ (UIButton * _Nonnull)buttonWithFont:(UIFont *_Nonnull)font
                           titleColor:(UIColor *_Nonnull)titleColor
{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.exclusiveTouch = YES;
    return btn;
}


//_Nonnull 指定对象不可为空
#pragma mark - autolayout
+ (UIButton * _Nonnull)buttonWithTitle:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.exclusiveTouch = YES;
    return btn;
}

+ (UIButton * _Nonnull)buttonWithTitle:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                             imageName:(NSString *_Nonnull)imageName{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
    
}


+ (UIButton * _Nonnull)buttonWithFont:(UIFont *_Nonnull)font
                           titleColor:(UIColor *_Nonnull)titleColor
                            imageName:(NSString *_Nonnull)imageName{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
    
}



#pragma mark - 底部按钮
+ (UIButton * _Nonnull)buttonWithFrame:(CGRect)frame
                                 title:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                       backgroundImage:(NSString *_Nonnull)imageName                               target:(id _Nonnull)anyObject
                            actionName:(NSString *_Nullable)actionName{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (actionName != nil && anyObject != nil) {
        [btn addTarget:anyObject action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.exclusiveTouch = YES;
    return btn;
}


+ (UIButton * _Nonnull)buttonWithFrame:(CGRect)frame
                                 title:(NSString *_Nonnull)title
                                  font:(UIFont *_Nonnull)font
                            titleColor:(UIColor *_Nonnull)titleColor
                       backgroundColor:(UIColor *_Nonnull)backgroundColor                                target:(id _Nonnull)anyObject
                            actionName:(NSString *_Nullable)actionName{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.backgroundColor = backgroundColor;
    if (actionName != nil && anyObject != nil) {
        [btn addTarget:anyObject action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.exclusiveTouch = YES;
    return btn;
}


#pragma mark - 九宫格
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString*)title
                         font:(UIFont*)font
                   titleColor:(UIColor*)titleColor
                    imageName:(NSString*)imageName
                       target:(id)anyObject
                   actionName:(NSString* _Nullable)actionName
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (actionName != nil && anyObject != nil) {
        [btn addTarget:anyObject action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.exclusiveTouch = YES;
    
    return btn;
}


#pragma mark - 九宫格
- (void)setTitle:(NSString*)title
            font:(UIFont*)font
      titleColor:(UIColor*)titleColor
       imageName:(NSString*)imageName
          target:(id)anyObject
      actionName:(NSString*)actionName

{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (actionName != nil && anyObject != nil) {
        [self addTarget:anyObject action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
    }
    self.exclusiveTouch = YES;
}

/**
 * 设置文字
 */
- (void)setTitle:(NSString *_Nonnull)title
            font:(UIFont *_Nonnull)font
      titleColor:(UIColor *_Nonnull)titleColor
{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    self.exclusiveTouch = YES;

}



- (void)layoutButtonWithImagePosition:(ButtonImagePosition)Position
                      imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    //!注意不要用imageView.Frame.size，当button不是initWithFrame时而用autolayout，imageView即使已经赋值，imageView的frame也是0
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据Position和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (Position) {
        case ButtonImagePositionTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonImagePositionLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonImagePositionBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWidth, 0, 0);
        }
            break;
        case ButtonImagePositionRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-space/2.0, 0, imageWidth+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
