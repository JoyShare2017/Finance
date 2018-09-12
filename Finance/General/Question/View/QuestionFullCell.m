//
//  QuestionFullCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/23.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "QuestionFullCell.h"
#import "UIButton+WebCache.h"
#import "MWPhotoBrowser.h"
@interface QuestionFullCell()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *contentImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray *photos;

@end
@implementation QuestionFullCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"question"]];
    _iconImageView.frame=CGRectMake(MARGIN, 7.5, 15, 15) ;
    _titleLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _titleLabel.frame=CGRectMake(CGRectGetMaxX(_iconImageView.frame)+MARGIN, 0, SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-2*MARGIN, 30) ;
    _contentLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT];
    _nameLabel = [UILabel labelWithTextFont:FONT_NORMAL textColor:GRAYCOLOR_TEXT_LIGHT];
//    _modeLabel = [UILabel labelWithTextFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    _contentImageView = [UIView new];
    _headerImageView = [UIImageView new];
    self.headerImageView.layer.cornerRadius = 15;
    self.headerImageView.layer.masksToBounds = YES;
    _rightButton = [UIButton buttonWithFont:FONT_SMALL titleColor:GRAYCOLOR_TEXT_LIGHT imageName:@"login_eye"];

    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
//    [self.contentView addSubview:self.modeLabel];
    [self.contentView addSubview:self.rightButton];
}

-(CGFloat)setQuestionDataWithModel:(QuestionDetailModel*)questionModel{
    QuestionDetailModel *model = questionModel;
    self.titleLabel.text = model.question_title;
   [self addImages:model.question_images];


    //问题的描述
    CGFloat contentHeight=[NSString heightWithString:model.question_describe size:CGSizeMake(SCREEN_WIDTH-2*MARGIN, 500) font:14];
    self.contentLabel.frame=CGRectMake(MARGIN, CGRectGetMaxY(self.contentImageView.frame)+MARGIN, SCREEN_WIDTH-2*MARGIN, contentHeight);
    self.contentLabel.text=model.question_describe;
    self.contentLabel.numberOfLines=0;
    //提问者头像 昵称 浏览量
    self.headerImageView.frame=CGRectMake(MARGIN, CGRectGetMaxY(self.contentLabel.frame)+MARGIN, 30, 30);
    NSString *headerImageStr = [OPENAPIHOST stringByAppendingString:model.user_image];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageStr]placeholderImage:[UIImage imageNamed:@"header_default_small"]];
    //提问者昵称
    self.nameLabel.text = model.user_nick_name;
    self.nameLabel.frame=CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+MARGIN, CGRectGetMaxY(self.contentLabel.frame)+MARGIN, SCREEN_WIDTH*0.5, 30) ;

//    self.modeLabel.text = model.question_mode;
    //浏览量
    self.rightButton.frame=CGRectMake(SCREEN_WIDTH-50-MARGIN, CGRectGetMaxY(self.contentLabel.frame)+MARGIN, 50, 30) ;
    [self.rightButton setTitle:model.count_read forState:UIControlStateNormal];



    return CGRectGetMaxY(self.headerImageView.frame)+MARGIN;

}

- (void)addImages:(NSArray *)imageUrls{
    if (self.contentImageView.subviews > 0){
        for (UIView *subview in self.contentImageView.subviews){
            [subview removeFromSuperview];
        }
    }

    CGFloat imageW = (SCREEN_WIDTH-MARGIN*2-5*2)/3;
    CGFloat imageMaxY=0;


//    for (int i = 0; i < _info.imglist.count; i++) {
//        D_ImgUrl *url = [_info.imglist objectAtIndex:i];
//        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url.img_url]];
//        [self.photos addObject:photo];
//    }
//    [browser setCurrentPhotoIndex:index];
//    [self.navigationController pushViewController:browser animated:NO];

    if(self.photos == nil)
    {
        self.photos = [NSMutableArray array];
    }
    [self.photos removeAllObjects];

    for (int i=0;i<imageUrls.count;i++){
        CGFloat imageX = 5+(imageW+5)*(i%3);
        CGFloat imageY = (imageW+10)*(i/3);
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
    self.contentImageView.frame=CGRectMake(MARGIN, 30, SCREEN_WIDTH-2*MARGIN, imageMaxY);

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
