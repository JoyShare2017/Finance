//
//  UBLabel+FastBuild.m
//  BaiZhiFang
//
//  Created by 赵帅 on 2018/5/23.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import "UBLabel+FastBuild.h"

@implementation UBLabel (FastBuild)
+(UBLabel*)makeLabelWithFrame:(CGRect)frame andText:(NSString*)text  andTitleColor:(UIColor*)color andFont:(CGFloat)fontSize{
    UBLabel*lb=[[UBLabel alloc]initWithFrame:frame];
    lb.text=text;
    lb.font=[UIFont systemFontOfSize:fontSize];
    lb.textColor=color;
    return lb;
}
@end
