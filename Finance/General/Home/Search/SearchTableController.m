//
//  SearchTableController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/22.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "SearchTableController.h"
#import "SearchResultTableController.h"
#import "SearchCell.h"

#define userDefault_searchHistory @"userDefault_searchHistory"

@interface SearchTableController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *historys;

@end

@implementation SearchTableController


#pragma mark - 懒加载

- (NSMutableArray *)historys {
    
    if (_historys == nil) {
        NSArray *array = [USERDEFAULTS objectForKey:userDefault_searchHistory];
        if (array.count > 0){
            _historys = [NSMutableArray arrayWithArray:array];
        }else{
            _historys = [NSMutableArray arrayWithCapacity:0];
        }
    }
    
    return _historys;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = GRAYCOLOR_BACKGROUND;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MARGIN)];
    headerView.backgroundColor = GRAYCOLOR_BACKGROUND;
    self.tableView.tableHeaderView = headerView;

    [self configureSearchBar];
    [self setFooterView];
}


- (void)dealloc{
    
}


- (void)setFooterView{
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    UILabel *hotSearchLabel = [UILabel labelWithFrame:CGRectMake(MARGIN, 0, SCREEN_WIDTH, 45) text:@"热门搜索" textFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    [containerView addSubview:hotSearchLabel];
    
    NSArray *titles = @[@"审计",@"固定资产",@"税务登记",@"资产评估",@"会计考试",@"财务报表",@"出纳基础",@"凭证账簿",@"个人所得税"];
    for (int i=0;i<9;i++){
        CGFloat btnX = SCREEN_WIDTH/3*(i%3);
        CGFloat btnY = hotSearchLabel.maxY + 45*(i/3);
        UIButton *btn = [UIButton buttonWithFrame:CGRectMake(btnX, btnY, SCREEN_WIDTH/3, 45) title:titles[i] font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT backgroundColor:WHITECOLOR target:self actionName:@"hotSearch:"];
        [containerView addSubview:btn];
    }
    
    self.tableView.tableFooterView = containerView;

}


- (void)hotSearch:(UIButton *)sender{
    [self responseSearchEvent:sender.titleLabel.text];
}


- (void)configureSearchBar{
    UIView *searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 44)];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH-100, 36)];
    searchBar.placeholder = @"搜索";
    //通过KVC拿到textField
    UITextField  *seachTextFild = [searchBar valueForKey:@"searchField"];
    seachTextFild.textColor = BLACKCOLOR;
    seachTextFild.font = FONT_NORMAL;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];

}


- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)responseSearchEvent:(NSString *)text{
    [self.searchBar resignFirstResponder];
    if (text == nil || [text  isEqual: @""]){
        return;
    }
    
    
    //保存搜索历史
    if (self.historys.count >0){
        __block BOOL isHaveSame = NO;
        [self.historys enumerateObjectsUsingBlock:^(NSString *  _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([string isEqualToString:text]){
                //这里并不会马上退出循环，而是执行完 block 中的代码才退出循环
                *stop = YES;
                isHaveSame = YES;
                return; //退出此次循环
                //return + stop 马上跳出整个循环体
            }
        }];
        
        if (isHaveSame == false){
            [self.historys insertObject:text atIndex:0];
        }
        
    }else{
        [self.historys addObject:text];
    }
    
    if (self.historys.count >10){
        [self.historys removeLastObject];
    }
    [USERDEFAULTS setObject: [self.historys copy] forKey:userDefault_searchHistory];
    [USERDEFAULTS synchronize];
    
    //跳转
    SearchResultTableController *vc = [SearchResultTableController new];
    vc.searchText = text;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark  - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self responseSearchEvent:searchBar.text];
    [self.tableView reloadData];
    searchBar.text = @"";
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell == nil){
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:self options:nil].firstObject;
    }
    cell.label.text = self.historys[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self responseSearchEvent:self.historys[indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.historys.count > 0){
        UIButton *clearButton = [UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) title:@"清空搜索记录" font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT backgroundColor:WHITECOLOR target:self actionName:@"clear"];
        return clearButton;
    }else{
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    
}


- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    if (self.historys.count > 0){
        return 60;
    }else{
        return 0.01f;
    }
}


- (void)clear{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除所有历史记录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [USERDEFAULTS removeObjectForKey:userDefault_searchHistory];
        [self.historys removeAllObjects];
        [self.tableView reloadData];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
