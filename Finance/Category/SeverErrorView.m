//
//  SeverErrorView.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/18.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "SeverErrorView.h"

@interface SeverErrorView ()

@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIButton * reloadBtn;


@end

@implementation SeverErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor redColor];
        [self setup];
    }
    return  self;
}


- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    [self addSubview:self.reloadBtn];
}


- (UIImageView *)imageView
{
    if(_imageView == nil) {
        CGFloat imgW = 115.0f;
        CGFloat imgH = 115.0f;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-imgW*0.5,self.frame.size.height*0.5-imgH*0.5-95*0.5, imgW, imgH)];
        _imageView.image = [UIImage imageNamed:@"no_data"];
    }
    
    return  _imageView;
}

- (UILabel *) label
{
    if(_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+20, self.frame.size.width, 15)];
        _label.text = @"服务器出错了, 莫慌, 刷新试试看~";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = GRAYCOLOR_TEXT;
        _label.font = [UIFont systemFontOfSize:15];
    }
    return  _label;
}

- (UIButton *) reloadBtn
{
    if(_reloadBtn == nil) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = 100.0f;
        CGFloat btnH = 40.0f;
        _reloadBtn.frame = CGRectMake(self.center.x-btnW * 0.5, CGRectGetMaxY(self.label.frame)+20, btnW, btnH);
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:GRAYCOLOR_TEXT forState:UIControlStateNormal];
        _reloadBtn.layer.borderWidth = 1;
        _reloadBtn.layer.cornerRadius = btnH/2;
        _reloadBtn.layer.borderColor = GRAYCOLOR_BORDER.CGColor;
        [_reloadBtn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchDown];
    }
    return _reloadBtn;
}


// 按钮方法
- (void) btnDidClicked:(UIButton *) sender
{
    if (self.reloadEvent){
        self.reloadEvent();
    }
}


@end

