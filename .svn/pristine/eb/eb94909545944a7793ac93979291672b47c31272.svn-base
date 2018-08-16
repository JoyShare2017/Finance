//
//  ExpertCell.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ExpertCell.h"

@interface ExpertCell()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UILabel *introduceLabel;

@property (nonatomic, strong) UIButton *concernButton;
@property (nonatomic, strong) UILabel *concernLabel;

@end

@implementation ExpertCell


- (void)setExpertModel:(ExpertModel *)expertModel{
    _expertModel=expertModel;
    ExpertModel *model = expertModel;
    NSString *imageUrl = [OPENAPIHOST stringByAppendingString:model.expert_images];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"header_default_big"]];
    self.nameLabel.text = model.expert_full_name;
    self.jobLabel.text = model.expert_zhiwei;
    self.introduceLabel.text = model.expert_jianjie;
    self.concernLabel.text = [NSString stringWithFormat:@"%@人关注",model.follow_count];
    self.concernButton.selected = model.follow_ok;
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
    _concernLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT_LIGHT];
    _skilledView = [UIView new];
    _concernButton = [UIButton new];
    [_concernButton setBackgroundImage:[UIImage imageNamed:@"concern"] forState:UIControlStateNormal];
    [_concernButton setBackgroundImage:[UIImage imageNamed:@"concern_selected"] forState:UIControlStateSelected];
    [_concernButton addTarget:self action:@selector(concernAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_jobLabel];
    [self.contentView addSubview:_introduceLabel];
    [self.contentView addSubview:_concernButton];
    [self.contentView addSubview:_concernLabel];
    [self.contentView addSubview:_skilledView];
    
}


- (void)concernAction:(UIButton *)sender{

    if ([self.superVC judegLoginWithSuperVc:self.superVC]==NO) {
        return;
    }


    if (self.concernButton.selected==YES) {
        //取关
        [self.superVC showHudInView:self.superVC.view];
        [KCommonNetRequest deleteMemberFollowWithExpertID:self.expertModel.expert_user_id andComplete:^(BOOL success, id obj) {
            [self.superVC hideHud];
            if (success) {
                self.concernButton.selected=NO;
                [self.superVC showHint:@"取关成功"];
            }else{
                [self.superVC showHint:(NSString*)obj];
            }
        }];

    }else{
        //关注
        [self.superVC showHudInView:self.superVC.view];
        [KCommonNetRequest addMemberFollowWithExpertID:self.expertModel.expert_user_id andComplete:^(BOOL success, id obj) {
            [self.superVC hideHud];
            if (success) {
                self.concernButton.selected=YES;
                [self.superVC showHint:@"关注成功"];
            }else{
                [self.superVC showHint:(NSString*)obj];
            }
        }];
    }

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
    
    [_concernButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-MARGIN_BIG);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    
    [_concernLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_concernButton);
        make.top.equalTo(_concernButton.mas_bottom).offset(MARGIN);
    }];
    
}







- (void)configureSkilledLabel:(NSString *)skilledString{
    if (self.skilledView.subviews.count > 0){
        [self.skilledView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview removeFromSuperview];
        }];
    }
    
    NSArray *texts = [skilledString componentsSeparatedByString:@" "];
//    NSArray *texts = @[@"税务分析",@"IPO前政务管理"];
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


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
