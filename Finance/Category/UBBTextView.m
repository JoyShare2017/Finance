//
//  UBBTextView.m
//  kobelco
//
//  Created by 董天文 on 16/10/22.
//  Copyright © 2016年 TYKJ. All rights reserved.
//

#import "UBBTextView.h"

@interface UBBTextView ()


@end

@implementation UBBTextView

-(instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder andLimiteWords:(int)limiteWords
{
    if (self = [super initWithFrame:frame]) {
        
//        WEAKSELF
        self.layer.borderWidth = 0.6;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1].CGColor;
        
//        self.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错
//        self.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母大写
        self.textColor = [UIColor blackColor];

        self.placeholder = placeholder;
        self.limiteWords = limiteWords;
        
        self.placeholderView = [[UILabel alloc]init];
        
        self.placeholderView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        self.placeholderView.text = placeholder;
        
        [self addSubview:self.placeholderView];

        //监听textView内容改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil]; //通知:监听文字的改变
        
        
    }
    return self;
}
//禁止复制粘贴
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}

-(void)textDidChange
{
    //    NSLog(@"textView%@",textView.text);
    if (self.text.length > self.limiteWords) {
        
        self.text = [self.text substringToIndex:self.limiteWords];
    }
    if (self.text.length == 0) {//当text为空时placeholderView在左边显示placeholder
        
        self.placeholderView.textAlignment = NSTextAlignmentLeft;
        self.placeholderView.text = self.placeholder;
        self.placeholderView.frame = CGRectMake(5, 5, self.frame.size.width, 20.0);
        
    }else{//当text不为空时placeholderView在右下角显示字数和总字数
    
        self.placeholderView.textAlignment = NSTextAlignmentRight;
        NSString *wordCount = [NSString stringWithFormat:@"%d",(int)self.text.length];
        self.placeholderView.text = [NSString stringWithFormat:@"%@/%d",wordCount,self.limiteWords];
//        self.placeholderView.text = @"";
//        self.placeholderView.frame = CGRectZero;

        self.placeholderView.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height - 20.0, self.frame.size.width / 2, 20.0);
    }
    
}

/**
 cell布局时所调用的函数
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    NSLog(@"%s==%@",__func__,self.text);
    if (self.text.length == 0) {//当text为空时placeholderView在左边显示placeholder
        
        self.placeholderView.textAlignment = NSTextAlignmentLeft;

        self.placeholderView.text = self.placeholder;
        self.placeholderView.font = self.font;

        self.placeholderView.frame = CGRectMake(5, 5, self.frame.size.width, 20);
        
    }else{//当text不为空时placeholderView在右下角显示字数和总字数
        
        self.placeholderView.textAlignment = NSTextAlignmentRight;
        NSString *wordCount = [NSString stringWithFormat:@"%d",(int)self.text.length];
        self.placeholderView.text = [NSString stringWithFormat:@"%@/%d",wordCount,self.limiteWords];
        
        self.placeholderView.font = self.font;

//        self.placeholderView.frame = CGRectZero;
        self.placeholderView.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height - 20.0, self.frame.size.width / 2, 20.0);

    }

}
-(void)dealloc
{
//    NSLog(@"%s",__func__);

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
@end
