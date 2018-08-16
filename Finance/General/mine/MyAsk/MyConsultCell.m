
//
//  MyConsultCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/30.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyConsultCell.h"

@interface MyConsultCell()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MyConsultCell

- (void)setMyConsultModel:(MyConsultModel *)myConsultModel{
    _myConsultModel=myConsultModel;
    MyConsultModel *model = myConsultModel;
    NSString *headerImageStr = [OPENAPIHOST stringByAppendingString:model.expert_images?model.expert_images:@""];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr]placeholderImage:[UIImage imageNamed:@"header_default_big"]];
//    if (model.user_image){
//        NSString *headerImageStr = [OPENAPIHOST stringByAppendingString:model.mco_unit];
//        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
//    }

    self.nameLabel.text = model.expert_full_name;
    self.contentLabel.text = model.mcm_content;
    self.timeLabel.text = [NSDate dateStringFromInteger:[model.mcm_addtime integerValue] withFormat:@"yyyy-MM-dd HH:mm"];


}

- (void)layoutSubviews
{
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (self.selected) {
//                        img.image=[UIImage imageNamed:@"circle_tick_orange"];
//                    }else
//                    {
//                        img.image=[UIImage imageNamed:@"circle_empty"];
//                    }
//                }
//            }
//        }
//    }
    [super layoutSubviews];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }

    return self;
}


- (void)setupUI{
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView setContentMode:(UIViewContentModeScaleAspectFill)];
    [self.contentView addSubview:self.headerImageView];


    _nameLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:BLACKCOLOR];
    _nameLabel.frame=CGRectMake(60, 10,SCREEN_WIDTH-70-110, 20) ;
    [self.contentView addSubview:self.nameLabel];

    _timeLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    _timeLabel.frame=CGRectMake(SCREEN_WIDTH-120, 10, 110, 20);
    [_timeLabel setTextAlignment:(NSTextAlignmentRight)];
    [self.contentView addSubview:self.timeLabel];

    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _contentLabel.frame=CGRectMake(60, 30,SCREEN_WIDTH-70,20);
    [self.contentView addSubview:self.contentLabel];

}


//
//- (void)autolayoutUI{
//
//
//    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(MARGIN);
//        make.size.mas_equalTo(CGSizeMake(80, 40));
//        make.top.equalTo(self.contentView).offset(MARGIN_BIG);
//    }];
//
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headerImageView.mas_right).offset(MARGIN);
//        make.top.equalTo(self.headerImageView);
//    }];
//
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel);
//        make.right.equalTo(self.contentView).offset(-MARGIN);
//    }];
//
//
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(MARGIN);
//        make.right.equalTo(self.contentView).offset(-MARGIN);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(MARGIN_SMALL);
//    }];
//
//
//    UIView *cutline = [UIView new];
//    cutline.backgroundColor = GRAYCOLOR_BACKGROUND;
//    [self.contentView addSubview:cutline];
//    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.top.equalTo(self.headerImageView.mas_bottom).offset(MARGIN_BIG);
//        make.height.mas_equalTo(MARGIN);
//        make.bottom.equalTo(self.contentView);
//    }];
//}

@end
