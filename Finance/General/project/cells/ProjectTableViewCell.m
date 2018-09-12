//
//  ProjectTableViewCell.m
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _poloView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 5, 40)];
    _poloView.backgroundColor=MAJORCOLOR;
    [self addSubview:_poloView];
    
    _nameLabel=[UBLabel makeLabelWithFrame:CGRectMake(15, 5, 70, 40) andText:@"--" andTitleColor:MAJORCOLOR andFont:12];
    _nameLabel.numberOfLines=0;
    [self addSubview:_nameLabel];
}

-(void)setTitle:(NSString *)title{
    _title=title;
    CGFloat height = [NSString heightWithString:_title size:CGSizeMake(70, 100) font:12];
    _poloView.frame=CGRectMake(0, 5, 5, height);
    _nameLabel.frame=CGRectMake(15, 5, 70, height);
    _nameLabel.text=title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
