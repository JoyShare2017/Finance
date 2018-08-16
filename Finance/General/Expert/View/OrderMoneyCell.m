//
//  OrderMoneyCell.m
//  Finance
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "OrderMoneyCell.h"

@implementation OrderMoneyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:15];
     _titleLable.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, self.bounds.size.height);
    _titleLable.text=@"共一件商品,价格9998";
    [_titleLable setTextAlignment:(NSTextAlignmentRight)];
    [self.contentView addSubview:_titleLable];
}
-(void)updateCount:(NSInteger)count andMoney:(NSString*)money{
    NSString*mon=[NSString stringWithFormat:@"%.2lf",[money floatValue]*count];
    self.titleLable.text=[NSString stringWithFormat:@"共%zd件商品 小计:¥%@",count,mon];
    NSString*str =[self.titleLable.text componentsSeparatedByString:@":"].lastObject;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.titleLable.text];
    
    NSRange ran =[self.titleLable.text rangeOfString:str];
    [text addAttribute:NSForegroundColorAttributeName value:MAJORCOLOR range:ran];
    self.titleLable.attributedText = text;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
