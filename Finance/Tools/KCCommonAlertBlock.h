//
//  KCCommonAlertBlock.h
//  Komics
//
//  Created by dev1 on 14-10-8.
//  Copyright (c) 2014年  apple. All rights reserved.
//

/**
 *  一个单例的提示框,提供两种形式
 *  1. 只有一个确定按钮,可以设置标题、信息和点击后的回调
 *  2. 有确定和取消两个按钮,可以设置标题、取消按钮标题、确定按钮标题、信息、点击取消后的回调、点击确定后的回调。
 *  
 *  此类以后可以复用
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef void (^AlertBlock)(id obj);                                           // 提示框的block回调
typedef void (^CancelBlock)(id obj);                                          // 提示框的cancel回调
typedef void (^ConfirmBlock)(id obj);                                         // 提示框的Confirm回调
//王亚坤添加
typedef void (^ConfirmBlock2)(id obj);                                         // 提示框的Confirm2回调
//赵帅添加
typedef void (^ConfirmBlock3)(id obj);

@interface KCCommonAlertBlock : NSObject <UIAlertViewDelegate>

@property (nonatomic,copy)AlertBlock            alertBlock;             // 提示框的block回调

@property (nonatomic,copy)CancelBlock            cancelBlock;             // 提示框的cancel回调
@property (nonatomic,copy)ConfirmBlock          confirmBlock;             // 提示框的Confirm回调
//王亚坤  添加
@property (nonatomic,copy)ConfirmBlock2          confirmBlock2;             // 提示框的Confirm2回调

@property (nonatomic,copy)ConfirmBlock3          confirm3;//第三个选项


@property (nonatomic,strong)UIAlertView           *alertView;             // 提示框

// 获得公用提示框
/**
 *  使用单例模式返回自己的单例
 *
 *  @return 返回的单例
 */
+(KCCommonAlertBlock*)defaultAlertBlock;

// 显示 提示框 并且设置 标题，显示信息，以及回调块
/**
 *  使用给定的参数生成一个提示框,并显示
 *
 *  @param title      提示框的标题
 *  @param message    提示框的信息
 *  @param alertBlock 点击确定后提示框的回调动作
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertBlock:(AlertBlock)alertBlock;


// 显示 提示框 并且设置 两个按钮标题，显示信息，以及回调块
/**
 *  使用给定的参数生成一个提示框,并提示
 *
 *  @param Title        标题
 *  @param cancelTitle  取消按钮内容
 *  @param confirmTitle 确定按钮内容
 *  @param message      消息
 *  @param cancelBlock  取消后的回调
 *  @param confirmBlock 确定后的回调
 */
- (void)showAlertWithTitle:(NSString *)Title
               CancelTitle:(NSString *)cancelTitle
              ConfirmTitle:(NSString *)confirmTitle
                   message:(NSString *)message
               cancelBlock:(CancelBlock)cancelBlock
              confirmBlock:(ConfirmBlock)confirmBlock;



//兼容iOS8前后的提示框  ---- 王亚坤
// 显示 提示框 并且设置 标题，显示信息，以及回调块
/**
 *  使用给定的参数生成一个提示框,并提示
 *
 *  @param viewController   控制器
 *  @param Title            标题
 *  @param message          消息
 *  @param alertBlock       点击确定后提示框的回调动作
 */
-(void)showAlertWithController:(UIViewController *)viewController
                         title:(NSString *)title
                       message:(NSString *)message
                    alertBlock:(AlertBlock)alertBlock;

// 显示 提示框 并且设置 两个按钮标题，显示信息，以及回调块
/**
 *  使用给定的参数生成一个提示框,并提示
 *
 *  @param viewController   控制器
 *  @param Title            标题
 *  @param cancelTitle      取消按钮内容
 *  @param confirmTitle     确定按钮内容
 *  @param message          消息
 *  @param cancelBlock      取消后的回调
 *  @param confirmBlock     确定后的回调
 */
- (void)showAlertWithController:(UIViewController *)viewController
                          title:(NSString *)Title
               CancelTitle:(NSString *)cancelTitle
              ConfirmTitle:(NSString *)confirmTitle
                   message:(NSString *)message
               cancelBlock:(CancelBlock)cancelBlock
              confirmBlock:(ConfirmBlock)confirmBlock;
/**
 *  显示 提示框 并且设置 三个按钮标题，显示信息，以及回调块
 *
 *  @param viewController 控制器
 *  @param Title          标题
 *  @param cancelTitle    取消按钮内容
 *  @param confirmTitle1  确定1按钮内容
 *  @param confirmTitle2  确定2按钮内容
 *  @param message        消息
 *  @param cancelBlock    取消后的回调
 *  @param confirmBlock1  确定1后的回调
 *  @param confirmBlock2  确定2后的回调
 */
- (void)showAlertWithController:(UIViewController *)viewController
                          title:(NSString *)Title
                    CancelTitle:(NSString *)cancelTitle
                  ConfirmTitle1:(NSString *)confirmTitle1
                  ConfirmTitle2:(NSString *)confirmTitle2
                        message:(NSString *)message
                    cancelBlock:(CancelBlock)cancelBlock
                  confirmBlock1:(ConfirmBlock)confirmBlock1
                  confirmBlock2:(ConfirmBlock)confirmBlock2;


//添加三个选项的提示框，格式：例子：自主派工  无需对应 电话对应 取消
- (void)showThreeBtnAlertWithController:(UIViewController *)viewController
                                  title:(NSString *)Title
                            CancelTitle:(NSString *)cancelTitle
                          ConfirmTitle1:(NSString *)confirmTitle1
                          ConfirmTitle2:(NSString *)confirmTitle2
                          ConfirmTitle3:(NSString *)confirmTitle3

                                message:(NSString *)message
                            cancelBlock:(CancelBlock)cancelBlock
                          confirmBlock1:(ConfirmBlock)confirmBlock1
                          confirmBlock2:(ConfirmBlock)confirmBlock2
                          confirmBlock3:(ConfirmBlock)confirmBlock3;
/**
 *  短提示  没有title和任何按钮  三秒后消失
 **/
-(void)showShortAlertWithController:(UIViewController *)viewController andMessage:(NSString*)message;

@end
