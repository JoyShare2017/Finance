//
//  ChannelButton.m
//  D1CM
//
//  Created by 赵帅 on 2017/10/16.
//  Copyright © 2017年 lsj. All rights reserved.
//

#import "ChannelButton.h"

@implementation ChannelButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=MAJORCOLOR;
        self.closeBtn=[[UBButton alloc]initWithFrame:CGRectMake(frame.size.width-15, 0, 15, 15)];
        [self.closeBtn setImage:[UIImage imageNamed:@"delete_x"] forState:(UIControlStateNormal)];
        self.closeBtn.layer.cornerRadius = self.closeBtn.frame.size.height/2;
        self.closeBtn.layer.masksToBounds = YES;
        self.closeBtn.userInteractionEnabled=NO;
        [self addSubview:self.closeBtn];
        
    }
    return self;
}

-(void)setCanEdit:(BOOL)canEdit{
    _canEdit=canEdit;
//    if (_canEdit) {
//        self.backgroundColor=IWColor(226, 226, 226);
//        [self setTitleColor:IWColor(91, 91, 91) forState:(UIControlStateNormal)];
//    }else{
//        self.backgroundColor=IWColor(238, 238, 238);
//        [self setTitleColor:IWColor(119, 119, 119) forState:(UIControlStateNormal)];
//
//    }

}

-(void)setIsNeedShowCloseBtn:(BOOL)isNeedShowCloseBtn{
    _isNeedShowCloseBtn=isNeedShowCloseBtn;
    if (_isNeedShowCloseBtn) {
        self.closeBtn.hidden=NO;
    }else
        self.closeBtn.hidden=YES;
    
}

@end
