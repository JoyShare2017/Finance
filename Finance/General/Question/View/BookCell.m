
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    
    return self;
}
- (void)setupUI{
    _coverImageView = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN, MARGIN_BIG, 80, 140)];
    _coverImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _nameLabel.frame=CGRectMake(CGRectGetMaxX(_coverImageView.frame)+MARGIN_BIG, CGRectGetMinY(_coverImageView.frame), SCREEN_WIDTH-CGRectGetMaxX(_coverImageView.frame)-MARGIN_BIG-MARGIN, 30);
    _typeLabel = [UILabel new];
    _typeLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), _nameLabel.frame.size.width, 20);
    _authorLabel = [[UILabel alloc]initWithFrame:_typeLabel.frame];
    _authorLabel.textColor=MAJORCOLOR;
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
    _priceLabel = [UILabel new];
    
    _priceLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_coverImageView.frame)-30, _nameLabel.frame.size.width, 20);
    _priceLabel.text=@"--";
    _priceLabel.textColor=MAJORCOLOR;
    [self.contentView addSubview:_priceLabel];
    UIView *cutline = [[UIView alloc]initWithFrame:CGRectMake(MARGIN, 179, SCREEN_WIDTH-2*MARGIN, 1)];
    cutline.backgroundColor = GRAYCOLOR_BORDER;
    [self.contentView addSubview:cutline];
    self.isBookDetailPage=NO;
}

- (void)setBookModel:(BookModel *)bookModel{
    _bookModel=bookModel;
    BookModel *model = bookModel;
    NSString *imageStr = [OPENAPIHOST stringByAppendingString:model.book_cover_image];
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"book_default"]];
    _nameLabel.text = model.book_title;
    _authorLabel.text = [NSString stringWithFormat:@"%@/著",model.book_author];
    _typeLabel.attributedText = [self labelWithFrontText:@"所属分类" frontColor:GRAYCOLOR_TEXT behindText:model.book_question_tag behindColor:BLACKCOLOR font:FONT_NORMAL];
    _describeLabel.attributedText = [self labelWithFrontText:@"内容简介" frontColor:GRAYCOLOR_TEXT behindText:model.book_describe behindColor:BLACKCOLOR font:FONT_NORMAL];
    _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _describeLabel.numberOfLines = 2;
    _priceLabel.attributedText=[self labelWithFrontText:@"书籍定价" frontColor:GRAYCOLOR_TEXT behindText:[NSString stringWithFormat:@"¥%@",model.book_price] behindColor:MAJORCOLOR font:FONT_NORMAL];
}

-(void)setIsBookDetailPage:(BOOL)isBookDetailPage{
    _isBookDetailPage=isBookDetailPage;
    if (_isBookDetailPage) {
        _priceLabel.hidden=NO;
        _button.hidden=YES;
        _authorLabel.hidden=NO;
        _describeLabel.hidden=YES;
        _typeLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMinY(_priceLabel.frame)-20, _nameLabel.frame.size.width, 20);
    }else{
        _priceLabel.hidden=YES;
        _button.hidden=NO;
        _authorLabel.hidden=YES;
        _describeLabel.hidden=NO;
        
        _typeLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), _nameLabel.frame.size.width, 20);
    }
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


@end
