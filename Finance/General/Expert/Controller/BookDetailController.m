//
//  BookDetailController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/23.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "BookDetailController.h"
#import "BookCell.h"
#import "BookModel.h"
#import "EditBookOrderVC.h"

@interface BookDetailController ()
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) BookModel*bookmodel;
@end

@implementation BookDetailController
{
    BookCell*cell;
    UILabel*label,*describeLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家著作详情";
    self.view.backgroundColor=WHITECOLOR;
    _collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_white"] forState:(UIControlStateNormal)];
    [_collectBtn setImage:[UIImage imageNamed:@"star_red"] forState:(UIControlStateSelected)];
    [_collectBtn addTarget:self action:@selector(collect) forControlEvents:(UIControlEventTouchUpInside)];

    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];

    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    self.navigationItem.rightBarButtonItems = @[forwardItem,collectItem];
    [self loadBookDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)setupUI:(BookModel *)model{
    self.collectBtn.selected=model.collection_check;

    [cell removeFromSuperview];
    [label removeFromSuperview];
    [describeLabel removeFromSuperview];
    //添加视图
    cell = [[BookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookCell"];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
//    cell.describeLabel.hidden = YES;
    cell.bookModel = model;
    cell.button.hidden=YES;
    [self.view addSubview:cell];

    label = [UILabel labelWithFirstIndent:10 frame:CGRectMake(0, cell.maxY, SCREEN_WIDTH, 40) text:@"内容简介" textFont:FONT_SMALL textColor:MAJORCOLOR backgroundColor:GRAYCOLOR_BACKGROUND];
    [self.view addSubview:label];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:model.book_describe attributes:@{NSForegroundColorAttributeName:BLACKCOLOR}];
    describeLabel = [UILabel labelWithOrigin:CGPointMake(MARGIN, label.maxY+MARGIN_BIG) attributedText:attr textFont:FONT_NORMAL];
    [self.view addSubview:describeLabel];
    
    
    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT-50, SCREEN_WIDTH, 50) title:@"立即购买" font:FONT_BIG titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"callbuy"];
    [self.view addSubview:answerButton];
}
-(void)callbuy{
    if (![self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {
    }]) {
        return;
    }
    EditBookOrderVC*order=[EditBookOrderVC new];
    order.book=self.bookmodel;
    [self.navigationController pushViewController:order animated:YES];
    
}
- (void)collect{

    if (![self TestjudegLoginWithSuperVc:self andLoginSucceed:^(id obj) {
        [self loadBookDetailInfo];
    }]) {
        return;
    }

    [KCommonNetRequest deleteSubjectFollowWithBook_id:self.bookId andISFollow:!self.collectBtn.isSelected andComplete:^(BOOL success, id obj) {
        if (success) {
            self.collectBtn.selected=!self.collectBtn.selected;
            [self showHint:self.collectBtn.selected?@"收藏成功":@"取消收藏成功" ];
        }else{
            [self showHint:(NSString *)obj];
        }
    }];

}

- (void)forward{
    [self shareWebPageWithUrl:nil andTitle:nil andShareCallback:^(NSString *type, id data) {

    }];
}


- (void)loadBookDetailInfo{
    /*接口：index/book_show
     参数：
     @param  int     book_id     * 图书的主键
     @param  int      user_id        用户的id
     @param  string    user_name      用户名*/
    [self showHudInView:self.view];

    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/book_show"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"book_id":@([self.bookId integerValue]),
                                @"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name
                                };
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }
        BookModel *model = [BookModel mj_objectWithKeyValues:responseObject];
        [self setupUI:model];
        self.bookmodel=model;
    }];
}


@end
