//
//  KCCommonAlertBlock.m
//  Komics
//
//  Created by dev1 on 14-10-8.
//  Copyright (c) 2014年  apple. All rights reserved.
//

#import "KCCommonAlertBlock.h"

#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
static KCCommonAlertBlock *defaultAlertBlock;

@implementation KCCommonAlertBlock

// 获得公用提示框
+(KCCommonAlertBlock*)defaultAlertBlock{
    if (!defaultAlertBlock) {
        defaultAlertBlock = [[self alloc]init];
    }
    return defaultAlertBlock;
}

//兼容iOS8前后 王亚坤
-(void)showAlertWithController:(UIViewController *)viewController
                         title:(NSString *)title
                  message:(NSString *)message
                 alertBlock:(AlertBlock)alertBlock{
    if (SYSTEM_VERSION >= 8.0)
    {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:alertBlock];
        [alertCtrl addAction:okAction];
        [viewController presentViewController:alertCtrl animated:YES completion:nil];

    }
    else
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        self.alertView.tag = 200;//两个选项
        self.alertBlock = alertBlock;
        
        self.confirmBlock = nil;
        self.cancelBlock = nil;
        [self.alertView show];
    }
}
//兼容iOS8前后 王亚坤
- (void)showAlertWithController:(UIViewController *)viewController
                          title:(NSString *)Title
                    CancelTitle:(NSString *)cancelTitle
                   ConfirmTitle:(NSString *)confirmTitle
                        message:(NSString *)message
                    cancelBlock:(CancelBlock)cancelBlock
                   confirmBlock:(ConfirmBlock)confirmBlock{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelTitle != nil) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
            [alertCtrl addAction:cancelAction];
        }
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmBlock];
        [alertCtrl addAction:okAction];
        [viewController presentViewController:alertCtrl animated:YES completion:nil];
    }else {
        self.alertView = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
        self.alertView.tag = 200;//两个选项
        self.cancelBlock = cancelBlock;
        self.confirmBlock = confirmBlock;
        self.alertBlock = nil;
        
        [self.alertView show];
    }

}

// 显示 提示框 并且设置 标题，显示信息，以及回调块
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertBlock:(AlertBlock)alertBlock{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    self.alertView.tag = 200;//两个选项
    self.alertBlock = alertBlock;
    
    self.confirmBlock = nil;
    self.cancelBlock = nil;
    [self.alertView show];

    
}

// 显示 提示框 并且设置 两个按钮标题，显示信息，以及回调块
- (void)showAlertWithTitle:(NSString *)Title
               CancelTitle:(NSString *)cancelTitle
              ConfirmTitle:(NSString *)confirmTitle
                   message:(NSString *)message
               cancelBlock:(CancelBlock)cancelBlock
              confirmBlock:(ConfirmBlock)confirmBlock{
    self.alertView = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = 200;//两个选项
    self.cancelBlock = cancelBlock;
    self.confirmBlock = confirmBlock;
    self.alertBlock = nil;
    
    [self.alertView show];
}


// alertView 回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200)
    {//两个选项
        if (buttonIndex == 0) {
            if (self.alertBlock) {
                self.alertBlock(nil);
            }
            if (self.cancelBlock) {
                self.cancelBlock(nil);
            }
        }else{
            if (self.confirmBlock) {
                self.confirmBlock(nil);
            }
        }
    }else if (alertView.tag == 300)
    {//三个选项
        if (buttonIndex == 0) {
            if (self.alertBlock) {
                self.alertBlock(nil);
            }
            if (self.cancelBlock) {
                self.cancelBlock(nil);
            }
        }else if (buttonIndex == 1){
            if (self.confirmBlock) {
                self.confirmBlock(nil);
            }
        }else
        {
            if (self.confirmBlock2) {
                self.confirmBlock2(nil);
            }
        }
    }
    
    
}
//添加提示框，格式：例子：取消   保存   上传
- (void)showAlertWithController:(UIViewController *)viewController
                          title:(NSString *)Title
                    CancelTitle:(NSString *)cancelTitle
                   ConfirmTitle1:(NSString *)confirmTitle1
                  ConfirmTitle2:(NSString *)confirmTitle2
                        message:(NSString *)message
                    cancelBlock:(CancelBlock)cancelBlock
                   confirmBlock1:(ConfirmBlock)confirmBlock1
                  confirmBlock2:(ConfirmBlock)confirmBlock2
{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelTitle != nil) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
            [alertCtrl addAction:cancelAction];
        }
        UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:confirmTitle1 style:UIAlertActionStyleDefault handler:confirmBlock1];
        [alertCtrl addAction:okAction1];
        UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:confirmTitle2 style:UIAlertActionStyleDefault handler:confirmBlock2];
        [alertCtrl addAction:okAction2];

        [viewController presentViewController:alertCtrl animated:YES completion:nil];
    }else {
        self.alertView = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle1, confirmTitle2, nil];
        self.alertView.tag = 300;//三个选项
        self.cancelBlock = cancelBlock;
        self.confirmBlock = confirmBlock1;
        self.confirmBlock2 = confirmBlock2;
        self.alertBlock = nil;
        
        [self.alertView show];
    }
}

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
                  confirmBlock3:(ConfirmBlock)confirmBlock3

{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelTitle != nil) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
            [alertCtrl addAction:cancelAction];
        }
        UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:confirmTitle1 style:UIAlertActionStyleDefault handler:confirmBlock1];
        [alertCtrl addAction:okAction1];
        UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:confirmTitle2 style:UIAlertActionStyleDefault handler:confirmBlock2];
        [alertCtrl addAction:okAction2];
        
        UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:confirmTitle3 style:UIAlertActionStyleDefault handler:confirmBlock3];
        [alertCtrl addAction:okAction3];

        [viewController presentViewController:alertCtrl animated:YES completion:nil];
    }else {
        self.alertView = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle1, confirmTitle2, nil];
        self.alertView.tag = 400;//4个选项
        self.cancelBlock = cancelBlock;
        self.confirmBlock = confirmBlock1;
        self.confirmBlock2 = confirmBlock2;
        self.confirm3 = confirmBlock3;

        self.alertBlock = nil;
        
        [self.alertView show];
    }
}
-(void)showShortAlertWithController:(UIViewController *)viewController andMessage:(NSString*)message{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [viewController presentViewController:alertCtrl animated:YES completion:nil];
        
        [self performSelector:@selector(avDisappear:) withObject:alertCtrl afterDelay:3];
        
    }else {
        self.alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [self.alertView show];
        [self.alertView performSelector:@selector(avDismiss:) withObject:nil afterDelay:3];
    }
 
}
-(void)avDisappear:(UIAlertController*)avv{
    [avv dismissViewControllerAnimated:YES completion:^{
        
    }];
    avv=nil;
}
@end
