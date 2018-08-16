//
//  BaseController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "BaseController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface BaseController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@end

@implementation BaseController

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"no_info"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"还没有消息内容" attributes:@{NSFontAttributeName:FONT_NORMAL,NSForegroundColorAttributeName:GRAYCOLOR_TEXT}];
    return attr;
}


#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

 // Configure the cell...

 return cell;
 }
 */

@end
