//
//  EmptyDataView.m
//  Finance
//
//  Created by 赵帅 on 2018/4/20.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "EmptyDataView.h"

@implementation EmptyDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(void)makeEmptyViewWithDescript:(NSString*)des andBtnTitle:(NSString*)btnTitle andClickBtnAction:(void (^)(id obj))click{

    UIImageView*iv=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5-32, 0, 64, 64)];
    iv.image=[UIImage imageNamed:@"no_info"];
    [self addSubview:iv];

    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame)+20, self.frame.size.width, 50)];
    lb.numberOfLines=2;
    [lb setTextAlignment:(NSTextAlignmentCenter)];
    lb.font=[UIFont systemFontOfSize:18];
    lb.textColor=[UIColor lightGrayColor];
    lb.text=des;
    [self addSubview:lb];

    UBButton*btn=[[UBButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5-105, CGRectGetMaxY(lb.frame)+35, 210, 40)];
    [btn setTitle:btnTitle forState:(UIControlStateNormal)];
    btn.titleLabel.font=[UIFont systemFontOfSize:20];
    btn.layer.cornerRadius=20;
    btn.layer.borderColor=MAJORCOLOR.CGColor;
    btn.layer.borderWidth=0.8;
    [btn setTitleColor:MAJORCOLOR forState:(UIControlStateNormal)];
    [self addSubview:btn];
    [btn addAction:^(UBButton *button) {
        click(@"");
    }];



}
@end
