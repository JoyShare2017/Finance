//
//  UBLabel+FastBuild.h
//  BaiZhiFang
//
//  Created by 赵帅 on 2018/5/23.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import "UBLabel.h"

@interface UBLabel (FastBuild)
+(UBLabel*)makeLabelWithFrame:(CGRect)frame andText:(NSString*)text  andTitleColor:(UIColor*)color andFont:(CGFloat)fontSize;
@end
