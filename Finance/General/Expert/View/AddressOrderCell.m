//
//  AddressOrderCell.m
//  Finance
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "AddressOrderCell.h"
@interface AddressOrderCell()
@property(nonatomic,strong)UILabel*nameLb,*phoneLb,*addressLb;
@property(nonatomic,strong)UBButton*defaultAddressBtn,*editBtn,*deleteBtn;

@end
@implementation AddressOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    for (int i=0; i<2; i++) {
        UILabel*label =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 30)];
        label.font=[UIFont systemFontOfSize:14];
        if (i==0) {_nameLb=label; }
        if (i==1) {_phoneLb=label;
            [_phoneLb setTextAlignment:(NSTextAlignmentRight)];
        }
        [self addSubview:label];
    }
    
    UILabel*label =[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 70, 20)];
    label.font=[UIFont systemFontOfSize:14];
    label.text=@"收货地址";
    label.backgroundColor=MAJORCOLOR;
    label.textColor=[UIColor whiteColor];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:label];
    
    _addressLb =[[UILabel alloc]initWithFrame:CGRectMake(20, 50, SCREEN_HEIGHT-40, 40)];
    _addressLb.font=[UIFont systemFontOfSize:14];
    _addressLb.numberOfLines=0;
    [self addSubview:_addressLb];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLb.text=[NSString stringWithFormat:@"收货人:%@",self.address.us_name];
    self.phoneLb.text=[NSString stringWithFormat:@"%@",self.address.us_phone];
    
    CGFloat height =[NSString heightWithString:self.address.us_address size:CGSizeMake(SCREEN_WIDTH-40, 60) font:14];
    self.addressLb.frame=CGRectMake(20, 55, SCREEN_WIDTH-40, height);
    self.addressLb.text=[NSString stringWithFormat:@"%@",self.address.us_address];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
