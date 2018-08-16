//
//  MyAttentionCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyAttentionCell.h"
@interface MyAttentionCell()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIView *skilledView;


@end
@implementation MyAttentionCell

- (void)setExpertModel:(ExpertModel *)expertModel{
    _expertModel=expertModel;
    ExpertModel *model = expertModel;
    NSString *imageUrl = [OPENAPIHOST stringByAppendingString:model.expert_images];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"header_default_big"]];
    self.nameLabel.text = model.expert_full_name;
    self.jobLabel.text = model.expert_zhiwei;
    self.introduceLabel.text = model.expert_jianjie;
    [self configureSkilledLabel:model.expert_zhuanye];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatSubviews];
        [self autolayoutUI];
    }
    return self;
}


- (void)creatSubviews{
    _headerImageView = [UIImageView new];
    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _jobLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _introduceLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_MEDIAN];
    _skilledView = [UIView new];

    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_jobLabel];
    [self.contentView addSubview:_introduceLabel];
    [self.contentView addSubview:_skilledView];

}





- (void)autolayoutUI{

    _headerImageView.layer.cornerRadius = 35;
    _headerImageView.layer.masksToBounds = YES;
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN_BIG);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView.mas_right).offset(MARGIN);
        make.top.equalTo(_headerImageView);
    }];

    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(MARGIN);
        make.bottom.equalTo(_nameLabel);
    }];

    self.introduceLabel.numberOfLines = 1;
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-100);
        make.top.equalTo(_jobLabel.mas_bottom).offset(MARGIN);
    }];

    [_skilledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introduceLabel).offset(8);
        make.right.equalTo(self.contentView).offset(-100);
        make.top.equalTo(_introduceLabel.mas_bottom).offset(MARGIN);
        make.bottom.equalTo(self.imageView);
    }];



}


- (void)configureSkilledLabel:(NSString *)skilledString{
    if (self.skilledView.subviews.count > 0){
        [self.skilledView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview removeFromSuperview];
        }];
    }

    NSArray *texts = [skilledString componentsSeparatedByString:@" "];
    CGFloat labelX = 0;
    for (int i=0;i<texts.count;i++){
        UILabel *skilledLabel = [UILabel labelWithOrigin:CGPointMake(labelX, 0) text:texts[i] textFont:FONT_TINY textColor:MAJORCOLOR];
        skilledLabel.width = skilledLabel.width + 10;
        skilledLabel.height = 18;
        skilledLabel.x = skilledLabel.x-5;
        skilledLabel.textAlignment = NSTextAlignmentCenter;
        skilledLabel.layer.borderColor = MAJORCOLOR.CGColor;
        skilledLabel.layer.borderWidth = 0.5;
        skilledLabel.layer.cornerRadius = 3;
        skilledLabel.layer.masksToBounds = YES;
        [self.skilledView addSubview:skilledLabel];
        labelX = skilledLabel.maxX+MARGIN;
    }
}
- (void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.expertModel.isEditSelected) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
