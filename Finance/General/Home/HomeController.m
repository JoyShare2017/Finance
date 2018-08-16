//
//  HomeController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/20.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "HomeController.h"
#import "SearchController.h"
#import "QuestionCell.h"
#import "AskController.h"
#import "MessageController.h"
#import "QuestionDetailController.h"
#import "AskController.h"

#import "ReviewController.h"

@interface HomeController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *navSearchButton;
@property (nonatomic, assign) CGFloat imageH;
@property (nonatomic, strong) NSMutableArray *questionList;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)UIAlertView*alertView;

@end

@implementation HomeController
{
    UIView*v1;
}
- (NSMutableArray *)questionList{
    if (_questionList == nil){
        _questionList = [NSMutableArray array];
    }
    return _questionList;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    v1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT*0.3)];
    v1.backgroundColor=MAJORCOLOR;
    [self.view addSubview:v1];



    
    [self setNavgationItem];
    self.pageIndex=1;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-49)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    

    self.tableView.tableHeaderView = [self setupHeaderView];
    self.tableView.sectionHeaderHeight = 40;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor=[UIColor clearColor];

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    [self.tableView.tableHeaderView addSubview:self.imageView];
    __weak typeof(self) weakSelf = self;

    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex=1;
       [weakSelf loadQuestionListData];
    }];
    self.tableView.mj_header.backgroundColor=MAJORCOLOR;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex++;
        [weakSelf loadQuestionListData];
    }];
    self.tableView.mj_footer.backgroundColor=WHITECOLOR;
    self.tableView.mj_footer.hidden=YES;
    [KCommonNetRequest checkBanbenAndComplete:^(BOOL success, id obj) {
        if (success) {
            //发现新版本
            NSDictionary*verDic=obj;
            if ([verDic[@"banbenhao"] intValue]!=0)//0不强制升级
            {
                [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:[NSString stringWithFormat: @"发现新版本%@",verDic[@"banbenhao"]] CancelTitle:@"取消" ConfirmTitle:@"更新" message:verDic[@"shuoming"] cancelBlock:^(id obj) {

                } confirmBlock:^(id obj) {
                    NSString*appPath= verDic[@"url"];
                    NSURL *url = [NSURL URLWithString:appPath];
                    [[UIApplication sharedApplication]openURL:url];
                    exit(0);
                }];

            }else{

                [[KCCommonAlertBlock defaultAlertBlock]showAlertWithTitle:[NSString stringWithFormat:@"发现新版本%@,请升级",verDic[@"banbenhao"]] message:verDic[@"shuoming"] alertBlock:^(id obj) {
                    NSString*appPath= verDic[@"url"];
                    NSURL *url = [NSURL URLWithString:appPath];
                    [[UIApplication sharedApplication]openURL:url];
                    exit(0);
                }];

            }

        }
    }];

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
    self.navSearchButton.y = self.navigationController.navigationBar.height-40;
}


#pragma mark - 响应事件

- (void)showMessage{
    if ([self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        MessageController *vc = [MessageController new];
        [self.navigationController pushViewController:vc animated:YES];
    }


    
}


- (void)writeQuestion{
    AskController *vc = [AskController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)findAnswer{
//    AskController *vc = [AskController new];
    ReviewController *vc = [ReviewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)findExpert{
    RootTabBarController *tabBarVc =(RootTabBarController*) [UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVc.selectedIndex = 2;
}


- (void)search{
    SearchController *vc = [SearchController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionDetailController *vc = [QuestionDetailController new];
    QuestionModel *model = self.questionList[indexPath.row];
    vc.questionId = model.question_id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.questionModel = self.questionList[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    containerView.backgroundColor = GRAYCOLOR_BACKGROUND;
    UILabel *label = [UILabel labelWithFrame:CGRectMake(MARGIN_BIG, 0, SCREEN_WIDTH-MARGIN, 40) text:@"推荐问答" textFont:BOLDFONT_SMALL textColor:MAJORCOLOR];
    [containerView addSubview:label];
    return containerView;
}


- (void)loadQuestionListData{
    /*接口：index/question_list 改为question_recommend_list
     参数：
     @param  int  page           第几页(默认第1页)
     @param  int  page_size      每页几条数据(默认6条)
    */
    __weak typeof(self) weakSelf = self;

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/question_recommend_list"];
    NSDictionary *parameter = @{@"page":@(self.pageIndex),
                                @"page_size":@(10),
                                @"search_tile":@""
                                };
    NSLog(@"parameter%@",parameter);
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            [self showEmptyDataWithErrorCode:resultCode andView:self.tableView andDataCount:self.questionList.count andOffset:_imageH+40 andReloadEvent:^(id obj) {
                [weakSelf loadQuestionListData];
                return ;
            }];
            return;
            
        }else{
            if (self.pageIndex==1) {
                [self.questionList removeAllObjects];
            }
            for (NSDictionary *dict in responseObject){
                QuestionModel *model = [QuestionModel mj_objectWithKeyValues:dict];
                [self.questionList addObject:model];
            }
            [self.tableView reloadData];
       self.tableView.mj_footer.hidden=((NSArray*)responseObject).count<10;
            [weakSelf hideCommonEmptyViewWithView:weakSelf.tableView];
        }
    }];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat imageH = self.tableView.tableHeaderView.height;
    CGFloat alpha = (imageH - offsetY)/imageH;
    self.tableView.tableHeaderView.alpha = alpha;
    v1.hidden=offsetY>0;
    if (offsetY > self.tableView.tableHeaderView.height){
        [self.navigationController.navigationBar addSubview:self.navSearchButton];
    }else{
        [self.navSearchButton removeFromSuperview];
    }

}



#pragma mark - 界面

- (UIView *)setupHeaderView{
    UIImage *image = [UIImage imageNamed:@"home_top_image"];
    _imageH = image.size.height*SCREEN_WIDTH/image.size.width;
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:image];
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _imageH);
    backImageView.userInteractionEnabled = YES;
    
    UIButton *searchButton = [self customSearchBar];
    searchButton.y = backImageView.centerY+MARGIN_BIG;
    [backImageView addSubview:searchButton];
    
    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(searchButton.x, searchButton.maxY+MARGIN_BIG, 140, 40) title:@"求解答" font:FONT_NORMAL titleColor:WHITECOLOR backgroundImage:@"home_button_background" target:self actionName:@"findAnswer"];
    UIButton *expertButton = [UIButton buttonWithFrame:CGRectMake(searchButton.maxX-140, answerButton.y, 140, 40) title:@"找专家" font:FONT_NORMAL titleColor:WHITECOLOR backgroundImage:@"home_button_background" target:self actionName:@"findExpert"];
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
