//
//  UILabel+XSExtension.m
//  jiaoquaner
//
//  Created by 郝旭珊 on 2017/10/28.
//  Copyright © 2017年 yimofang. All rights reserved.
//

#import "UILabel+XSExtension.h"

@implementation UILabel (XSExtension)

+ (instancetype)labelWithFrame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    return label;
}


+ (instancetype)labelWithFrame:(CGRect)frame
                          text:(NSString *)text
                      textFont:(UIFont *)font
                     textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0;
    return label;
}


/**
 * 首行缩进 Label
 */
+ (instancetype)labelWithFirstIndent:(CGFloat)indent
                               frame:(CGRect)frame
                                text:(NSString *)text
                            textFont:(UIFont *)font
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    label.numberOfLines = 0;
    //段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //首行文本缩进
    paraStyle.firstLineHeadIndent = indent;
    //使用文本段落样式
    NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:text attributes:dict];
    label.attributedText = attr;
    return label;
}

- (void)setFirstLineIndent:(CGFloat)indent{
    //段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //首行文本缩进
    paraStyle.firstLineHeadIndent = indent;
    //使用文本段落样式
    NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:dict];
    self.attributedText = attr;
}



+ (instancetype)labelWithTextFont:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    return label;
}


+(instancetype)labelWithOrigin:(CGPoint)origin
                         text:(NSString *)text
                     textFont:(UIFont *)font
                    textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize labelsize = [text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    label.frame = CGRectMake(origin.x, origin.y, labelsize.width, labelsize.height);
    label.textColor = textColor;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}


+(instancetype)labelWithOrigin:(CGPoint)origin
                          attributedText:(NSMutableAttributedString *)attributedText
                      textFont:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attributedText;
    label.font = font;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(screenW-20,2000); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    //NSStringDrawingTruncatesLastVisibleLine
    CGSize labelsize = [attributedText.mutableString boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    label.frame = CGRectMake(origin.x, origin.y, labelsize.width, labelsize.height);
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}




- (instancetype)setText:(NSString*)text
              textFont:(UIFont *)font
             textColor:(UIColor *)color
{
    self.text = text;
    self.textColor = color;
    self.font = font;
    self.numberOfLines = 0;
    return self;
}


/**
 为UILabel首部设置图片标签
 
 @param text 文本
 @param images 标签数组
 @param span 标签间距
 */
-(void)setText:(NSString *)text
   frontImages:(NSArray<UIImage *> *)images
      headIndent:(CGFloat)headIndent
     imageSpan:(CGFloat)span {
    
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
    
    //段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //首行文本缩进
    paraStyle.firstLineHeadIndent = headIndent;
    //使用文本段落样式
    NSDictionary *dict = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *headIndentAttr = [[NSAttributedString alloc]initWithString:@" " attributes:dict];
    [textAttrStr appendAttributedString:headIndentAttr];
    
    for (UIImage *img in images) {//遍历添加标签
        
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img;
        //计算图片大小，与文字同高，按比例设置宽度
        CGFloat imgH = self.font.pointSize;
        CGFloat imgW = (img.size.width / img.size.height) * imgH;
        //计算文字padding-top ，使图片垂直居中
        CGFloat textPaddingTop = (self.font.lineHeight - self.font.pointSize) / 2;
        attach.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
        
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        [textAttrStr appendAttributedString:imgStr];
        //标签后添加空格
        [textAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    //设置显示文本
    [textAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:text]];
    
    //设置间距
    if (span != 0) {
        [textAttrStr addAttribute:NSKernAttributeName value:@(span)
                            range:NSMakeRange(0, images.count * 2/*由于图片也会占用一个单位长度,所以带上空格数量，需要 *2 */)];
    }
    
    
    self.attributedText = textAttrStr;
}

//
//- (void)labelWithFrontText:(NSString *)fontText


- (void)LabelAlightLeftAndRightWithWidth:(CGFloat)labelWidth {
    CGSize testSize = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.font} context:nil].size;
    
    CGFloat margin = (labelWidth - testSize.width)/(self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1 )];
    self.attributedText = attribute;
}

@end
