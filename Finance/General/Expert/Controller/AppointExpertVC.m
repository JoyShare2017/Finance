//
//  AppointExpertVC.m
//  Finance
//
//  Created by 赵帅 on 2018/4/20.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "AppointExpertVC.h"
#import "EmptyDataView.h"
@interface AppointExpertVC ()

@end

@implementation AppointExpertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=GRAYCOLOR_BACKGROUND;
    self.title=@"预约专家";
    EmptyDataView*emptyV=[[EmptyDataView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT-90)];
    [self.view addSubview:emptyV];
    __weak typeof(self) weakSelf = self;

    [emptyV makeEmptyViewWithDescript:@"抱歉，该功能线上暂未开通\n如需预约专家，请联系客服" andBtnTitle:@"联系客服" andClickBtnAction:^(id obj) {
        [KCommonNetRequest getServiceNumberAndComplete:^(BOOL success, id obj) {
            if (success) {
                UIWebView * webView = [[UIWebView alloc]init];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",obj[@"service_phone"]]]]];
                [weakSelf.view  addSubview:webView];
            }else{
                [weakSelf showHint:(NSString *)obj];
            }

        }];

    }];
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
