//
//  MoreAnswerCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/26.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MoreAnswerCell.h"
#import "ExpertModel.h"
#import "UIButton+WebCache.h"
#import "MWPhotoBrowser.h"
#import "UserModel.h"
@interface MoreAnswerCell()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIView *skilledView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *contentImageView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *isExpertIv;

@end

@implementation MoreAnswerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN, MARGIN, 70, 70)];
    _headerImageView.layer.cornerRadius=35;
    _headerImageView.layer.masksToBounds=YES;

    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];


    _jobLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];

    _skilledView = [UIView new];

    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_jobLabel];
    [self.contentView addSubview:_skilledView];

    //是否是专家回答
    UIImage *image = [UIImage imageNamed:@"expert_answer"];
    UIImageView *isExpertIv = [[UIImageView alloc]initWithImage:image];
    isExpertIv.frame = CGRectMake(SCREEN_WIDTH-image.size.width, 0, image.size.width, image.size.height);
    [self.contentView addSubview:isExpertIv];
    self.isExpertIv=isExpertIv;

    //长文本 图片
    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _contentImageView = [UIView new];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.contentImageView];

    //分割线
    self.line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.line.backgroundColor=GRAYCOLOR_BORDER;
    [self.contentView addSubview:self.line];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(_headerImageView.mas_right).offset(MARGIN);
        make.top.equalTo(_headerImageView).offset(10);
    }];
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(MARGIN);
        make.bottom.equalTo(_nameLabel);
    }];
    [_skilledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView.mas_right).offset(MARGIN+10);
        make.bottom.equalTo(_headerImageView.mas_bottom).offset(-30);
    }];

}

-(void)layoutSubviews{
    self.isExpertIv.hidden=![self.answerModel.answer_is_expert boolValue];
    if ([self.answerModel.answer_is_expert isEqualToString:@"1"]) {

        ExpertModel*expert=[ExpertModel mj_objectWithKeyValues:_answerModel.answer_user_data];
        NSString *imageUrl = [OPENAPIHOST stringByAppendingString:expert.expert_images];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"header_default_big"]];
        self.nameLabel.text = expert.expert_full_name;
        self.jobLabel.text =expert.expert_zhiwei;
        [self configureSkilledLabel:expert.expert_zhuanye];
    }else{
        UserModel *userModel = [UserModel mj_objectWithKeyValues:_answerModel.answer_user_data];
        NSString *imageUrl = [OPENAPIHOST stringByAppendingString:userModel.user_image?userModel.user_image:@""];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"header_default_big"]];
        self.nameLabel.text = userModel.user_name?userModel.user_name:@"";
    }

    //问题的描述
    CGFloat contentHeight=[NSString heightWithString:_answerModel.answer_content size:CGSizeMake(SCREEN_WIDTH-2*MARGIN, 500) font:14];
    self.contentLabel.frame=CGRectMake(MARGIN, CGRectGetMaxY(self.headerImageView.frame)+5, SCREEN_WIDTH-2*MARGIN, contentHeight);
    self.contentLabel.text=_answerModel.answer_content;

    [self addImages:_answerModel.answer_images];
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
- (void)addImages:(NSArray *)imageUrls{
    if (self.contentImageView.subviews > 0){
        for (UIView *subview in self.contentImageView.subviews){
            [subview removeFromSuperview];
        }
    }

    CGFloat imageW = (SCREEN_WIDTH-MARGIN*2-5*2)/3;
    CGFloat imageMaxY=0;


    if(self.photos == nil)
    {
        self.photos = [NSMutableArray array];
    }
    [self.photos removeAllObjects];

    for (int i=0;i<imageUrls.count;i++){
        CGFloat imageX = 5+(imageW+5)*(i%3);
        CGFloat imageY = (imageW+5)*(i/3);
        UBButton *imageView = [[UBButton alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        imageView.tag=1000+i;
        imageView.clipsToBounds=YES;
        [imageView setContentMode:(UIViewContentModeScaleAspectFill)];
        NSString *str = [OPENAPIHOST stringByAppendingString:imageUrls[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"image_default"]];
        [self.contentImageView addSubview:imageView];



        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [self.photos addObject:photo];
        [imageView addAction:^(UBButton *button) {
            BOOL displayActionButton = NO;
            BOOL displaySelectionButtons = NO;
            BOOL displayNavArrows = YES;
            BOOL enableGrid = YES;
            BOOL startOnGrid = NO;
            BOOL autoPlayOnAppear = NO;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = enableGrid;
            browser.startOnGrid = startOnGrid;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = autoPlayOnAppear;
            [browser setCurrentPhotoIndex:button.tag-1000];
            [self.superVC.navigationController pushViewController:browser animated:NO];
        }];

        imageMaxY = CGRectGetMaxY(imageView.frame);

    }
    self.contentImageView.frame=CGRectMake(MARGIN, CGRectGetMaxY(_contentLabel.frame)+ (imageMaxY>0?MARGIN:0), SCREEN_WIDTH-2*MARGIN, imageMaxY);
    self.line.frame=CGRectMake(0, CGRectGetMaxY(self.contentImageView.frame)+4, SCREEN_WIDTH, 1);

}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count){

        return [self.photos objectAtIndex:index];
    }
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
