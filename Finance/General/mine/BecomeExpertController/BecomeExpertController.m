//
//  BecomeExpertController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/1.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "BecomeExpertController.h"
#import <AVFoundation/AVFoundation.h>
#import "ChoseServeController.h"

#define introductionTv_placeHolder @"请输入您的简要介绍"
#define professionalTv_placeHolder @"请输入您的专业(最多3个, 每个4个字,以空格分开)"

@interface BecomeExpertController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *companyTf;
@property (weak, nonatomic) IBOutlet UITextField *jobTf;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *industryTf;
@property (weak, nonatomic) IBOutlet UITextField *qualifiedTf;
@property (weak, nonatomic) IBOutlet UITextField *skilledTf;

@property (weak, nonatomic) IBOutlet UITextView *introductionTv;
@property (weak, nonatomic) IBOutlet UITextView *professionalTv;
@property (weak, nonatomic) IBOutlet UITextField *idCardTf;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTf;

@property (weak, nonatomic) IBOutlet UILabel *certificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (nonatomic, strong) UIImage *certificationImage;
@property (nonatomic, strong) UIImage *idCardImage;
@property (nonatomic, copy) NSArray *textFields;
@property (nonatomic, copy) NSString *certificationImageUrl;
@property (nonatomic, copy) NSString *idCardImageUrl;

@property(nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *industrys;
@property (nonatomic, copy) NSArray *qualifieds;
@property (nonatomic, copy) NSArray *skilleds;
@property(nonatomic)BOOL isChoosingIdCardImg;
@end

@implementation BecomeExpertController

- (UIView *)pickerView{
    if (_pickerView == nil){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _pickerView.backgroundColor = GRAYCOLOR_BACKGROUND;
        _pickerView.tintColor = GRAYCOLOR_BACKGROUND;
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (UIImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil){
        //创建UIImagePickerController对象，并设置代理和可编辑
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.editing = YES;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        _imagePickerVc = imagePicker;
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"成为专家";
    self.tableView.bounces = NO;
    [self takeoutExpertCondition];
    [self setupFooterView];

    self.textFields = @[self.nameTf,self.companyTf,self.jobTf,self.cityTf,self.phoneTf,self.industryTf,self.qualifiedTf,self.skilledTf];
    for (int i = 0;i<self.textFields.count;i++){
        UITextField *tf = self.textFields[i];
        tf.tag = i;
        tf.delegate = self;
    }
    self.introductionTv.delegate = self;
    self.professionalTv.delegate = self;
    self.idCardTf.delegate = self;
    self.inviteCodeTf.delegate = self;
    self.introductionTv.text = introductionTv_placeHolder;
    self.professionalTv.text = professionalTv_placeHolder;

    self.industryTf.inputView = self.pickerView;
    self.qualifiedTf.inputView = self.pickerView;
    self.skilledTf.inputView = self.pickerView;

    if (self.oldExpertModel) {
        _nameTf.text=_oldExpertModel.expert_full_name;
        _companyTf.text=_oldExpertModel.expert_renzhijigou;
        _jobTf.text=_oldExpertModel.expert_zhiwei;
        _cityTf.text=_oldExpertModel.expert_city;
        _phoneTf.text=_oldExpertModel.expert_phone;
        _industryTf.text=_oldExpertModel.expert_hangye_value;
        _qualifiedTf.text=_oldExpertModel.expert_dengji_value;
        _skilledTf.text=_oldExpertModel.expert_lingyu_value;

        _introductionTv.text=_oldExpertModel.expert_jianjie;
        _professionalTv.text=_oldExpertModel.expert_zhuanye;

        if (_oldExpertModel.expert_img_zhengshu.length>0) {
            _certificationLabel.text=@"已上传";
            _certificationImageUrl=_oldExpertModel.expert_img_zhengshu;
        }
        if (_oldExpertModel.expert_id_card.length>0) {
            _idCardImageUrl=_oldExpertModel.expert_id_card;
            _idCardLabel.text=@"已上传";
        }

    }
}


- (void)takeoutExpertCondition{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"expertCondition.plist"];
    NSDictionary *allConditions = [[NSDictionary alloc]initWithContentsOfFile:plistPath];

    self.industrys = allConditions[KEY_EXPERT_INDUSTRY];
    self.qualifieds = allConditions[KEY_EXPERT_QUALIFIED];
    self.skilleds = allConditions[KEY_EXPERT_SKILLED];

}


#pragma mark - UIPickerViewDelegate

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];

    if (firstResponder == self.industryTf){
        return self.industrys.count;
    }else if (firstResponder == self.qualifiedTf){
        return self.qualifieds.count;
    }else{
        return self.skilleds.count;
    }
}

#pragma Mark -- UIPickerViewDelegate
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    NSDictionary *dict;
    if (firstResponder == self.industryTf){
        dict = self.industrys[row];
        self.industryTf.text = [dict allValues].firstObject;
    }else if (firstResponder == self.qualifiedTf){
        dict = self.qualifieds[row];
        self.qualifiedTf.text = [dict allValues].firstObject;
    }else{
        dict = self.skilleds[row];
        self.skilledTf.text = [dict allValues].firstObject;
    }

}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];

    NSDictionary *dict;
    if (firstResponder == self.industryTf){
        dict = self.industrys[row];
    }else if (firstResponder == self.qualifiedTf){
        dict = self.qualifieds[row];
    }else{
        dict = self.skilleds[row];
    }

    return [dict allValues].firstObject;

}



- (void)setupFooterView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.backgroundColor = GRAYCOLOR_BACKGROUND;
    UIButton *nextStepButton = [UIButton buttonWithFrame:CGRectMake(MARGIN, MARGIN_BIG, SCREEN_WIDTH - MARGIN * 2, BUTTON_HEIGHT) title:@"下一步" font:FONT_NORMAL titleColor:WHITECOLOR backgroundColor:MAJORCOLOR target:self actionName:@"nextStep"];
    [footerView addSubview:nextStepButton];
    self.tableView.tableFooterView = footerView;
}

- (void)nextStep{

    if(self.nameTf.text.length*self.companyTf.text.length*self.jobTf.text.length*self.cityTf.text.length*self.phoneTf.text.length*self.professionalTv.text.length*self.industryTf.text.length<=0) {
        [self showHint:@"请填写完整资料"];
        return;
    }
    if (self.certificationImageUrl.length<=0) {
        [self showHint:@"请上传财务职业资格证书照片"];
        return;
    }
    if (self.idCardImageUrl.length<=0) {
        [self showHint:@"请上传身份证照片"];
        return;
    }

    NSDictionary *infoDict = @{
                               @"expert_full_name":self.nameTf.text,
                               @"expert_renzhijigou":self.companyTf.text,
                               @"expert_zhiwei":self.jobTf.text,
                               @"expert_city":self.cityTf.text,
                               @"expert_phone":self.phoneTf.text,
                               @"expert_zhuanye":self.professionalTv.text,
                               @"expert_jianjie":self.introductionTv.text,
                               @"expert_id_card":self.idCardImageUrl,
                               @"expert_img_zhengshu":self.certificationImageUrl,
                               @"expert_yaoqingma":self.inviteCodeTf.text,

                               @"expert_hangye":[self turnHangyeToIDWithHangye:self.industryTf.text],//需要对应的 id
                               @"expert_dengji":[self turnZizhiToIDWithZizhi:  self.qualifiedTf.text],//需要对应的 id
                               @"expert_lingyu":[self turnLingyuToIDWithZizhi: self.skilledTf.text],//需要对应的 id



                               };
    ChoseServeController *vc = [ChoseServeController new];
    vc.infoDict = [infoDict mutableCopy];
    if (self.oldExpertModel) {
        vc.oldExpert=self.oldExpertModel;
    }
    [self.navigationController pushViewController:vc animated:YES];

}

-(NSString*)turnHangyeToIDWithHangye:(NSString*)hy{
   __block NSString*hyId=@"";

    for (NSDictionary*dic in self.industrys) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:hy]) {
                hyId=(NSString*)key;
            }
        }];
    }
    
    NSLog(@"行业%@转id%@",hy,hyId);
    
    return hyId;
}
-(NSString*)turnZizhiToIDWithZizhi:(NSString*)zz{
    if (zz.length<=2) {
        NSLog(@"资质id%@",zz);
        return zz;//后台返回的就是数字
    }
    
    __block NSString*hyId=@"";

    for (NSDictionary*dic in self.qualifieds) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:zz]) {
                hyId=(NSString*)key;
            }
        }];
    }
    NSLog(@"资质%@转id%@",zz,hyId);

    return hyId;
}
-(NSString*)turnLingyuToIDWithZizhi:(NSString*)zz{
    __block NSString*hyId=@"";

    for (NSDictionary*dic in self.skilleds) {
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:zz]) {
                hyId=(NSString*)key;
            }
        }];
    }
    NSLog(@"领域%@转id%@",zz,hyId);
    return hyId;
}
- (void)callCameraOptions{
    [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionDefaultTitle(@"相机").
        addActionDefaultTitle(@"去相册选择").
        addActionCancelTitle(@"取消");

    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if ([action.title isEqualToString:@"相机"] ){
            //选择相机时，设置UIImagePickerController对象相关属性
            self.imagePickerVc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            self.imagePickerVc.mediaTypes = @[(NSString *)kUTTypeImage];
            self.imagePickerVc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //跳转到UIImagePickerController控制器弹出相机
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];

        }else if ([action.title isEqualToString:@"去相册选择"]){
            self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //跳转到UIImagePickerController控制器弹出相册
            [self presentViewController:self.imagePickerVc animated:YES completion:nil];

        }else{
            [alertSelf dismissViewControllerAnimated:YES completion:nil];
        }

    }];

}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    if (self.isChoosingIdCardImg) {
        self.idCardImage = [info valueForKey:UIImagePickerControllerEditedImage];

    }else{
        self.certificationImage = [info valueForKey:UIImagePickerControllerEditedImage];

    }
    [self uploadImage];

}

- (void)uploadImage{
    NSString *urlString = [OPENAPIHOST stringByAppendingString:@"member/index/upload_image"];
    NSData *imageData =nil;
    if (self.isChoosingIdCardImg) {
        imageData=UIImagePNGRepresentation(self.idCardImage);
    }else{
        imageData=UIImagePNGRepresentation(self.certificationImage);
    }

    [[NetworkManager sharedManager]uploadImage:urlString parameters:nil imageData:imageData severImageFieldName:@"image" callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self showHint:@"图片上传失败,请稍后重试"];
        }else{
            //图片上传成功
            if (self.isChoosingIdCardImg) {
                self.idCardLabel.text = @"已上传";
                self.idCardImageUrl = (NSString *)responseObject;
            }else{
                self.certificationLabel.text = @"已上传";
                self.certificationImageUrl = (NSString *)responseObject;
            }

        }
    }];

}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.industryTf || textField == self.qualifiedTf || textField == self.skilledTf){
        [self.pickerView reloadAllComponents];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger currentTfId = textField.tag;
    if (currentTfId + 1 < self.textFields.count){
        UITextField *nextTf = self.textFields[currentTfId + 1];
        [nextTf becomeFirstResponder];
    }

    if (textField == self.skilledTf){
        [self.introductionTv becomeFirstResponder];
    }else if (textField == self.idCardTf){
        [self.inviteCodeTf becomeFirstResponder];
    }else if (textField == self.inviteCodeTf){
        [textField resignFirstResponder];
    }

    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.introductionTv){
        if ([textView.text isEqualToString:introductionTv_placeHolder]) {
            textView.textColor = GRAYCOLOR_TEXT_LIGHT;
            textView.text = nil;
        } else {
            textView.textColor =BLACKCOLOR;
        }
        
        
    }else if (textView == self.professionalTv){
        
        if ([textView.text isEqualToString:professionalTv_placeHolder]) {
            textView.textColor = GRAYCOLOR_TEXT_LIGHT;
            textView.text = nil;
        } else {
            textView.textColor = BLACKCOLOR;
        }
        
    }
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle = section == 0 ? @"个人信息" : @"资质上传";
    UILabel *label = [UILabel labelWithFirstIndent:MARGIN frame:CGRectMake(0, 0, SCREEN_WIDTH, 30) text:sectionTitle textFont:FONT13 textColor:MAJORCOLOR backgroundColor:GRAYCOLOR_BACKGROUND];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 0){
            self.isChoosingIdCardImg=NO;
            [self callCameraOptions];
        }else if (indexPath.row==1){
            self.isChoosingIdCardImg=YES;
            [self callCameraOptions];
        }
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UITextField *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    [firstResponder resignFirstResponder];
//}





@end
