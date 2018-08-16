//
//  NSObject+KCommonEmptyView.h
//  Finance
//
//  Created by 赵帅 on 2018/4/24.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KCommonEmptyView)
-(void)showEmptyDataAutoWithView:(UIView*)view  andDataCount:(NSInteger)dateCount andOffset:(NSInteger)offset andReloadEvent:(void(^)(id obj))reloadClick;
-(void)hideCommonEmptyViewWithView:(UIView*)view;

/**
 *  根据网络请求错误码 显示emptyView„
 **/
-(void)showEmptyDataWithErrorCode:(NetworkResult)result andView:(UIView*)view  andDataCount:(NSInteger)dateCount andOffset:(NSInteger)offset andReloadEvent:(void(^)(id obj))reloadClick;
@end
