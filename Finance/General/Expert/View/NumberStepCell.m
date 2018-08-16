//
//  NumberStepCell.m
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/18.
//  Copyright © 2017年 赵帅. All rights reserved.
// *subTextLabel;


#import "NumberStepCell.h"
#define kTITELFONT 15
#define SCREENSIZE [UIScreen mainScreen].bounds.size


@interface NumberStepCell()


@end


@implementation NumberStepCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {//添加展示控件
        
        self.accessoryView = nil;
        self.frame = CGRectMake(0, 0, SCREENSIZE.width, 50);
        
        _starLable = [[UILabel alloc]init];
        _starLable.text = @"";
        _starLable.textColor = [UIColor redColor];
        _starLable.font = [UIFont systemFontOfSize:kTITELFONT];
        [self.contentView addSubview:_starLable];
        
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = [UIFont systemFontOfSize:kTITELFONT];
        [self.contentView addSubview:_titleLable];
        
        _starLable.frame = CGRectMake(15, 0, 10, self.frame.size.height);
        _titleLable.frame = CGRectMake(15, 0, (SCREENSIZE.width-40)/2, self.bounds.size.height);
        
        
        
        UIView*backV=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-120, 7, 100, 30)];
        [self addSubview:backV];
        
        
        
        //-
        UIButton*minus =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [minus setTitle:@"-" forState:(UIControlStateNormal)];
        [minus setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        minus.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [minus setBackgroundColor:GRAYCOLOR_BACKGROUND];
        [backV addSubview:minus];
        
        [minus addTarget:self action:@selector(minusClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        //中间数字
        
        _subTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(minus.frame), CGRectGetMinY(minus.frame), backV.frame.size.width-minus.frame.size.width*2, minus.frame.size.height)];
        [_subTextLabel setTextAlignment:(NSTextAlignmentCenter)];
        [backV addSubview:_subTextLabel];
        
        
        //+
        UIButton*plus =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_subTextLabel.frame), CGRectGetMinY(minus.frame),30,30)];
        [plus setTitle:@"+" forState:(UIControlStateNormal)];
        [plus setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        plus.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [plus setBackgroundColor:GRAYCOLOR_BACKGROUND];

        [backV addSubview:plus];
        [plus addTarget:self action:@selector(plusClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return self;
    
}


-(void)plusClick{
    
    if (self.stepCount>=1) {
        
        self.currentNum+=_stepCount;
        
    }else{
        
        self.currentNum+=1;
        
    }
    
    if (self.upLimit>0) {
        
        if (self.currentNum>=self.upLimit) {
            self.currentNum=self.upLimit;
        }
        
    }
    
    _subTextLabel.text=[NSString stringWithFormat:@"%zd",self.currentNum];
    if (self.countChanged) {
        self.countChanged(self.currentNum);
    }
}

-(void)minusClick{
    
    if (self.stepCount>=1) {
        
        self.currentNum-=_stepCount;
        
    }else{
        
        self.currentNum-=1;
        
    }
    
    if (self.downLimit>=0) {
        
        if (self.currentNum<=self.downLimit) {
            self.currentNum=self.downLimit;
        }
        
    }
    if (self.countChanged) {
        self.countChanged(self.currentNum);
    }
    _subTextLabel.text=[NSString stringWithFormat:@"%zd",self.currentNum];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.currentNum<=0) {
        self.currentNum=1;
    }
    _subTextLabel.text=[NSString stringWithFormat:@"%zd",self.currentNum];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
