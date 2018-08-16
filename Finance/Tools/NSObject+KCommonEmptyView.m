//
//  NSObject+KCommonEmptyView.m
//  Finance
//
//  Created by 赵帅 on 2018/4/24.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "NSObject+KCommonEmptyView.h"
#import "NoNetworkView.h"
#import "NoDataView.h"
#import "SeverErrorView.h"
@implementation NSObject (KCommonEmptyView)
-(void)showEmptyDataAutoWithView:(UIView*)view  andDataCount:(NSInteger)dateCount andOffset:(NSInteger)offset andReloadEvent:(void(^)(id obj))reloadClick{
    [self hideCommonEmptyViewWithView:view];
    BOOL isHaveNetwork = [[NetworkManager sharedManager] isNetworkAvailable];

    CGRect frame = CGRectMake(0, offset, view.frame.size.width, view.frame.size.height-offset);
    //如果没有网络
    if (!isHaveNetwork){
        NoNetworkView *noNetworkView = [[NoNetworkView alloc]initWithFrame:frame];
        noNetworkView.tag=13999;
        noNetworkView.reloadEvent = ^{
            reloadClick(@"");
        };

        [view addSubview:noNetworkView];
    }else {
        if (dateCount==0) {
            NoDataView *noDataView = [[NoDataView alloc] initWithFrame:frame];
            noDataView.tag=13999;
            [view addSubview:noDataView];
        }

    }

}

/**
 *  根据网络请求错误码 显示emptyView„
 **/
-(void)showEmptyDataWithErrorCode:(NetworkResult)result andView:(UIView*)view  andDataCount:(NSInteger)dateCount andOffset:(NSInteger)offset andReloadEvent:(void(^)(id obj))reloadClick{
    [self hideCommonEmptyViewWithView:view];

    CGRect frame = CGRectMake(0, offset, view.frame.size.width, view.frame.size.height-offset);
    //如果没有网络
    if (![[NetworkManager sharedManager] isNetworkAvailable]){
        NoNetworkView *noNetworkView = [[NoNetworkView alloc]initWithFrame:frame];
        noNetworkView.tag=13999;
        noNetworkView.reloadEvent = ^{
            reloadClick(@"");
        };

        [view addSubview:noNetworkView];
    }else if (result == NetworkResultError){
        SeverErrorView *noNetworkView = [[SeverErrorView alloc]initWithFrame:frame];
        noNetworkView.tag=13999;
        noNetworkView.reloadEvent = ^{
            reloadClick(@"");
        };
        [view addSubview:noNetworkView];
    }else if (result == NetworkResultNODATASUCCESS&&dateCount==0){
        NoDataView *noDataView = [[NoDataView alloc] initWithFrame:frame];
        noDataView.tag=13999;
        [view addSubview:noDataView];
    }else{
    }
}

-(void)hideCommonEmptyViewWithView:(UIView*)view{
    for (UIView*subView in view.subviews) {
        if (subView.tag==13999) {
            [subView removeFromSuperview];
        }
    }
}
@end
