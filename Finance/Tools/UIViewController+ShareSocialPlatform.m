//
//  UIViewController+ShareSocialPlatform.m
//  Finance
//
//  Created by 赵帅 on 2018/4/17.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "UIViewController+ShareSocialPlatform.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@implementation UIViewController (ShareSocialPlatform)
-(void)shareWebPageWithUrl:(NSString*)urlStr andTitle:(NSString*)title   andShareCallback:(ShareCallback)callback{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title?title:@"财搜---您身边的财税专家" descr:@"." thumImage:[UIImage imageNamed:@"touxiang"]];
        //设置网页地址
        shareObject.webpageUrl =urlStr?urlStr:@"itms-apps://itunes.apple.com/cn/app/id1411889263?mt=8";

        if (platformType == UMSocialPlatformType_Sina) {
            //wblogin_icon  // 分享到微博强制需要一个缩略图
            shareObject.thumbImage =[UIImage imageNamed:@"touxiang"];
        }

        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                callback(@"0",error);

            }else{
                NSLog(@"response data is %@",data);

                callback(@"1",data);
               [self showHint:@"分享成功"];
            }
        }];

    }];



}

@end
