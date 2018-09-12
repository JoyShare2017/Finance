//
//  UBLabel.h
//  KOFACS
//
//  Created by  apple on 16/6/6.
//  Copyright © 2016年  apple. All rights reserved.
//
/*!
 @class         UBLabel
 @author        刘圣杰
 @version       1.0
 @discussion	UBLabel的Block版本
 */
#import <UIKit/UIKit.h>
@class UBLabel;

typedef void(^TapUp)(UBLabel* label);
@interface UBLabel : UILabel
@property (nonatomic,copy) TapUp action;

-(void)addAction:(TapUp)touchUp;
@end
