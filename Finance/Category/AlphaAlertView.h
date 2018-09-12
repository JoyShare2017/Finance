//
//  AlphaAlertView.h
//  JingXinTong
//
//  Created by 赵帅 on 2018/6/7.
//  Copyright © 2018年 赵帅. All rights reserved.
//  点击好友 提示 此功能正在开发中 的 view

#import <UIKit/UIKit.h>
#
@interface AlphaAlertView : UIView
@property (nonatomic, strong) UITextField*nametf,*phonetf;
@property (nonatomic, strong)UBTextView*textview;
@property (nonatomic, strong) UBButton*cancelBtn,*confirmBtn;
@property (nonatomic, strong) void (^confirmBlock)(NSString*name,NSString*phone,NSString*text);
//没有权限查看通讯录
-(instancetype)initWithNoAccessAndSupervc:(UIViewController*)supervc;

/*
 ** 通用提示  标题  文字 左右两个按钮
 */
-(instancetype)initCommonAlertWithSupervc:(UIViewController*)supervc andTitle:(NSString*)title andContent:(NSString*)content andCancelBtnTitle:(NSString*)cancelbtnTitle andConfirmBlock:(void(^)(id obj))suggestion;
@end
