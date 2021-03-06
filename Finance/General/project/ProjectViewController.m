//
//  ProjectViewController.m
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectCollectionViewCell.h"
#import "ProjectHeaderCollectionReusableView.h"
#import "TopicController.h"//导入这个控制器是为了使用 TopicModel
#import "TopicDetailNewVC.h"
#import "MessageController.h"
#import "AskController.h"
#import "NSString+Extension.h"
#import "SearchController.h"
@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger nowIndex; // 点击之后的tag值
    NSInteger nowRow;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isOpen; // 判断时候点击分组
@property(nonatomic,assign)BOOL isChoose;
@property (nonatomic, strong) NSMutableArray *topicArr;

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topicArr =[NSMutableArray array];
    //去掉cell多余分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //去掉自带分割线
    self.tableView.separatorStyle = NO;
    
    //解决tabbleview底部被遮挡问题
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#fcfcfa"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    //注册一个区头视图
    [self.collectionView registerClass:[ProjectHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _isOpen = NO; // 默认第一个打开
    nowIndex = 0; //
    
    _isChoose = YES; // 默认第一个选中
    nowRow = 0;

    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self getAllTopics];
    }];
    [self.collectionView.mj_header beginRefreshing];
    [self setNavgationItem];

}

- (void)setNavgationItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"clock"] style:UIBarButtonItemStylePlain target:self action:@selector(showMessage)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pen"] style:UIBarButtonItemStylePlain target:self action:@selector(writeQuestion)];
    self.navigationItem.titleView = [self customSearchBar];

}
- (void)showMessage{
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        MessageController *vc = [MessageController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

- (void)writeQuestion{
    AskController *vc = [AskController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.topicArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectTableViewCell"];
    if (!cell) {
        cell=[[ProjectTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ProjectTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TopicModel*theT=self.topicArr[indexPath.row];
    cell.title = theT.one_tag;
    
    if (indexPath.row == nowRow) {
        // 判断打开的是哪个分区
        if (_isOpen) { // 如果打开分组
            cell.poloView.hidden = YES;
            cell.nameLabel.textColor = [UIColor colorWithHexString:@"#989898"];
        }
        cell.poloView.hidden = NO;
        cell.nameLabel.textColor = [UIColor colorWithHexString:@"#e9890e"];
    }else{
        cell.poloView.hidden = YES;
        cell.nameLabel.textColor = [UIColor colorWithHexString:@"#989898"];
    }
    
        // Configure the cell...
        
        return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicModel*theT=self.topicArr[indexPath.row];
    CGFloat height = [NSString heightWithString:theT.one_tag size:CGSizeMake(70, 100) font:12];
    
    return height+10;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (nowRow == indexPath.row) {
        _isChoose = !_isChoose;
        
    } else {
        _isChoose = NO;
        nowRow = indexPath.row;
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
}






#pragma collection
//section

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    if (self.topicArr.count>nowRow) {
        TopicModel*nowTopic=self.topicArr[nowRow];
        return nowTopic.subject_list.count;
    }
    return 0;

    
}

//item个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    if (section == nowIndex) {
        // 判断打开的是哪个分区
        if (self.isOpen) { // 如果打开分组
            return 0;
        }
        TopicModel*nowTopic=self.topicArr[nowRow];
        TopicTwoModel*two=nowTopic.subject_list[section];
        return two.subject_content.count;
    }
    return 0;
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    //重用cell
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];
    
    TopicModel*nowTopic=self.topicArr[nowRow];
    TopicTwoModel*two=nowTopic.subject_list[indexPath.section];
    TopicContentModel*content=two.subject_content[indexPath.row];
    cell.nameLabel.numberOfLines=0;
    [cell.nameLabel setTextAlignment:(NSTextAlignmentLeft)];
    cell.nameLabel.text= content.subject_title;

    
    return cell;
    
}

- (UIButton *)customSearchBar{
    UIButton *searchButton = [UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 30) title:@"搜索财务内容" font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT imageName:@"search"  target:self actionName:@"search"];
    searchButton.backgroundColor = WHITECOLOR;
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.layer.masksToBounds = YES;
    return searchButton;
}
- (void)search{
    SearchController *vc = [SearchController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel*nowTopic=self.topicArr[nowRow];
    TopicTwoModel*two=nowTopic.subject_list[indexPath.section];
    TopicContentModel*content=two.subject_content[indexPath.row];
    TopicDetailNewVC*detail=[TopicDetailNewVC new];
    detail.topicId=content.subject_id;
    [self.navigationController pushViewController:detail animated:YES];
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:


//定义每个UICollectionViewCell 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    TopicModel*nowTopic=self.topicArr[nowRow];
    TopicTwoModel*two=nowTopic.subject_list[indexPath.section];
    TopicContentModel*content=two.subject_content[indexPath.row];
    CGFloat height =[NSString heightWithString:content.subject_title size:CGSizeMake(self.collectionView.frame.size.width-2*12, 100) font:12];
    return CGSizeMake((self.collectionView.frame.size.width-2*12), height>40?height:40);
    
    
}

//定义每个Section 的 margin农村

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(8, 12, 8, 12);//分别为上、左、下、右
    
}
//每个section中不同的行之间的行间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section

{
    
    return 12;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}
//区头区尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProjectHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headView.finshedButton.tag = 1000 + indexPath.section;
        TopicModel*nowTopic=self.topicArr[nowRow];
        TopicTwoModel*two=nowTopic.subject_list[indexPath.section];
        headView.headLabel.text=two.two_tag;
        if (indexPath.section == nowIndex) {
            // 判断打开的是哪个分区
            if (_isOpen) { // 如果打开分组
                headView.headLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
                headView.finshedButton.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
                headView.imageV.image = [UIImage imageNamed:@"xiangxia"];
            }else{
                headView.headLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                headView.finshedButton.backgroundColor = [UIColor colorWithHexString:@"#e9890e"];
                headView.imageV.image = [UIImage imageNamed:@"xiangshang"];
            }
            
        }else{
            headView.headLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
            headView.finshedButton.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
            headView.imageV.image = [UIImage imageNamed:@"xiangxia"];
        }
       
        
        [headView.finshedButton addTarget:self action:@selector(shouqi:) forControlEvents:UIControlEventTouchUpInside];
        
        return headView;
    }else{
        ProjectHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        
        
        return headView;
    }
    
}
-(void)shouqi:(UIButton *)sender{
    if (nowIndex == sender.tag - 1000) {
        _isOpen = !_isOpen;
        
    } else {
        _isOpen = NO;
        nowIndex = sender.tag - 1000;
    }
    [_collectionView reloadData];
    
    
    
}

//头视图
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(200, 40);
    
}
-(void)getAllTopics{
    __weak typeof(self) weakSelf = self;

    [KCommonNetRequest getSubjectTagWithSearchName:@"" andComplete:^(NetworkResult resultCode, id obj) {

        [self.collectionView.mj_header endRefreshing];
        if (resultCode==NetworkResultSuceess) {
            [self.topicArr removeAllObjects];
            for (NSDictionary *dict in (NSArray*)obj){
                TopicModel *model = [TopicModel mj_objectWithKeyValues:dict];
                [self.topicArr addObject:model];
            }
            [self.tableView reloadData];
            [self.collectionView reloadData];
            [self hideCommonEmptyViewWithView:self.view];
        }else{
            [self showHint:(NSString *)obj];
//            [self showEmptyDataAutoWithView:self.view andDataCount:0 andOffset:0 andReloadEvent:^(id obj) {
//                [weakSelf getAllTopics];
//                return ;
//            }];
            [self showEmptyDataWithErrorCode:resultCode andView:self.view andDataCount:0 andOffset:0 andReloadEvent:^(id obj) {
                                [weakSelf getAllTopics];
                                return ;
                            }];
        }
    }];
}

@end
