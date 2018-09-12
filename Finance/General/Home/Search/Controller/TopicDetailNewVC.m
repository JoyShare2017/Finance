//
//  TopicDetailNewVC.m
//  Finance
//
//  Created by 赵帅 on 2018/5/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "TopicDetailNewVC.h"
#import "TopicCell.h"
#import "TopicAnliCell.h"
#import "TopicDetailModel.h"
#define HeaderView_Height 80
#define FooterView_Height 50
@interface TopicDetailNewVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, copy) NSArray *footerButtons;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) TopicDetailModel *topicDetailModel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) NSArray *anliarr;
@property (nonatomic, strong) UIWebView*web1,*web2,*web3;
@property (nonatomic, assign) CGFloat webheight1;
@property (nonatomic, assign) CGFloat webheight2;
@property (nonatomic, assign) CGFloat webheight3;
@end

@implementation TopicDetailNewVC
{
    NSInteger TAGI;
    UIView*theFooter;
}
static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifierAnli = @"CellAnli";
- (NSArray *)titles{
    if (_titles == nil){
        _titles = @[@"概念",@"实操",@"案例"];
    }
    return _titles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知识解读";
    self.view.backgroundColor=WHITECOLOR;
    [self loadTopicDetail];
    [self addNavgationItem];
    [self setupFooterView];
    self.webheight1=200;self.webheight2=200;self.webheight3=200;TAGI=0;
    self.tv=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY-50) style:(UITableViewStylePlain)];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    [self.tv registerClass:[TopicCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tv registerClass:[TopicAnliCell class] forCellReuseIdentifier:reuseIdentifierAnli];
    [self.view addSubview:self.tv];
    

}
- (void)addNavgationItem{
    _collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_white"] forState:(UIControlStateNormal)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_red"] forState:(UIControlStateSelected)];
    [_collectBtn addTarget:self action:@selector(collect) forControlEvents:(UIControlEventTouchUpInside)];

    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];
    //    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    self.navigationItem.rightBarButtonItems = @[collectItem];
}

- (void)collect{
    if (![self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {

    }]) {
        return;
    }

    [self showHudInView:self.view];
    [KCommonNetRequest followOrDeleteSubjectFollowWithSubject_id:self.topicId andISFollow:!_collectBtn.selected andComplete:^(BOOL success, id obj) {
        [self hideHud];
        if (success) {
            [self showHint:_collectBtn.selected?@"取消收藏成功":@"收藏成功" ];
            self.collectBtn.selected=!self.collectBtn.selected;
        }else{
            [self showHint:(NSString *)obj];
        }

    }];
}



- (void)setupFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, USEABLE_VIEW_HEIGHT-FooterView_Height, SCREEN_WIDTH, FooterView_Height)];
    footerView.layer.borderWidth = 1;
    footerView.layer.borderColor = GRAYCOLOR_BORDER.CGColor;
    [self.view addSubview:footerView];
    theFooter=footerView;
    NSMutableArray *mArray = [NSMutableArray array];
    CGFloat btnW = SCREEN_WIDTH / 3;
    for (int i=0;i<3;i++){
        NSArray *titles = @[@"概念",@"实操",@"案例"];
        UIButton *btn = [UIButton buttonWithFrame:CGRectMake(btnW*i, 0, btnW, 50) title:titles[i] font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT backgroundColor:WHITECOLOR target:self actionName:@"switchPageAction:"];
        [btn setTitleColor:WHITECOLOR forState:UIControlStateSelected];
        btn.tag = i;
        if (btn.tag == 0){
            btn.backgroundColor = MAJORCOLOR;
            btn.selected = YES;
            self.selectedButton = btn;
        }
        [footerView addSubview:btn];
        [mArray addObject:btn];
    }
    self.footerButtons = mArray;
}


- (void)switchPageAction:(UIButton *)sender{
    self.selectedButton.selected = NO;
    self.selectedButton.backgroundColor = WHITECOLOR;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    self.selectedButton.backgroundColor = MAJORCOLOR;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tv scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y<=_webheight1) {
        TAGI=0;
    }else if(scrollView.contentOffset.y>_webheight1+_webheight2-(self.tv.frame.size.height-_webheight3)){
        TAGI=2;
    }else{
        TAGI=1;
    }



    if (TAGI!=self.selectedButton.tag) {
        for (UIButton*btn in theFooter.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag==TAGI) {

                    self.selectedButton.selected = NO;
                    self.selectedButton.backgroundColor = WHITECOLOR;
                    self.selectedButton = btn;
                    self.selectedButton.selected = YES;
                    self.selectedButton.backgroundColor = MAJORCOLOR;
                }
            }
        }

    }
}



#pragma mark - mark tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return  _webheight1+30;
    }
    if (indexPath.row==1) {
        return  _webheight2+30;
    }
    if (indexPath.row==2) {
        return  _webheight3+30;
    }
    return 200;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        TopicAnliCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierAnli];
        if (_webheight1==200) {
            cell.anliArr=self.anliarr;
            self.web3=cell.webView;
            self.web3.delegate=self;
        }
        cell.cellHeight=self.webheight3+30;
        return cell;
    }else{

        TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.contentView.backgroundColor = WHITECOLOR;
        cell.lableText = self.titles[indexPath.row];

        NSString *htmlStr;
        if (indexPath.row == 0){
            if (_webheight1==200) {
                self.web1=cell.webView;
                htmlStr = self.topicDetailModel.subject_content_gainian;
                self.web1.delegate=self;
                if (htmlStr.length>0) {
                    [self.web1 loadHTMLString:htmlStr baseURL:nil];
                }
            }
            cell.cellHeight=self.webheight1+30;

        }else if (indexPath.row == 1){
            if (_webheight2==200) {

                self.web2=cell.webView;
                htmlStr = self.topicDetailModel.subject_content_shicao;
                self.web2.delegate=self;
                if (htmlStr.length>0) {
                    [self.web2 loadHTMLString:htmlStr baseURL:nil];
                }

            }
            cell.cellHeight=self.webheight2+30;

        }
        return cell;
    }
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 禁止用户复制粘贴
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁止用户拨打电话
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    if (webView==_web1) {
        _webheight1=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];

    }
    if (webView==_web2) {
        _webheight2=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];

    }
    if (webView==_web3) {
        _webheight3=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];

    }

    [self.tv reloadData];
}


- (void)loadTopicDetail{
    [self showHudInView:self.view];
    /*
     接口：index/subject_show
     参数：
     @param  string      subject_id        * 专题的id
     @param  int       user_id         用户的id
     @param  string      user_name       用户名
     */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/subject_show"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"subject_id":self.topicId,
                                @"user_id":@([user.user_id integerValue]),
                                @"user_name" : user.user_name
                                };

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        NSLog(@"*****responseObject*****%@",responseObject);
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }
        self.anliarr=responseObject[@"subject_content_anli"];


        self.topicDetailModel = [TopicDetailModel mj_objectWithKeyValues:responseObject];
        self.collectBtn.selected=self.topicDetailModel.follow_ok;

        UILabel *headerLabel = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderView_Height) text:self.topicDetailModel.subject_title textFont:FONT_MAX textColor:BLACKCOLOR];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        self.tv.tableHeaderView=headerLabel;

        [self.tv reloadData];
    }];

}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    self.webheight1=200;self.webheight2=200;self.webheight3=200;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
