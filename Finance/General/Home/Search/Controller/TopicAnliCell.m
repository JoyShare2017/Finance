//
//  TopicAnliCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/11.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "TopicAnliCell.h"
@interface TopicAnliCell()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIScrollView *anliTitleScr;
@property (nonatomic, weak) UIButton *weakSelectedBtn;

@end
@implementation TopicAnliCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.label = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) textFont:FONT_BIG textColor:GRAYCOLOR_TEXT];
        self.label.backgroundColor = GRAYCOLOR_BACKGROUND;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text=@"案例";
        [self.contentView addSubview:self.label];

        self.anliTitleScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 40)];
        self.anliTitleScr.showsHorizontalScrollIndicator=NO;
        [self.contentView addSubview:self.anliTitleScr];

        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
        self.webView.delegate = self;
        self.webView.scrollView.scrollEnabled=NO;
        self.webView.scrollView.bounces=NO;
        [self.contentView addSubview:self.webView];

//        [self autolayoutUI];
    }

    return self;
}
//- (void)autolayoutUI{
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.equalTo(self.contentView);
//        make.height.mas_equalTo(30);
//    }];
//
//    [self.anliTitleScr mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.contentView);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.top.equalTo(self.label.mas_bottom);
//        make.height.mas_equalTo(40);
//
//    }];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.contentView);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.top.equalTo(self.anliTitleScr.mas_bottom);
//        make.height.mas_equalTo(100);
//        make.bottom.equalTo(self.contentView);
//    }];
//}
-(void)setCellHeight:(CGFloat)cellHeight{
    _cellHeight=cellHeight;
    _webView .frame=CGRectMake(0, 30, SCREEN_WIDTH,cellHeight-30);

}
-(void)setAnliArr:(NSArray *)anliArr{
    _anliArr=anliArr;
    for (id obj in self.anliTitleScr.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [(UIButton*)obj removeFromSuperview];
        }
    }

    if ([_anliArr isKindOfClass:[NSArray class]]) {

        CGFloat btnWidth=SCREEN_WIDTH/self.anliArr.count;
        if (btnWidth<75) {btnWidth=75;}
        for (int i=0; i<self.anliArr.count; i++) {

            UIButton *btn = [UIButton buttonWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, 40) title:[NSString stringWithFormat:@"案例%d",i+1] font:FONT_NORMAL titleColor:GRAYCOLOR_TEXT backgroundColor:GRAYCOLOR_BORDER target:self actionName:@"switchPageAction:"];
            [btn setTitleColor:WHITECOLOR forState:UIControlStateSelected];
            btn.tag=100+i;
            [self.anliTitleScr addSubview:btn];
            if (i==0) {[self switchPageAction:btn];}
        }
        [self.anliTitleScr setContentSize:CGSizeMake(btnWidth*self.anliArr.count, 40)];
    }

}
- (void)switchPageAction:(UIButton *)sender{
    self.weakSelectedBtn.selected=NO;
    self.weakSelectedBtn.backgroundColor=GRAYCOLOR_BORDER;
    self.weakSelectedBtn=sender;
    self.weakSelectedBtn.selected=YES;
    self.weakSelectedBtn.backgroundColor=MAJORCOLOR;


    if (sender.tag>=100) {
        [self.webView loadHTMLString:self.anliArr[sender.tag-100] baseURL:nil];
    }

}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    CGFloat webviewH = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(webviewH);
//    }];
//    DebugLog(@"TopicAnliCell----%f",webviewH);
//}
@end
