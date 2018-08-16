
//
//  BookCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "BookCell.h"
#import "UIButton+WebCache.h"
#import "BookDetailController.h"
@interface BookCell()

@property (nonatomic, strong) UIButton *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *typeLabel;


@end

@implementation BookCell

- (void)setBookModel:(BookModel *)bookModel{
    _bookModel=bookModel;
    BookModel *model = bookModel;
    NSString *imageStr = [OPENAPIHOST stringByAppendingString:model.book_cover_image];

    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"book_default"]];
    _nameLabel.text = model.book_title;
    if (model.book_author){
        _authorLabel.attributedText = [self labelWithFrontText:@"作者" frontColor:GRAYCOLOR_TEXT behindText:model.book_author behindColor:BLACKCOLOR font:FONT_NORMAL];
    }
    _typeLabel.attributedText = [self labelWithFrontText:@"所属分类" frontColor:GRAYCOLOR_TEXT behindText:model.book_question_tag behindColor:BLACKCOLOR font:FONT_NORMAL];
    _describeLabel.attributedText = [self labelWithFrontText:@"内容简介" frontColor:GRAYCOLOR_TEXT behindText:model.book_describe behindColor:BLACKCOLOR font:FONT_NORMAL];
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _describeLabel.numberOfLines = 2;

//    [self.coverImageView  mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(_coverImageView.frame.size.height);
//    }];
}


- (NSAttributedString *)labelWithFrontText:(NSString *)text1
                frontColor:(UIColor *)color1
                behindText:(NSString *)text2
               behindColor:(UIColor *)color2
                      font:(UIFont *)font{
    if (!text1) {
        text1=@"";
    }if (!text2) {
        text2=@"";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;
    NSDictionary *dict1 = @{NSFontAttributeName:font,
                            NSForegroundColorAttributeName:color1,
                            NSParagraphStyleAttributeName:paragraph,
                            NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]
                            };
    NSString *totalText1 = [text1 stringByAppendingString:@": "];
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:totalText1 attributes:dict1];
    [attr appendAttributedString:attr1];
    
    NSDictionary *dict2 = @{NSFontAttributeName:font,
                            NSForegroundColorAttributeName:color2,
                            };
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:text2 attributes:dict2];
    [attr appendAttributedString:attr2];
    
    return attr;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI{
    _coverImageView = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN, MARGIN_BIG, 80, 140)];
    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _nameLabel.frame=CGRectMake(CGRectGetMaxX(_coverImageView.frame)+MARGIN_BIG, CGRectGetMinY(_coverImageView.frame), SCREEN_WIDTH-CGRectGetMaxX(_coverImageView.frame)-MARGIN_BIG-MARGIN, 30);
//    _authorLabel = [UILabel new];
     _typeLabel = [UILabel new];
     _typeLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), _nameLabel.frame.size.width, 20);
    _describeLabel = [UILabel new];
    _describeLabel.frame=CGRectMake(CGRectGetMinX(_typeLabel.frame), CGRectGetMaxY(_typeLabel.frame), _typeLabel.frame.size.width, 35);
    _button = [UIButton buttonWithTitle:@"查看详情" font:FONT_NORMAL titleColor:MAJORCOLOR];
    _button.layer.borderWidth = 1;
    _button.layer.borderColor = MAJORCOLOR.CGColor;
    _button.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_coverImageView.frame)-35, 80, 30);
    [_button addTarget:self action:@selector(seeDetail) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_authorLabel];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:_describeLabel];
    [self.contentView addSubview:_button];
    UIView *cutline = [[UIView alloc]initWithFrame:CGRectMake(MARGIN, 179, SCREEN_WIDTH-2*MARGIN, 1)];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
}

-(void)seeDetail{

    BookDetailController *vc = [BookDetailController new];
    vc.bookId = self.bookModel.book_id;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                   
                    if (self.bookModel.isEditSelected) {
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
/*
- (void)autolayoutUI{
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.top.equalTo(self.contentView).offset(MARGIN_BIG);
        make.size.mas_equalTo(CGSizeMake(80, 140));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coverImageView.mas_right).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(self.coverImageView);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(8);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_authorLabel);
        make.top.equalTo(_authorLabel.mas_bottom).offset(MARGIN_SMALL);
    }];
    
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_typeLabel);
        make.top.equalTo(_typeLabel.mas_bottom).offset(MARGIN_SMALL);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel);
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.bottom.equalTo(_coverImageView);
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
*/

@end
