//
//  UBButton+FastBuild.m
//  BaiZhiFang
//
//  Created by 赵帅 on 2018/5/23.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import "UBButton+FastBuild.h"
#import "AppDelegate.h"
@implementation UBButton (FastBuild)
+(UBButton*)makeButtonWithFrame:(CGRect)frame andTitle:(NSString*)title  andTitleColor:(UIColor*)color andFont:(CGFloat)fontSize andBackGroundColor:(UIColor*)bgColor{
    UBButton*btn=[[UBButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    btn.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    [btn setBackgroundImage:[AppDelegate imageWithColor:bgColor size:frame.size] forState:(UIControlStateNormal)];
    return btn;

}




@end
