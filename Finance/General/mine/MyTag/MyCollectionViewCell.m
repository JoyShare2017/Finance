//
//  MyCollectionViewCell.m
//  RuoBang1.0
//
//  Created by RuoBang01 on 15-1-21.
//  Copyright (c) 2015年 RuoBang02. All rights reserved.
//

#import "MyCollectionViewCell.h"
@implementation MyCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor lightGrayColor];
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height) ];
        self.label.textAlignment=NSTextAlignmentCenter;//居中
        self.label.numberOfLines=0;
        self.label.clipsToBounds=YES;
//        self.label.layer.cornerRadius=2;
        self.layer.borderWidth=0.8;
        self.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        self.label.backgroundColor=[UIColor whiteColor];
        self.label.textColor=[UIColor darkGrayColor];
        self.layer.cornerRadius=2;
        self.layer.masksToBounds=YES;
//        self.layer.shadowOffset =  CGSizeMake(1, 1);
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowColor =  [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:self.label];
    }
    return self;
}

-(void)setChannelName:(NSString *)channelName{
    _channelName=channelName;
    CGFloat height =[NSString heightWithString:_channelName size:CGSizeMake(SCREEN_WIDTH-30, 100) font:14];
    self.label.frame=CGRectMake(0, 0, self.frame.size.width, height>30?height:30);
    self.label.text=[NSString stringWithFormat:@"%@",_channelName];
   
    
}


@end
