//
//  ProjectHeaderCollectionReusableView.m
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "ProjectHeaderCollectionReusableView.h"

@implementation ProjectHeaderCollectionReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.finshedButton];
        [self addSubview:self.headLabel];
        [self addSubview:self.imageV];
    }
    return self;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-52,(self.frame.size.height-15)/2, 15, 15)];
        _imageV.image = [UIImage imageNamed:@"xiangshang"];
    }
    return _imageV;
}
- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
        _headLabel.textColor = [UIColor whiteColor];
        _headLabel.text = @"会计概念";
        _headLabel.frame = CGRectMake(24, 0, 150, self.frame.size.height);
        
        
        
    }
    return _headLabel;
}
- (UIButton *)finshedButton
{
    if (!_finshedButton) {
        _finshedButton = [UIButton new];
        
        _finshedButton.frame = CGRectMake(12, 0, self.frame.size.width-24, self.frame.size.height);
        _finshedButton.backgroundColor = [UIColor colorWithHexString:@"e9890e"];
//        [_finshedButton setTitle:@"完成" forState:UIControlStateNormal];
//        [_finshedButton setTitleColor:[UIColor colorWithHexString:@"1d968f"] forState:UIControlStateNormal];
//        _finshedButton.titleLabel.font=[UIFont systemFontOfSize:14];
        
//        _finshedButton.layer.borderWidth = 0.5;
//        _finshedButton.layer.borderColor = [UIColor colorWithHexString:@"1d968f"].CGColor;
        _finshedButton.layer.cornerRadius = 2;
        _finshedButton.layer.masksToBounds = YES;
    }
    return _finshedButton;
}

@end
