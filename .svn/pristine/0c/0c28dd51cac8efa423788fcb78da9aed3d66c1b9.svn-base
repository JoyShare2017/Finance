//
//  UBButton.h
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

/*!
 @class         UBButton
 @author        刘圣杰
 @version       1.0
 @discussion	UIButton的Block版本
 */
#import <UIKit/UIKit.h>

@class UBButton;

typedef void(^TouchUp)(UBButton* button);
@interface UBButton : UIButton

@property (nonatomic,copy) TouchUp action;

-(void)addAction:(TouchUp)touchUp;
@end
