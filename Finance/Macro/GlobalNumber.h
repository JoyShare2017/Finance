//
//  GlobalNumber.h
//  CommonProject
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#ifndef GlobalNumber_h
#define GlobalNumber_h


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MARGIN_MAX 30
#define MARGIN_BIG 20
#define MARGIN 10
#define MARGIN_SMALL 5
#define BUTTON_HEIGHT 40
#define SWITCH_BUTTON_VIEW_HEIGHT 40
#define USEABLE_VIEW_HEIGHT (SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define NAVGATION_MAXY (iPhoneX ? 88.f : 64.f)
#define HOME_HEIGHT (iPhoneX ? 34.f : 0.f)

#endif /* GlobalNumber_h */
