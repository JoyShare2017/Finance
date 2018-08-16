//
//  ButtonSwitchView.h
//  jiaoquaner
//
//  Created by 郝旭珊 on 2017/12/5.
//  Copyright © 2017年 yimofang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^buttonSwitchAction)(UIButton *);

@interface SwitchButtonView : UIView

//修改当前选中按钮
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) buttonSwitchAction buttonSwitch;

/**
 * default init方法, initWithFrame无效
 *
 */
- (instancetype)initWithTitles:(NSArray *)titles;

@end
