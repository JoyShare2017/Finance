//
//  MyHeadCell.m
//  Finance
//
//  Created by 赵帅 on 2018/4/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyHeadCell.h"
#import "UIButton+WebCache.h"
@interface MyHeadCell()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end
@implementation MyHeadCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    _itemLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60,40)];
    _itemLb.textColor=BLACKCOLOR;
    _itemLb.font=FONT_BIG;
    [self addSubview:_itemLb];

    _headbtn=[[UBButton alloc]initWithFrame:CGRectMake(70, 10, 60, 60)];
    [_headbtn sd_setImageWithURL:nil forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"touxiang"]];
    __weak typeof(self) weakSelf = self;

    [_headbtn addAction:^(UBButton *button) {
        [weakSelf callCameraOptions];
    }];
    _headbtn.layer.cornerRadius=_headbtn.frame.size.width/2;
    _headbtn.layer.masksToBounds=YES;
    [self addSubview:_headbtn];

}
- (void)callCameraOptions{
    [self.superVc jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
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
            [self.superVc presentViewController:self.imagePickerVc animated:YES completion:nil];

        }else if ([action.title isEqualToString:@"去相册选择"]){
            self.imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //跳转到UIImagePickerController控制器弹出相册
            [self.superVc presentViewController:self.imagePickerVc animated:YES completion:nil];

        }else{
            [alertSelf dismissViewControllerAnimated:YES completion:nil];
        }

    }];

}
#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    [self saveHeadWithImage:[info valueForKey:UIImagePickerControllerEditedImage]];

}
-(void)saveHeadWithImage:(UIImage*)headimg{
    NSString *urlString = [OPENAPIHOST stringByAppendingString:@"member/index/upload_image"];
    NSData *imageData = UIImagePNGRepresentation(headimg);

    [[NetworkManager sharedManager]uploadImage:urlString parameters:nil imageData:imageData severImageFieldName:@"image" callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self.superVc showHint:@"图片上传失败,请稍后重试"];
        }else{
            //图片上传成功
            [_headbtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",OPENAPIHOST,responseObject]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"touxiang"]];
            if (self.getTheHeadImgUrl) {
                self.getTheHeadImgUrl(responseObject);
            }

        }
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_headbtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",OPENAPIHOST,[UserAccountManager sharedManager].userAccount.user_image]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"touxiang"]];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
