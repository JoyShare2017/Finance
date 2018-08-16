//
//  ExpertAnswerCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ExpertAnswerCell.h"

@interface ExpertAnswerCell()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIView *skilledView;
@property (nonatomic, strong) UIButton *concernButton;
@property (nonatomic, strong) UILabel *concernLabel;
@property (nonatomic, strong) UILabel *answerLabel;

@end


@implementation ExpertAnswerCell


- (void)setExpertModel:(ExpertModel *)expertModel{
    ExpertModel *model = expertModel;
    if (model.expert_images){
        NSString *imageUrl = [OPENAPIHOST stringByAppendingString:model.expert_images];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
    }
    self.nameLabel.text = model.expert_full_name;
    self.jobLabel.text = model.expert_zhiwei;
    self.introduceLabel.text = model.expert_jianjie;
    [self configureSkilledLabel:model.expert_zhuanye];
}

- (void)setUserModel:(UserAccount *)userModel{
    UserAccount *model = userModel;
    if (model.user_image){
        NSString *imageUrl = [OPENAPIHOST stringByAppendingString:model.user_image];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
    }
    self.nameLabel.text = model.user_name;
}


- (void)setAnswerModel:(AnswerModel *)answerModel{
    if (answerModel.yueducishu){
        self.concernLabel.text = [NSString stringWithFormat:@"%@人已看",answerModel.yueducishu];
    }
    self.answerLabel.text = answerModel.answer_content;
//    [self layoutIfNeeded];
//    self.cellHeight = CGRectGetMaxY(self.answerLabel.frame) + MARGIN_BIG;
//    DebugLog(@"self.cellHeight: %f",self.cellHeight);

}


- (CGFloat)cellHeightWithAnswerModel:(AnswerModel *)answerModel
                      expertModel:(ExpertModel *_Nullable)expertModel
                           userModel:(UserAccount *_Nullable)userModel{
    self.answerModel = answerModel;
    if (expertModel){
        self.expertModel = expertModel;
    }
    if (userModel){
        self.userModel = userModel;
    }
    
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.answerLabel.frame) + MARGIN_BIG;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.contentView.backgroundColor = WHITECOLOR;
        [self creatSubviews];
        [self autolayoutUI];
    }
    return self;
}


- (void)creatSubviews{
    _headerImageView = [UIImageView new];
    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _jobLabel = [UILabel labelWithTextFont:FONT15 textColor:GRAYCOLOR_TEXT];
    _introduceLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _concernLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT_LIGHT];
    _skilledView = [UIView new];
    _answerLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:BLACKCOLOR];
    
    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_jobLabel];
    [self.contentView addSubview:_introduceLabel];
    [self.contentView addSubview:_concernLabel];
    [self.contentView addSubview:_skilledView];
    [self.contentView addSubview:_answerLabel];

}


- (void)autolayoutUI{
    
    _headerImageView.layer.cornerRadius = 20;
    _headerImageView.layer.masksToBounds = YES;
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN_BIG);
        make.top.equalTo(self.contentView).offset(MARGIN_MAX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView.mas_right).offset(MARGIN_BIG);
        make.top.equalTo(_headerImageView);
    }];
    
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(MARGIN);
        make.bottom.equalTo(_nameLabel);
    }];
    
    self.introduceLabel.numberOfLines = 1;
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_jobLabel.mas_right).offset(MARGIN);
        make.top.equalTo(_jobLabel);
    }];
    
    [_skilledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-100);
        make.top.equalTo(_nameLabel.mas_bottom).offset(MARGIN);
    }];
    
    [_concernLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(_introduceLabel);
    }];
    
   
    [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(_headerImageView.mas_bottom).offset(MARGIN_BIG);
    }];
    
    UIView *cutline = [UIView new];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN_BIG);
        make.right.equalTo(self.contentView).offset(-MARGIN_BIG);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
        //        make.top.equalTo(self.headerImageView.mas_bottom).offset(MARGIN_BIG);
    }];
    
}


- (void)configureSkilledLabel:(NSString *)skilledString{
    
    NSArray *texts = [skilledString componentsSeparatedByString:@" "];
   
    CGFloat labelX = 0;
    for (int i=0;i<texts.count;i++){
        UILabel *skilledLabel = [UILabel labelWithOrigin:CGPointMake(labelX, 0) text:texts[i] textFont:FONT_SMALL textColor:MAJORCOLOR];
        skilledLabel.width = skilledLabel.width + 10;
        skilledLabel.height = 24;
        skilledLabel.x = skilledLabel.x-5;
        skilledLabel.textAlignment = NSTextAlignmentCenter;
        skilledLabel.layer.borderColor = MAJORCOLOR.CGColor;
        skilledLabel.layer.borderWidth = 1;
        [self.skilledView addSubview:skilledLabel];
        labelX = skilledLabel.maxX+MARGIN;
    }
}

@end
