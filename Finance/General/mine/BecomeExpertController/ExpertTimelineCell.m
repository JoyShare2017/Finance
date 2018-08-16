//
//  ExpertTimelineCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/18.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ExpertTimelineCell.h"
#import "DrawLineView.h"
@interface ExpertTimelineCell()
@property (nonatomic, strong) UILabel *nameLabel,*descriptionLabel,*concernLabel,*timeLabel;
@property (nonatomic, strong) DrawLineView *lineView2;


@end
@implementation ExpertTimelineCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _nameLabel = [UILabel labelWithFrame:CGRectMake(40, MARGIN_BIG, SCREEN_WIDTH-40-10, 20) text:@"标题标题" textFont:FONT_NORMAL textColor:BLACKCOLOR];
    [self addSubview:_nameLabel];
    _timeLabel = [UILabel labelWithFrame:_nameLabel.frame text:@"2018-04-18 15:40:01" textFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];

    _descriptionLabel = [UILabel labelWithFrame:CGRectMake(40, _nameLabel.maxY+MARGIN, SCREEN_WIDTH-50, 20) text:@"" textFont:FONT_SMALL textColor:GRAYCOLOR_TEXT];
    [self addSubview:_descriptionLabel];
    _concernLabel = [UILabel labelWithFrame:CGRectMake(40, _descriptionLabel.maxY+MARGIN, SCREEN_WIDTH-50, 20) text:@"" textFont:FONT_SMALL textColor:GRAYCOLOR_TEXT];
    [self addSubview:_concernLabel];
    self.editBtn=[[UBButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, CGRectGetMinY(_descriptionLabel.frame), 70, 30)];
    [self.editBtn setTitleColor:MAJORCOLOR forState:(UIControlStateNormal)];
    self.editBtn.titleLabel.font=FONT_SMALL;
    [self addSubview:self.editBtn];
    



    DrawLineView *lineView2 = [[DrawLineView alloc]initWithFrame:CGRectMake(10, 0, 10, 130)];
    lineView2.isStroke = NO;
    lineView2.backgroundColor = WHITECOLOR;
    [self addSubview:lineView2];
    self.lineView2=lineView2;

//    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, 129, SCREEN_WIDTH, 1)];
//    line.backgroundColor=GRAYCOLOR_BORDER;
//    [self addSubview:line];

}
-(void)layoutSubviews{
    self.nameLabel.text=self.modeltimeline.title;
    self.timeLabel.text=[NSDate dateStringFromInteger:[self.modeltimeline.time integerValue] withFormat:@"yyyy-MM-dd HH:mm"];

    //描述 label 适应
    CGFloat desHeight=[NSString heightWithString:self.modeltimeline.content size:CGSizeMake(SCREEN_WIDTH-50, 60) font:self.concernLabel.font.pointSize];
    self.descriptionLabel.frame=CGRectMake(40, _nameLabel.maxY+MARGIN, SCREEN_WIDTH-50, desHeight>20?desHeight:20);
    self.descriptionLabel.text=self.modeltimeline.content;


    //提示 label 适应
    CGFloat concernHeight=[NSString heightWithString:self.modeltimeline.content_care size:CGSizeMake(SCREEN_WIDTH-50, 60) font:self.concernLabel.font.pointSize];
    self.concernLabel.frame=CGRectMake(40, _descriptionLabel.maxY+MARGIN, SCREEN_WIDTH-50, concernHeight>20?concernHeight:20);
    self.concernLabel.text=self.modeltimeline.content_care;

    self.editBtn.frame=CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(_descriptionLabel.frame)-10, 70, 30);


    self.lineView2.isStroke=[self.modeltimeline.expert_progress isEqualToString:@"0"];
    self.lineView2.darwIndex=self.modeltimeline.index;

    if ([self.modeltimeline.expert_progress isEqualToString:@"1"]) {//等待审核
        self.editBtn.hidden=NO;
        [self.editBtn setTitle:@"去补充>" forState:(UIControlStateNormal)];
    }else if ([self.modeltimeline.expert_progress isEqualToString:@"2"]) {//拒绝
        self.editBtn.hidden=NO;
        [self.editBtn setTitle:@"去修改>" forState:(UIControlStateNormal)];
   }else{
       self.editBtn.hidden=YES;
   }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
