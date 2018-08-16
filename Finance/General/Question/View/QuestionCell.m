//
//  QuestionCell.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/25.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "QuestionCell.h"


@interface QuestionCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation QuestionCell


- (void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel=questionModel;
    QuestionModel *model = questionModel;
    self.titleLabel.text = model.question_title;
    self.contentLabel.text = model.question_describe;
    self.nameLabel.text = model.user_nick_name;
    self.modeLabel.text = model.question_mode;
    [self.rightButton setTitle:model.count_read forState:UIControlStateNormal];
    
    CGFloat imageViewH = [self addImages:model.question_images];
    [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imageViewH);
    }];

    if (model.user_image){
        NSString *headerImageStr = [OPENAPIHOST stringByAppendingString:model.user_image];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
    }
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


- (CGFloat)cellHeightWithModel:(QuestionDetailModel *)model{
    //QuestionDetailModel 包含 QuestionModel,属性更多  这个方法根本没有yongda
    self.questionModel = (QuestionModel *)model;
    [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(MARGIN_SMALL);
    }];
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.headerImageView.frame)+MARGIN;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
        [self autolayoutUI];
    }
    
    return self;
}


- (void)setupUI{
    _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"question"]];
    _titleLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _nameLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT_LIGHT];
    _modeLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    _contentImageView = [UIImageView new];
    _headerImageView = [UIImageView new];
    _rightButton = [UIButton buttonWithFont:FONT_SMALL titleColor:GRAYCOLOR_TEXT_LIGHT imageName:@"login_eye"];

    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.modeLabel];
    [self.contentView addSubview:self.rightButton];
   
}



- (void)autolayoutUI{
    
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
    
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(MARGIN_SMALL);
        make.height.mas_equalTo(0);
    }];
    
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
     [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
         make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(MARGIN_SMALL);
    }];
    
    self.headerImageView.layer.cornerRadius = 15;
    self.headerImageView.layer.masksToBounds = YES;
     [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.contentLabel);
         make.size.mas_equalTo(CGSizeMake(30, 30));
         make.top.equalTo(self.contentLabel.mas_bottom).offset(MARGIN_SMALL);
         make.bottom.equalTo(self.contentView).offset(-MARGIN);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(MARGIN);
        make.centerY.equalTo(self.headerImageView);
    }];
    
    [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(MARGIN);
        make.bottom.equalTo(self.nameLabel);
    }];
    
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.width.mas_equalTo(50);
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
-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.questionModel.isEditSelected) {
                        img.image=[UIImage imageNamed:@"circle_tick_orange"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"circle_empty"];
                    }
                }
            }
        }
    }
    
}
@end
