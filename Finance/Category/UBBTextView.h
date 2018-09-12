//
//  UBBTextView.h
//  kobelco
//
//  Created by 董天文 on 16/10/22.
//  Copyright © 2016年 TYKJ. All rights reserved.
//

/*!
 @class         UBBTextView
 @author        董天文
 @version       1.0
 @discussion	继承与UBTextView,可以设置placeholder、限定内容长度、禁止复制粘贴
 */

#import <UIKit/UIKit.h>
#import "UBTextView.h"
   
@interface UBBTextView : UBTextView

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,assign) int limiteWords;
@property (nonatomic,strong) UILabel *placeholderView;

//@property (nonatomic, weak) UBTextView *textView;
-(instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder andLimiteWords:(int)limiteWords;

-(void)textDidChange;

@end
