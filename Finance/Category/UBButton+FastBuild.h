//
//  UBButton+FastBuild.h
//  BaiZhiFang
//
//  Created by 赵帅 on 2018/5/23.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import "UBButton.h"

@interface UBButton (FastBuild)
+(UBButton*)makeButtonWithFrame:(CGRect)frame andTitle:(NSString*)title  andTitleColor:(UIColor*)color andFont:(CGFloat)fontSize andBackGroundColor:(UIColor*)bgColor;
@end
