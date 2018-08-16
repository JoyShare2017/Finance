//
//  ConsultController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ConsultController.h"

#define textView_placeholder @"请写下你的问题相关描述"
#define textField_placeholder @"请写下你的问题并用问答结尾"

@interface ConsultController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ConsultController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.severName;// @"图文咨询";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"递交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    self.view.backgroundColor = GRAYCOLOR_BACKGROUND;
    
//    UIView *tfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    tfView.backgroundColor = WHITECOLOR;
//    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN, MARGIN, SCREEN_WIDTH-MARGIN*2, 30)];
//    self.tf.delegate = self;
//    self.tf.textColor = BLACKCOLOR;
//    self.tf.font = FONT_NORMAL;
//    self.tf.placeholder = textField_placeholder;
//    [tfView addSubview:self.tf];
//    [self.view addSubview:tfView];
    
    CGRect rect = CGRectMake(0, MARGIN, SCREEN_WIDTH, 130);
    UIView *backView = [[UIView alloc]initWithFrame:rect];
    backView.backgroundColor = WHITECOLOR;
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(MARGIN, 0, backView.width-MARGIN*2, backView.height)];
    self.textView.backgroundColor = WHITECOLOR;
    self.textView.delegate = self;
    self.textView.textColor = GRAYCOLOR_TEXT_LIGHT;
    self.textView.font = FONT_NORMAL;
    self.textView.text = textView_placeholder;
    [self.view addSubview:backView];
    [backView addSubview:self.textView];

    self.imageContentView.y = backView.maxY + MARGIN;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = BLACKCOLOR;
    textView.text = nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tf resignFirstResponder];
    [self.textView resignFirstResponder];
}


- (void)commit{
    [self uploadImageSuccess:^(NSArray *imageURLs) {
        [self uploadQuestion:imageURLs];
    }];
}


- (void)uploadQuestion:(NSArray *)imageURLs{
    if ([self.textView.text isEqualToString:textView_placeholder] || [self. textView.text isEqualToString:@""]){
        [self showHint:@"问题不可为空"];
        return;
    }
    
    [self.textView resignFirstResponder];
    [self showHudInView:self.view];
    
    
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/add_member_consult_msg"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSString *imagesString = [imageURLs componentsJoinedByString:@","];
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"mco_id":self.mco_id?self.mco_id:@"",
                                @"content":self.textView.text,
                                @"images":imagesString
                                };
    
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
        }else{
            [self showHint:@"提交成功"];
            [self.photos removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}



@end
