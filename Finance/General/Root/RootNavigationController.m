//
//  RootNavigationController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = self.navigationBar;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITECOLOR}];
    bar.translucent = NO;
    bar.tintColor = WHITECOLOR;

    bar.barTintColor = MAJORCOLOR;
//    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forBarMetrics:UIBarMetricsDefault];
    //去除导航栏下方横线
    [bar setShadowImage:[UIImage new]];
     [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(-150, 0) forBarMetrics:UIBarMetricsDefault];

}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0){
//        viewController.view.backgroundColor = WHITECOLOR;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}


@end
