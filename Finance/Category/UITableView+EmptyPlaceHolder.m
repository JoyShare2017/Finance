//
//  UITableView+EmptyPlaceHolder.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "UITableView+EmptyPlaceHolder.h"
#import "NoDataView.h"
#import "NoNetworkView.h"

@implementation UITableView (EmptyPlaceHolder)

//添加一个方法
- (void) tableViewDisplayViewForRowCount:(NSUInteger) rowCount reloadEvent:(void(^ _Nullable)())reloadEvent
{
    BOOL isHaveNetwork = [[NetworkManager sharedManager] isNetworkAvailable];
    //如果没有网络
    if (!isHaveNetwork){
        NoNetworkView *noNetworkView = [[NoNetworkView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.backgroundView = noNetworkView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        noNetworkView.reloadEvent = ^{
            reloadEvent();
        };

        if (self.mj_footer){
            self.mj_footer.hidden = YES;
        }
        return;
    }
    
    
    if(rowCount == 0) {
        NoDataView *noDataView = [[NoDataView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backgroundView = noDataView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (self.mj_footer){
            self.mj_footer.hidden = YES;
        }
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (self.mj_footer){
            self.mj_footer.hidden = NO;
        }
    }
}


- (void) tableViewDisplayViewForRowCount:(NSUInteger) rowCount customButton:(UIButton *)customButton reloadEvent:(void(^ _Nullable)())reloadEvent
{
    BOOL isHaveNetwork = [[NetworkManager sharedManager] isNetworkAvailable];
    //如果没有网络
    if (!isHaveNetwork){
        NoNetworkView *noNetworkView = [[NoNetworkView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.backgroundView = noNetworkView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        noNetworkView.reloadEvent = ^{
            reloadEvent();
        };

        if (self.mj_footer){
            self.mj_footer.hidden = YES;
        }
        return;
    }


    if(rowCount == 0) {
        NoDataView *noDataView = [[NoDataView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.backgroundView = noDataView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (self.mj_footer){
            self.mj_footer.hidden = YES;
        }
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (self.mj_footer){
            self.mj_footer.hidden = NO;
        }
    }
}



- (void)tableViewDisplayViewForRowCount:(NSUInteger)rowCount customImage:(NSString *)imageName customText:(NSString *)labelText{
    if(rowCount == 0) {
        NoDataView *noDataView = [[NoDataView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        noDataView.imageName = imageName;
        noDataView.labeText = labelText;
        self.backgroundView = noDataView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (self.mj_footer){
            self.mj_footer.hidden = YES;
        }
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (self.mj_footer){
            self.mj_footer.hidden = NO;
        }
    }
}


- (void)addRefreshWithHeaderBlock:(void (^)())headerBlock footerBlock:(void (^)())footerBlock{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        headerBlock();
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        footerBlock();
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    //在没有数据时不显示下拉加载更多
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.mj_footer = footer;
}


@end





