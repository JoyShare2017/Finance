//
//  NoDataCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/19.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _noAnswerButton = [UIButton buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70) title:@"暂无专家解答" font: FONT_NORMAL titleColor:GRAYCOLOR_TEXT_LIGHT imageName:@"no_info" target:self actionName:nil];
        _noAnswerButton.backgroundColor = [UIColor redColor];
        _noAnswerButton.userInteractionEnabled = NO;
        [self addSubview:_noAnswerButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
