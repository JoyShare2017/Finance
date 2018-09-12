//
//  ProjectCollectionViewCell.m
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ProjectCollectionViewCell.h"

@implementation ProjectCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
//        self.layer.cornerRadius = 2;
//        self.layer.masksToBounds = YES;
        
        _nameLabel=[UBLabel makeLabelWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) andText:@"--" andTitleColor:[UIColor darkGrayColor] andFont:12];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}



@end
