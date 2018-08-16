//
//  EmptyReceiptCell.m
//  Finance
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "EmptyReceiptCell.h"

@implementation EmptyReceiptCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    UIButton *answerButton = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH*0.5-40, 20, 80, 30) title:@"+收货地址" font:FONT_NORMAL titleColor:MAJORCOLOR backgroundColor:[UIColor clearColor] target:self actionName:@"add"];
    answerButton.layer.borderWidth=0.5;
    answerButton.layer.borderColor=MAJORCOLOR.CGColor;
    [self addSubview:answerButton];
}
-(void)add{
    if (self.clickAddBtn) {
        self.clickAddBtn(@"");
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
