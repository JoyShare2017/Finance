//
//  ButtonSwitchView.m
//  jiaoquaner
//
//  Created by 郝旭珊 on 2017/12/5.
//  Copyright © 2017年 yimofang. All rights reserved.
//

#import "SwitchButtonView.h"


@interface SwitchButtonView()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *scrollImage;

@end


@implementation SwitchButtonView

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    self.selectedButton.selected = NO;
    for (UIView *subview in self.subviews){
        if ([subview isKindOfClass:[UIButton class]] && subview.tag == selectedIndex){
            [self changSelectedButton:(UIButton *)subview];
        }
    }
}

- (instancetype)initWithTitles:(NSArray *)titles{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SWITCH_BUTTON_VIEW_HEIGHT)]){
        self.backgroundColor = WHITECOLOR;
        
        for(int i=0;i<titles.count;i++){
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.width/titles.count*i,0, self.width/titles.count, self.height)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:MAJORCOLOR_TEXT forState:UIControlStateNormal];
            [btn setTitleColor:WHITECOLOR forState:UIControlStateSelected];
            btn.titleLabel.textColor = GRAYCOLOR_TEXT;
            btn.titleLabel.font = FONT_BIG;
            
            [btn addTarget:self action:@selector(refreshDataList:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel sizeToFit];
            btn.backgroundColor = MAJORCOLOR;
            [self addSubview:btn];
                        
            btn.tag = i;
            if (i==0){
                btn.selected = YES;
                self.selectedButton = btn;
                
                UIImageView *scrollImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arc_triangle"]];
                scrollImage.centerX = btn.centerX;
                scrollImage.maxY = btn.maxY;
                [self addSubview:scrollImage];
                self.scrollImage = scrollImage;

            }
        }
    }
    
    return self;
}


- (void)refreshDataList:(UIButton *)sender{
    self.selectedButton.selected = NO;
    [self changSelectedButton:sender];

    //传递
    if (self.buttonSwitch){
        self.buttonSwitch(sender);
    }
}


- (void)changSelectedButton:(UIButton *)currentButton{
    currentButton.selected = YES;
    self.selectedButton = currentButton;
    self.scrollImage.centerX = currentButton.centerX;
    self.scrollImage.maxY = currentButton.maxY;
    [self bringSubviewToFront:self.scrollImage];
}




@end
