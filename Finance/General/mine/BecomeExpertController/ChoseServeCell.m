//
//  ChoseServeCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/1.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ChoseServeCell.h"

@interface ChoseServeCell()

@property (weak, nonatomic) IBOutlet UIButton *serveButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end


@implementation ChoseServeCell


-(void)setTheModel:(ConsultModel *)theModel{
    _theModel=theModel;
    [self.serveButton setTitle:_theModel.es_name forState:UIControlStateNormal];
    if (_theModel.es_name.length<=0) {
       [self.serveButton setTitle:_theModel.mes_name forState:UIControlStateNormal];
    }
    self.openButton.selected=_theModel.add_ok;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    self.openButton.layer.cornerRadius = 5;
    self.openButton.layer.masksToBounds = YES;
    self.openButton.layer.borderColor = MAJORCOLOR.CGColor;
    self.openButton.layer.borderWidth = 1;
    self.openButton.backgroundColor = WHITECOLOR;
    [self.openButton setTitle:@"立即开通" forState:UIControlStateNormal];
    [self.openButton setBackgroundImage:[UIImage imageWithColor:WHITECOLOR size:self.openButton.frame.size] forState:(UIControlStateNormal)];
    [self.openButton setTitle:@"已开通" forState:UIControlStateSelected];
    [self.openButton setBackgroundImage:[UIImage imageWithColor:MAJORCOLOR size:self.openButton.frame.size] forState:(UIControlStateSelected)];
    [self.openButton addTarget:self action:@selector(openOrCloseSever:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)openOrCloseSever:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.theModel.add_ok = sender.selected;
}


@end
