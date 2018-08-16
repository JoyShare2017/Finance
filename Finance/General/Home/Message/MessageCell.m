//
//  MessageCell.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/28.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end


@implementation MessageCell

- (void)setMessageModel:(MessageModel *)messageModel{
    MessageModel *model = messageModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ 回复了问题",model.answer_user_nick_name];
    self.contentLabel.text = model.mn_user_content;
    self.timeLabel.text = [NSDate dateStringFromInteger:[model.mn_addtime integerValue]];
}


-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"circle_tick_orange"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"circle_empty"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatSubviews];
        [self autolayoutSubviews];
    }
    return self;
}


- (void)creatSubviews{
    _containerView = [UIView new];
    _titleLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:BLACKCOLOR];
    _contentLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT];
    _timeLabel = [UILabel labelWithTextFont:FONT_TINY textColor:GRAYCOLOR_TEXT_LIGHT];
    
    [self.contentView addSubview:_containerView];
    [self.containerView addSubview:_titleLabel];
    [self.containerView addSubview:_contentLabel];
    [self.containerView addSubview:_timeLabel];
}




- (void)autolayoutSubviews{
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(MARGIN);
        make.right.equalTo(self.containerView).offset(-MARGIN);
        make.top.equalTo(self.containerView).offset(MARGIN_BIG);
    }];
    
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(MARGIN);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).offset(-MARGIN);
        make.bottom.equalTo(_titleLabel);
    }];
    
    UIView *cutline = [UIView new];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(MARGIN);
        make.right.equalTo(self.containerView).offset(-MARGIN);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.containerView);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentLabel.numberOfLines = 2;
}

@end
