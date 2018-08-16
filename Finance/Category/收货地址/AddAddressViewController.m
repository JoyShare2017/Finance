//
//  AddAddressViewController.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/19.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "AddAddressViewController.h"
#import "UBTextField.h"
#import "AppDelegate.h"
#import "ChooseAddressViewController.h"
#import "RegExpManager.h"

#import "Province.h"
#import "City.h"
#import "Country.h"
#import <MBProgressHUD.h>
typedef void(^HUDHideBlock)();

@interface AddAddressViewController ()<UITextViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,strong)UBTextField*nameTf,*phoneTf,*sectionTf;
@property(nonatomic,strong)UITextView*addressTextv;
@property(nonatomic,strong)UISwitch*mySwitch;
@property(nonatomic,strong)Province*myProvince;
@property(nonatomic,strong)City*myCity;
@property(nonatomic,strong)Country*myCounty;
@property (nonatomic,strong) HUDHideBlock hudHideBlock;


@end

@implementation AddAddressViewController
{
    UILabel*placeholderLb,*leftLengthLb;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:1];
    self.title=self.oldAddress?@"编辑收货人":@"新建收货人";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAddress)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    [self makeUI];
    
    
}

-(void)makeUI{
    
    UIView*whiteV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    whiteV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whiteV];
    
    for (int i=0; i<3; i++) {
        UIView*line =[[UIView alloc]initWithFrame:CGRectMake(10, i*40+39.5, SCREEN_WIDTH-20, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [whiteV addSubview:line];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    //输入框
    for (int i =0; i<3; i++) {
        UBTextField*lb=[[UBTextField alloc]initWithFrame:CGRectMake(90, i*40, SCREEN_WIDTH-120, 40)];
        lb.font=[UIFont systemFontOfSize:14];
        if (i==0) {_nameTf=lb;
            lb.placeholder=@"请输入收货人";
            [self addMustInsetTipWithTitle:@"收货人" andSuperView:lb];
        }
        else  if (i==1) {_phoneTf=lb;
            lb.placeholder=@"请输入联系电话";
            [lb setKeyboardType:(UIKeyboardTypeNumberPad)];
            [self addMustInsetTipWithTitle:@"联系方式" andSuperView:lb];
        }
        else  if (i==2) {_sectionTf=lb;
            lb.placeholder=@"请选择";
            [lb setTextAlignment:(NSTextAlignmentRight)];

            [self addMustInsetTipWithTitle:@"所在地区" andSuperView:lb];
            UIButton*right =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sectionTf.frame), _sectionTf.frame.origin.y, 20, 40)];
            [right setImage:[UIImage imageNamed:@"next"] forState:(UIControlStateNormal)];
            [whiteV addSubview:right];
            
            _sectionTf.textFieldShouldBeginEditing=^BOOL(UITextField* textField){
                
                NSLog(@"跳到选择省市县");
                ChooseAddressViewController*choose=[ChooseAddressViewController new];
                choose.SelectTheRegion=^(Province*province , City*city ,Country*county){
                    weakSelf.myProvince=province;
                    weakSelf.myCity=city;
                    weakSelf.myCounty=county;
                    weakSelf.sectionTf.text=[NSString stringWithFormat:@"%@ %@ %@",weakSelf.myProvince.name, weakSelf.myCity.name, weakSelf.myCounty.name];
                };
                [weakSelf.navigationController pushViewController:choose animated:YES];
                
                
                return NO;
            };
            
            
            
        }
        
        [whiteV addSubview:lb];
        
        
    }
    
    //详细地址
    _addressTextv=[[UITextView alloc]initWithFrame:CGRectMake(15, 120, SCREEN_WIDTH-30, whiteV.frame.size.height-120-10)];
    _addressTextv.font=[UIFont systemFontOfSize:16];
//    [_addressTextv setTextAlignment:(NSTextAlignmentRight)];
//    [_addressTextv setTextContainerInset:UIEdgeInsetsMake(10, 70, 0, 0)];
    _addressTextv.delegate=self;
    [whiteV addSubview:_addressTextv];
//    [self addMustInsetTipWithTitle:@"详细地址" andSuperView:_addressTextv];
    
    
    
    placeholderLb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 35)];
    placeholderLb.text=@"请填写详细地址,不少于5个字";
//    [placeholderLb setTextAlignment:(NSTextAlignmentRight)];
    placeholderLb.textColor=[UIColor lightGrayColor];
    placeholderLb.font=[UIFont systemFontOfSize:14];
    [_addressTextv addSubview:placeholderLb];
    
    leftLengthLb = [[UILabel alloc]initWithFrame:CGRectMake(whiteV.frame.size.width-55, whiteV.frame.size.height-20, 50, 20)];
    [leftLengthLb setTextAlignment:(NSTextAlignmentRight)];
    leftLengthLb.text=@"50/50";
    leftLengthLb.font=[UIFont systemFontOfSize:12];
    leftLengthLb.textColor=[UIColor lightGrayColor];
    [whiteV addSubview:leftLengthLb];
    
    
    
    //设为默认
    UIView*defaultView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteV.frame)+10, SCREEN_WIDTH, 40)];
    defaultView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:defaultView];
    
    
    UILabel*swmr=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, defaultView.frame.size.height)];
    swmr.text=@"设为默认";
    swmr.textColor=[UIColor darkGrayColor];
    [defaultView addSubview:swmr];
    
    
    _mySwitch =[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(defaultView.frame)-80, 0, 60, defaultView.frame.size.width)];
    _mySwitch.center = CGPointMake(defaultView.frame.size.width-40, 20);
    _mySwitch.onTintColor=MAJORCOLOR;
    _mySwitch.on=NO;
    [defaultView addSubview:_mySwitch];
    
    
    
    if (_oldAddress) {
        _nameTf.text=_oldAddress.us_name;
        _phoneTf.text=_oldAddress.us_phone;
        _sectionTf.text=[NSString stringWithFormat:@"%@ %@ %@",_oldAddress.sheng,_oldAddress.shi,_oldAddress.qu];
        Province*pro=[Province new];
        pro.name=_oldAddress.sheng;
        self.myProvince=pro;
        
        City*ci=[City new];
        ci.name=_oldAddress.shi;
        self.myCity=ci;
        
        Country*qu=[Country new];
        qu.name=_oldAddress.qu;
        self.myCounty=qu;
        
        _addressTextv.text=_oldAddress.jiedao;
        placeholderLb.hidden=YES;
        leftLengthLb.text=[NSString stringWithFormat:@"%lu/50",50-_addressTextv.text.length];
        _mySwitch.on=_oldAddress.us_default;
        
        
    }
    
    
    
    
}

-(void)saveAddress{
    if (self.nameTf.text.length<=0) {
        [[KCCommonAlertBlock defaultAlertBlock]showShortAlertWithController:self andMessage:@"请输入联系人"];
    }else if (self.phoneTf.text.length<=0){
        [[KCCommonAlertBlock defaultAlertBlock]showShortAlertWithController:self andMessage:@"请输入联系电话"];
    }else if (self.sectionTf.text.length<=0){
        [[KCCommonAlertBlock defaultAlertBlock]showShortAlertWithController:self andMessage:@"请选择区域"];
    }else if (self.addressTextv.text.length<=0){
        [[KCCommonAlertBlock defaultAlertBlock]showShortAlertWithController:self andMessage:@"请输入详细地址"];
    }else if (self.addressTextv.text.length<5){
        [[KCCommonAlertBlock defaultAlertBlock]showShortAlertWithController:self andMessage:@"详细地址不少于5个字"];
    }else{
        
        //请求服务器
        [self addAddresstoServe];
    }
}


-(void)addAddresstoServe{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/add_user_address"];
    
    
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    
    NSDictionary *parameter = @{
                                @"user_id":@([user.user_id integerValue]),
                                
                                @"user_name":user.user_name,
                                @"us_id":self.oldAddress.us_id?self.oldAddress.us_id:@"",
                                @"us_default":self.mySwitch.on?@"1":@"0",
                                @"us_phone":self.phoneTf.text,
                                @"us_name":self.nameTf.text,
                                @"us_address":[NSString stringWithFormat:@"%@ %@ %@ %@",self.myProvince.name,self.myCity.name,self.myCounty.name,self.addressTextv.text]
                                
                                };
    [self showHudInView:self.view];
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters: parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode==NetworkResultSuceess) {
            [self showHint:@"添加成功"];
            if (self.updateSuccess) {
                self.updateSuccess(@"");
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showHint:(NSString *)responseObject];
        }
    }];
}


-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length > 50) {
                textView.text = [toBeString substringToIndex:50];
            }
        }
        
        else{
            
        }
    }
    
    else{
        if (toBeString.length > 50) {
            textView.text = [toBeString substringToIndex:50];
        }
    }
    
    
    if (textView.text.length>0) {
        placeholderLb.hidden=YES;
    }else
        placeholderLb.hidden=NO;
    leftLengthLb.text=[NSString stringWithFormat:@"%zd/50",50-_addressTextv.text.length];
    
    
    
}
-(void)showHUD:(NSString*)str hide:(HUDHideBlock)block
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    _hudHideBlock = block;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0f];
}
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if(_hudHideBlock)
    {
        _hudHideBlock();
    }
}

-(void)addMustInsetTipWithTitle:(NSString*)title andSuperView:(UIView*)superview{
    
    
    UILabel*lb=[[UILabel alloc]initWithFrame:CGRectMake(-70, 0, 60, 40)];
    lb.text=title;
    lb.textColor=[UIColor darkGrayColor];
    lb.font=[UIFont systemFontOfSize:14];
//    UILabel*subLb=[[UILabel alloc]initWithFrame:CGRectMake(lb.frame.size.width, 0, 10, 35)];
//    subLb.text=@"*";
//    subLb.textColor=[UIColor redColor];
//    [lb addSubview:subLb];
//    subLb.font=[UIFont systemFontOfSize:14];
    
    [superview addSubview:lb];
    
}
-(Province *)myProvince{
    if (!_myProvince) {
        _myProvince=[Province new];
    }
    return _myProvince;
}
-(City *)myCity{
    if (!_myCity) {
        _myCity=[City new];
    }
    return _myCity;
}
-(Country *)myCounty{
    if (!_myCounty) {
        _myCounty=[Country new];
    }
    return _myCounty;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    //    if (IS_IPHONE_5) {
    //        [UIView animateWithDuration:0.5 animations:^{
    //            CGRect rec = self.view.frame;
    //            rec.origin.y =-36;
    //            self.view.frame=rec;
    //        }];
    //    }
    
    
    return YES;
    
    
    
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    //    if (IS_IPHONE_5) {
    //    [UIView animateWithDuration:0.5 animations:^{
    //    CGRect rec = self.view.frame;
    //    rec.origin.y =64;
    //    self.view.frame=rec;
    //        }];
    //    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
