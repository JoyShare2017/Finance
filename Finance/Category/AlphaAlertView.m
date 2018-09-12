//
//  AlphaAlertView.m
//  JingXinTong
//
//  Created by 赵帅 on 2018/6/7.
//  Copyright © 2018年 赵帅. All rights reserved.
//

#import "AlphaAlertView.h"
#import "UBButton+FastBuild.h"
#import "UBLabel+FastBuild.h"
@interface AlphaAlertView()
@property (nonatomic, strong) UIViewController*supervc;

@end
@implementation AlphaAlertView



//没有权限查看通讯录
-(instancetype)initWithNoAccessAndSupervc:(UIViewController*)supervc{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
         self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self makeNoAccessViewWithSupervc:supervc];
    }
    return self;
}

-(void)makeNoAccessViewWithSupervc:(UIViewController*)supervc{
    UIView*whiteView=[[UIView alloc]initWithFrame:CGRectMake(30, self.frame.size.height*0.2, SCREEN_WIDTH-60, 320)];
    whiteView.backgroundColor=WHITECOLOR ;
    whiteView.layer.cornerRadius=5;
    whiteView.layer.masksToBounds=YES;
    [self addSubview:whiteView];
//    whiteView.alpha=0.1;
    
    
    UBLabel*lb0=[UBLabel makeLabelWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40) andText:@"填写信息" andTitleColor:WHITECOLOR andFont:16];
    [lb0 setTextAlignment:(NSTextAlignmentCenter)];
    lb0.backgroundColor=MAJORCOLOR;
    [whiteView addSubview:lb0];
    
    //姓名 手机号
    for (int i=0; i<2; i++) {
        UBLabel*lb =[UBLabel makeLabelWithFrame:CGRectMake(10,CGRectGetMaxY(lb0.frame)+ 10+50*i, 80, 20) andText:@[@"姓   名",@"手机号"][i] andTitleColor:[UIColor darkGrayColor] andFont:14];
        [lb setTextAlignment:(NSTextAlignmentCenter)];
        [whiteView addSubview:lb];
        
        UITextField*tf =[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb.frame), CGRectGetMinY(lb.frame), whiteView.frame.size.width-CGRectGetMaxX(lb.frame)-20, 30)];
        tf.layer.borderWidth=0.5;
        tf.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [whiteView addSubview:tf];
        if (i==0) {
            self.nametf=tf;
        }else if (i==1){
            self.phonetf=tf;
            [self.phonetf setKeyboardType:(UIKeyboardTypeNumberPad)];
        }
        
    }
    //描述
    UBLabel*lbwt =[UBLabel makeLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_phonetf.frame)+10, 80, 120) andText:@"问   题" andTitleColor:[UIColor darkGrayColor] andFont:14];
    [lbwt setTextAlignment:(NSTextAlignmentCenter)];
    [whiteView addSubview:lbwt];
    self.textview=[[UBBTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbwt.frame), CGRectGetMaxY(_phonetf.frame)+10, self.phonetf.frame.size.width, 120) withPlaceholder:@"简单描述您的问题" andLimiteWords:300];
    self.textview.font= FONT_NORMAL;
    [whiteView addSubview:self.textview];
    
    __weak typeof(self) weakSelf = self;
    _cancelBtn=[UBButton makeButtonWithFrame:CGRectMake(whiteView.frame.size.width*0.5-120,whiteView.frame.size.height-50, 80, 30) andTitle:@"取消" andTitleColor:[UIColor grayColor] andFont:14 andBackGroundColor:[UIColor clearColor]];
    [_cancelBtn addAction:^(UBButton *button) {
        [weakSelf removeFromSuperview];

    }];
    [whiteView addSubview:_cancelBtn];

    _confirmBtn=[UBButton makeButtonWithFrame:CGRectMake(whiteView.frame.size.width*0.5+40,whiteView.frame.size.height-50, 80, 30) andTitle:@"提交" andTitleColor:WHITECOLOR andFont:14 andBackGroundColor:MAJORCOLOR];
    _confirmBtn.layer.cornerRadius=5;
    _confirmBtn.layer.masksToBounds=YES;
    [_confirmBtn addAction:^(UBButton *button) {
        if (weakSelf.confirmBlock) {
            weakSelf.confirmBlock(weakSelf.nametf.text, weakSelf.phonetf.text, weakSelf.textview.text);
        }
    }];
    [whiteView addSubview:_confirmBtn];
//
//    UIView*line =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(more.frame), whiteView.frame.size.width, 0.8)];
//    line.backgroundColor=LIGHTGRAY;
//    [whiteView addSubview:line];
//    UIView*line2 =[[UIView alloc]initWithFrame:CGRectMake(whiteView.frame.size.width*0.5-0.4, CGRectGetMinY(more.frame), 0.8, 40)];
//    line2.backgroundColor=LIGHTGRAY;
//    [whiteView addSubview:line2];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundColor=[KGray_Color colorWithAlphaComponent:0.5];
//        whiteView.alpha=1;
//    }];
}


/*
 ** 通用提示  标题  文字 左右两个按钮
 */
-(instancetype)initCommonAlertWithSupervc:(UIViewController*)supervc andTitle:(NSString*)title andContent:(NSString*)content andCancelBtnTitle:(NSString*)cancelbtnTitle andConfirmBlock:(void(^)(id obj))confirm{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.supervc=supervc;
        UIView*whiteView=[[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height*0.3, SCREEN_WIDTH-20, 200)];
        whiteView.backgroundColor=WHITECOLOR ;
        whiteView.layer.cornerRadius=5;
        whiteView.layer.masksToBounds=YES;
        [self addSubview:whiteView];
        whiteView.alpha=0.1;
        
        UBLabel*lb=[UBLabel makeLabelWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40) andText:title andTitleColor:WHITECOLOR andFont:18];
        lb.backgroundColor=MAJORCOLOR;
        [lb setTextAlignment:(NSTextAlignmentCenter)];
        [whiteView addSubview:lb];
        
        
        UBLabel*lb2=[UBLabel makeLabelWithFrame:CGRectMake(0, CGRectGetMaxY(lb.frame)+20, whiteView.frame.size.width, 50) andText:content andTitleColor:MAJORCOLOR andFont:16];
        lb2.numberOfLines=2;
        //行间距10
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:lb2.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lb2.text length])];
        
        [lb2 setAttributedText:attributedString1];
        lb2.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:lb2];
        
        
        UIView*bottomV=[[UIView alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height-50, whiteView.frame.size.width, 50)];
//        bottomV.backgroundColor=IWColor(247, 247, 248);
        [whiteView addSubview:bottomV];
        
        
       
        UBButton*rightBtn=[UBButton makeButtonWithFrame:CGRectMake(bottomV.frame.size.width*0.5-40, 10, 80, 30) andTitle:@"确认" andTitleColor:WHITECOLOR andFont:16 andBackGroundColor:MAJORCOLOR];
        [bottomV addSubview:rightBtn];
        [rightBtn addAction:^(UBButton *button) {
            confirm(@"");
            [self removeFromSuperview];
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5];
            whiteView.alpha=1;
        }];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nametf resignFirstResponder];
    [self.phonetf resignFirstResponder];
    [self.textview resignFirstResponder];

}
@end
