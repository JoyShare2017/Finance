//
//  MyInfoCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _itemLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 60, 30)];
    _itemLb.textColor=BLACKCOLOR;
    _itemLb.font=FONT_BIG;
    [self addSubview:_itemLb];

    _contentTF=[[UITextField alloc]initWithFrame:CGRectMake(70, 7, SCREEN_WIDTH-80, 30)];
    _contentTF.textColor=[UIColor darkGrayColor];
    [self addSubview:_contentTF];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
