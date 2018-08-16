//
//  RootTabBarController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/19.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "HomeController.h"
#import "QuestionController.h"
#import "ExpertController.h"
#import "ProjectViewController.h"
#import "MineTableViewController.h"

#import "LoginController.h"


@interface RootTabBarController ()
@end

@implementation RootTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色 去掉分割线
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];

    [self setupAllChildViewController];
}


- (void)setupAllChildViewController{

    HomeController *homeVc = [HomeController new];
    QuestionController *questionVc = [QuestionController new];
    ExpertController *expertVc = [ExpertController new];
    ProjectViewController *projectVc = [ProjectViewController new];
    MineTableViewController *mineVc = [MineTableViewController new];

    NSArray *vcs = @[homeVc,questionVc,expertVc,projectVc,mineVc];
    NSArray *imageNames = @[@"home",@"question",@"expert",@"topic",@"mine"];
    NSArray *titles = @[@"首页",@"问答",@"专家",@"专题",@"我的"];
    for (int i=0;i<5;i++){
        NSString *imageName = [NSString stringWithFormat:@"bar_%@",imageNames[i]];
        NSString *selectedImageName = [NSString stringWithFormat:@"bar_%@_selected",imageNames[i]];
        [self setupChildViewController:vcs[i] title:titles[i] imageName:imageName selectedImageName:selectedImageName tag:i];
    }
    
}


- (void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName tag:(NSInteger)tag{
    controller.title = title;
    controller.tabBarItem.tag = tag;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:GRAYCOLOR_TEXT,NSFontAttributeName:FONT_SMALL} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MAJORCOLOR,NSFontAttributeName:FONT_SMALL} forState:UIControlStateSelected];
    
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
    [self addChildViewController:nav];
    
}


@end
