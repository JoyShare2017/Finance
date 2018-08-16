//
//  MyTagViewController.m
//  Finance
//
//  Created by 赵帅 on 2018/4/10.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyTagViewController.h"
#import "EditMyTagVController.h"
#import "TagSmallModel.h"
#import "ChannelButton.h"
#import "NoNetworkView.h"
#import "NoDataView.h"
#import "NSObject+KCommonEmptyView.h"
@interface MyTagViewController ()
@property(nonatomic,strong)UIScrollView*myChannelView;
@property (nonatomic, strong) NSMutableArray *selectedChannelArr;

@end

@implementation MyTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的标签";
    self.view.backgroundColor=[UIColor whiteColor];
    self.selectedChannelArr=[NSMutableArray array];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    UILabel * myLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    myLb.text = @"我的标签";
    myLb.font = [UIFont systemFontOfSize:16];
    myLb.textColor = MAJORCOLOR;
    [self.view addSubview:myLb];

    //获取我的标签
    [self layOutMyChannelViews];


}

-(void)getMyTags{

    __weak typeof(self) weakSelf = self;

    [KCommonNetRequest getQuetionTagWithIsMytag:YES andComplete:^(NetworkResult resultCode, id obj) {

        [self.myChannelView.mj_header endRefreshing];
        if (resultCode==NetworkResultSuceess) {
            [self hideCommonEmptyViewWithView:self.view];
            [self.selectedChannelArr removeAllObjects];
            for (NSDictionary *dict in obj){

                TagSmallModel *model = [TagSmallModel mj_objectWithKeyValues:dict];
                [self.selectedChannelArr addObject:model];

            }
            [self layOutMyChannelViews];
        }else{
            [self showEmptyDataAutoWithView:self.view andDataCount:0 andOffset:0 andReloadEvent:^(id obj) {
                [weakSelf getMyTags];
                return;
            }];
        }
    }];

}

-(void)layOutMyChannelViews{

    for (id obj in self.myChannelView.subviews) {

        if ([obj isKindOfClass:[ChannelButton class]]) {
            ChannelButton*cb=(ChannelButton*)obj;
            [cb removeFromSuperview];

        }
    }


    if (!_myChannelView) {

        _myChannelView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 10+30, SCREEN_WIDTH-20, SCREEN_HEIGHT-40-NAVGATION_MAXY-HOME_HEIGHT)];
        _myChannelView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_myChannelView];
        _myChannelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getMyTags];
        }];
        [_myChannelView.mj_header beginRefreshing];

    }


    CGFloat btnWidth =(_myChannelView.frame.size.width-20)/3;
    for (int i=0; i<_selectedChannelArr.count; i++) {
        TagSmallModel*chn=_selectedChannelArr[i];
        ChannelButton*chanBtn=[[ChannelButton alloc]initWithFrame:CGRectMake((i%3)*(btnWidth+10), 10+40*(i/3),btnWidth , 30)];
        [chanBtn setTitle:chn.qt_name forState:(UIControlStateNormal)];
        chanBtn.tag=i;
        chanBtn.closeBtn.hidden=YES;
        chanBtn.channel_id=[chn.qt_id integerValue];
        chanBtn.closeBtn.tag=chanBtn.channel_id;
        chanBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_myChannelView addSubview:chanBtn];

    }

}

- (void)edit:(UIBarButtonItem *)item{
    EditMyTagVController*edit=[EditMyTagVController new];
    edit.oldChannelArr=self.selectedChannelArr;
    __weak typeof(self) weakSelf = self;

    edit.changeedTheTags = ^(NSMutableArray *tags) {
        weakSelf.selectedChannelArr=tags;
        [weakSelf layOutMyChannelViews];
    };
    [self.navigationController pushViewController:edit animated:YES];
    
    
}


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
