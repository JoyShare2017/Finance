//
//  BookOrderCell.m
//  Finance
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "BookOrderCell.h"
#import "UIButton+WebCache.h"

@interface BookOrderCell()

@property (nonatomic, strong) UIButton *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;



@end
@implementation BookOrderCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI{
    UIView*v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MARGIN)];
    v.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:238.0/255.0 blue:244.0/255.0 alpha:1];
    [self addSubview:v];
    
    _coverImageView = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN, 2*MARGIN, 60, 90)];
    _nameLabel = [UILabel labelWithTextFont:FONT_BIG textColor:BLACKCOLOR];
    _nameLabel.frame=CGRectMake(CGRectGetMaxX(_coverImageView.frame)+MARGIN, CGRectGetMinY(_coverImageView.frame), SCREEN_WIDTH-CGRectGetMaxX(_coverImageView.frame)-MARGIN_BIG-MARGIN, 50);
    _nameLabel.numberOfLines=2;
    _priceLabel = [UILabel new];
    _priceLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_coverImageView.frame)-30, _nameLabel.frame.size.width, 20);
    _priceLabel.text=@"--";
    _priceLabel.textColor=MAJORCOLOR;
    _countLabel = [UILabel new];
    _countLabel.frame=CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_coverImageView.frame)-30, _nameLabel.frame.size.width, 20);
    [_countLabel setTextAlignment:(NSTextAlignmentRight)];
    self.count=1;

    
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_countLabel];
    [self.contentView addSubview:_priceLabel];
   
}
- (void)setBookModel:(BookModel *)bookModel{
    _bookModel=bookModel;
    BookModel *model = bookModel;
    NSString *imageStr = [OPENAPIHOST stringByAppendingString:model.book_cover_image];
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"book_default"]];
    _nameLabel.text = model.book_title;
    _priceLabel.text=[NSString stringWithFormat:@"¥%@",model.book_price];

}
-(void)setCount:(NSInteger)count{
    _count=count;
    _countLabel.text=[NSString stringWithFormat:@"x%zd",count];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_countLabel.text];
    
//    [text addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(5, text.length-5)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:[_countLabel.text rangeOfString:@"x"]];
    
    _countLabel.attributedText = text;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
