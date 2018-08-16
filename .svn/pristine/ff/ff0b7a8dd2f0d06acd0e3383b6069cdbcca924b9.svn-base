//
//  HomeTableController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "HomeTableController.h"
#import "SearchTableController.h"

@interface HomeTableController ()
@property (nonatomic, strong) UIButton *navSearchButton;
@end

@implementation HomeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavgationItem];
    self.tableView.tableHeaderView = [self setupHeaderView];
    self.tableView.sectionHeaderHeight = 40;
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navSearchButton removeFromSuperview];
}


- (void)setNavgationItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"clock"] style:UIBarButtonItemStylePlain target:self action:@selector(showMessage)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pen"] style:UIBarButtonItemStylePlain target:self action:@selector(writeQuestion)];
    
    self.navSearchButton = [self customSearchBar];
    self.navSearchButton.height = 30;
    self.navSearchButton.y = self.navigationController.navigationBar.height-30-5;
}


#pragma mark - 响应事件

- (void)showMessage{
    
    
}

- (void)writeQuestion{
    
}


- (void)findAnswer{
    
}

- (void)findExpert{
    
}


- (void)search{
    SearchTableController *vc = [SearchTableController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"财务知识";
    cell.detailTextLabel.text = @"UISearchController是iOS 8** 之后推出的一个新的控件, 用于创建搜索条, 及管理搜索事件, 使用这个, 我们可以很容易的创建属于自己的搜索框, 下面就来看看这个控件的一些使用.";
     return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    if (offsetY > self.tableView.tableHeaderView.height){
        [bar addSubview:self.navSearchButton];
   }else{
       [self.navSearchButton removeFromSuperview];
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    containerView.backgroundColor = GRAYCOLOR_BACKGROUND;
    UILabel *label = [UILabel labelWithFrame:CGRectMake(MARGIN_BIG, 0, SCREEN_WIDTH-MARGIN, 40) text:@"推荐问答" textFont:BOLDFONT_SMALL textColor:MAJORCOLOR];
    [containerView addSubview:label];
    return containerView;
}


#pragma mark - 界面

- (UIView *)setupHeaderView{
    UIImage *image = [UIImage imageNamed:@"home_top_image"];
    CGFloat imageH = image.size.height*SCREEN_WIDTH/image.size.width;
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:image];
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageH);
    backImageView.userInteractionEnabled = YES;
    
    UIButton *searchButton = [self customSearchBar];
    searchButton.y = backImageView.centerY;
    [backImageView addSubview:searchButton];
    
    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(searchButton.x, searchButton.maxY+MARGIN_BIG, 140, 35) title:@"求解答" font:FONT_NORMAL titleColor:WHITECOLOR backgroundImage:@"home_button_background" target:self actionName:@"findAnswer"];
    UIButton *expertButton = [UIButton buttonWithFrame:CGRectMake(searchButton.maxX-140, answerButton.y, 140, 35) title:@"找专家" font:FONT_NORMAL titleColor:WHITECOLOR backgroundImage:@"home_button_background" target:self actionName:@"findExpert"];
    [backImageView addSubview:answerButton];
    [backImageView addSubview:expertButton];
    
     return backImageView;
}


- (UIButton *)customSearchBar{
    UIButton *searchButton = [UIButton buttonWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, 0, 300, 40) title:@"搜索财务内容" font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT imageName:@"search"  target:self actionName:@"search"];
    searchButton.backgroundColor = WHITECOLOR;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.layer.masksToBounds = YES;
    return searchButton;
}

@end
