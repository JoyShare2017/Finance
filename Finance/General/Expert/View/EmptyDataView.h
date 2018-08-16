//
//  EmptyDataView.h
//  Finance
//
//  Created by 赵帅 on 2018/4/20.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyDataView : UIView
-(void)makeEmptyViewWithDescript:(NSString*)des andBtnTitle:(NSString*)btnTitle andClickBtnAction:(void (^)(id obj))click;
@end
