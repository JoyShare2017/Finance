//
//  BottomFuncView.m
//  CarRepairExpert
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 emof. All rights reserved.
//

#import "BottomFuncView.h"

@interface BottomFuncView()
@property (nonatomic, strong)UILabel*priceLb;
@property (nonatomic, strong) UIButton*agreeBtn;
@end


@implementation BottomFuncView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _priceLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*2/3, self.frame.size.height)];
        _priceLb.text=@"9998";
        _priceLb.textColor=MAJORCOLOR;
        _priceLb.font=FONT_NORMAL;
        [_priceLb setTextAlignment:(NSTextAlignmentCenter)];
        [self addSubview:_priceLb];
        
        
        
        _agreeBtn=[UIButton buttonWithTitle:@"提交订单" font:[UIFont systemFontOfSize:16] titleColor:[UIColor whiteColor]];
        _agreeBtn.backgroundColor=MAJORCOLOR;
        _agreeBtn.frame=CGRectMake(self.frame.size.width*2/3, 0, self.frame.size.width/3, self.frame.size.height);
        [_agreeBtn addTarget:self action:@selector(confirm) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:_agreeBtn];
    }
    return self;
}

-(void)confirm{
    if (self.clickAgree) {
        self.clickAgree(@"");
    }
}

-(void)setPrice:(NSString *)price{
    _price=[NSString stringWithFormat:@"%@",price];
    
    if (_priceLb) {
        _priceLb.text=[NSString stringWithFormat:@"合计金额:￥%@",price];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_priceLb.text];
//
//        [text addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(5, text.length-5)];
//        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:[_priceLb.text rangeOfString:_price]];
//
//
//        _priceLb.attributedText = text;
        
    }else{
        NSLog(@"_priceLb is nil");
    }

    
}

-(void)setRealPrice:(NSString *)realPrice{

    _realPrice=[NSString stringWithFormat:@"%@",realPrice];
    
    if (_priceLb) {
        _priceLb.text=[NSString stringWithFormat:@"结算总额:￥%@",_realPrice];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_priceLb.text];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor  redColor] range:NSMakeRange(5, text.length-5)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:[_priceLb.text rangeOfString:_price]];
        
        
        _priceLb.attributedText = text;
        
    }else{
        NSLog(@"_priceLb is nil");
    }
    
    
}

@end
