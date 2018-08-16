//
//  AnswerCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "AnswerCell.h"

@interface AnswerCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AnswerCell

- (void)setAnswerModel:(AnswerModel *)answerModel{
    AnswerModel *model = answerModel;
    self.titleLabel.text = model.question_title;
    self.contentLabel.text = model.answer_content;
}

- (CGFloat)cellHeightWithModel:(AnswerModel *)answerModel{
    self.answerModel = answerModel;
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.contentLabel.frame)+MARGIN;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI{
    _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"question"]];
    _titleLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.top.equalTo(self.contentView).offset(MARGIN_BIG);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(MARGIN_SMALL);
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView).offset(-MARGIN);
    }];
    
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(MARGIN);
    }];
    
    
    UIView *cutline = [UIView new];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

@end
