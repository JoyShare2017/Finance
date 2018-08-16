//
//  ConsultDetailCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/24.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ConsultDetailCell.h"


@interface ConsultDetailCell()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ConsultDetailCell

- (void)setConsultDetailModel:(ConsultDetailModel *)consultDetailModel{
    ConsultDetailModel *model = consultDetailModel;
    if (model.user_image){
        NSString *headerImageStr = [OPENAPIHOST stringByAppendingString:model.user_image];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
    }

    self.nameLabel.text = model.user_nick_name;
    self.contentLabel.text = model.mcm_content;
    self.timeLabel.text = [NSDate dateStringFromInteger:[model.mcm_addtime integerValue]];

    CGFloat imageViewH = [self addImages:model.mcm_images];
    [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imageViewH);
    }];

}


- (CGFloat)addImages:(NSArray *)imageUrls{
    if (self.contentImageView.subviews > 0){
        for (UIView *subview in self.contentImageView.subviews){
            [subview removeFromSuperview];
        }
    }

    if (imageUrls.count<=0){
        return 0;
    }

    CGFloat imageW = (SCREEN_WIDTH-MARGIN*2-5*2)/3;
    for (int i=0;i<imageUrls.count;i++){
        CGFloat imageX = 5+(imageW+5)*(i%3);
        CGFloat imageY = (imageW+10)*(i/3);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        NSString *str = [OPENAPIHOST stringByAppendingString:imageUrls[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"image_default"]];
        [self.contentImageView addSubview:imageView];

        if (i == imageUrls.count-1){
            return imageView.maxY + MARGIN;
        }
    }

    return 0;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
        [self autolayoutUI];
    }

    return self;
}


- (void)setupUI{
    _headerImageView = [UIImageView new];
    _nameLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:BLACKCOLOR];

    _timeLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _contentImageView = [UIImageView new];

    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];

}



- (void)autolayoutUI{

    self.headerImageView.layer.cornerRadius = 15;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.contentView).offset(MARGIN_BIG);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(MARGIN);
        make.centerY.equalTo(self.headerImageView);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-MARGIN);
    }];


    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(MARGIN_SMALL);
    }];

    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(MARGIN_SMALL);
        make.height.mas_equalTo(0);
    }];

    UIView *cutline = [UIView new];
    cutline.backgroundColor = GRAYCOLOR_BACKGROUND;
    [self.contentView addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(MARGIN);
        make.height.mas_equalTo(MARGIN);
        make.bottom.equalTo(self.contentView);
    }];
}

@end
