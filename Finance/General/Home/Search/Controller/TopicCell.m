//
//  TopicCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/30.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "TopicCell.h"

@interface TopicCell()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *label;


@end

@implementation TopicCell

- (void)setLableText:(NSString *)lableText{
    self.label.text = [NSString stringWithFormat:@"· %@ ·",lableText];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.label = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) textFont:FONT_BIG textColor:GRAYCOLOR_TEXT];
        self.label.backgroundColor = GRAYCOLOR_BACKGROUND;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];

        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 100)];
        self.webView.delegate = self;
        self.webView.scrollView.bounces = NO;
        self.webView.scrollView.scrollEnabled=NO;
        [self.contentView addSubview:self.webView];
       

    }

    return self;
}


//- (void)webViewDidFinishLoad:(UIWebView *)webView{
////    CGFloat webviewH = webView.scrollView.contentSize.height;
//    CGFloat webviewH = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(webviewH);
//    }];
////    self.cellHeight = webviewH;
//    DebugLog(@"----%f",webviewH);
//}


-(void)setCellHeight:(CGFloat)cellHeight{
    _cellHeight=cellHeight;
    _webView .frame=CGRectMake(0, 30, SCREEN_WIDTH, _cellHeight-30);

}

//- (void)autolayoutUI{
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.equalTo(self.contentView);
//        make.height.mas_equalTo(30);
//    }];
//
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.contentView);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.top.equalTo(self.label.mas_bottom);
//        make.height.mas_equalTo(100);
//        make.bottom.equalTo(self.contentView);
//    }];
//}


@end
