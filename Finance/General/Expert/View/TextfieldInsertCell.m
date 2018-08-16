//
//  TextfieldInsertCell.m
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/17.
//  Copyright © 2017年 赵帅. All rights reserved.
//

#import "TextfieldInsertCell.h"

#define kTITELFONT 15
#define SCREENSIZE [UIScreen mainScreen].bounds.size

@interface TextfieldInsertCell()<UITextFieldDelegate>
@property(nonatomic,strong)UIView*alphaView;

@end

@implementation TextfieldInsertCell





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {//添加展示控件
        
        self.accessoryView = nil;
        
//        _starLable = [[UILabel alloc]init];
//        _starLable.text = @"*";
//        _starLable.textColor = [UIColor redColor];
//        _starLable.font = [UIFont systemFontOfSize:kTITELFONT];
//        [self.contentView addSubview:_starLable];
        
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = [UIFont systemFontOfSize:kTITELFONT];
        [self.contentView addSubview:_titleLable];
        
        _subTextField = [[UITextField alloc]init];
//        _subTextField.borderStyle = UITextBorderStyleRoundedRect;
        [_subTextField setReturnKeyType:(UIReturnKeyDone)];

        _subTextField.font = [UIFont systemFontOfSize:kTITELFONT];
        [_subTextField setTextAlignment:(NSTextAlignmentRight)];
        _subTextField.placeholder=@"选填";
        _subTextField.delegate=self;
        [self.contentView addSubview:_subTextField];
        
        _rightImageView = [[UIImageView alloc]init];
        [_subTextField addSubview:_rightImageView];
        _rightImageView.image = [UIImage imageNamed:@"下一级"];
        
        [self setSubViewFrame];

        
        
        
        
    }
    return self;
}

-(void)setSubViewFrame
{
//    _starLable.frame = CGRectMake(15, 0, 10, self.frame.size.height);
    _titleLable.frame = CGRectMake(15, 0, (SCREENSIZE.width-40)/3, self.bounds.size.height);
    _subTextField.frame = CGRectMake((SCREENSIZE.width-40)/3+25, (self.frame.size.height-30)/2, (SCREENSIZE.width-40)/3*2, 30);
    _rightImageView.frame = CGRectMake(_subTextField.frame.size.width-15, (_subTextField.frame.size.height-16)/2, 12, 16);
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.superVC.view endEditing:YES];
    return YES;
}
-(void)setInsertType:(NSInteger)insertType{

    _insertType=insertType;
    
    switch (_insertType) {
        case TEXTFIELDTYPECOMMON:
            
            break;
        case TEXTFIELDTYPENUMBER:{
            [self.subTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
        }
            break;
        case TEXTFIELDTYPEMOBILE:{
            [self.subTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
            
           
            
        
        }
            
            break;
        case TEXTFIELDTYPECANCLEAR:{
            [self.subTextField setClearButtonMode:(UITextFieldViewModeAlways)];
          
        
        }
            
            break;
        case TEXTFIELDTYPEINSURE:{
            self.subTextField.secureTextEntry=YES;
        }
            
            break;
        case TEXTFIELDTYPEDATE:{
            
            [self.subTextField setBorderStyle:(UITextBorderStyleNone)];
            self.subTextField.text=[self getCurrentDateWithDay];//显示当天
            
            
            
        }
            
            break;
        default:
            break;
    }


}



-(void)chooseYMD{
    
    [self.superVC.view endEditing:YES];
    typeof(self) __weak weakSelf = self;
    
    
    if (self.alphaView) {  [self.alphaView removeFromSuperview]; }
    self.alphaView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.alphaView.backgroundColor=[[UIColor darkGrayColor]colorWithAlphaComponent:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alphaView.backgroundColor=[[UIColor darkGrayColor]colorWithAlphaComponent:0.6];
    }];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc ]initWithTarget:weakSelf action:@selector(selfHide)];
    [self.alphaView addGestureRecognizer:tap];
    
   


}






-(BOOL)matchToMobilePhone:(NSString*)str{

    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:str];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:str];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:str];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }

}

-(NSString*)getCurrentDateWithDay{
    NSDate * today = [NSDate date];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-M-d"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    return  [df stringFromDate:today];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected&&self.insertType==TEXTFIELDTYPEDATE) {
        //点击了选择日期的cell
        if (self.alphaView) {  [self.alphaView removeFromSuperview]; }
        self.alphaView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.alphaView.backgroundColor=[[UIColor darkGrayColor]colorWithAlphaComponent:0.0];
        [self.superVC.navigationController.view addSubview:self.alphaView];

        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(selfHide)];
        [self.alphaView addGestureRecognizer:tap];

   
    }
    
}


-(void)selfHide{
    [self.alphaView removeFromSuperview];

}


@end
