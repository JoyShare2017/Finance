//
//  AnswerController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/13.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "AnswerController.h"


#define textView_placeholder @"请写下你的问题解答"

@interface AnswerController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation AnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"递交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    self.view.backgroundColor = GRAYCOLOR_BACKGROUND;
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-NAVGATION_MAXY-HOME_HEIGHT)/2)];
    self.textView.backgroundColor = WHITECOLOR;
    self.textView.delegate = self;
    self.textView.textColor = GRAYCOLOR_TEXT;
    self.textView.font = FONT_NORMAL;
    self.textView.text = textView_placeholder;
    [self.view addSubview:self.textView];
    
    self.imageContentView.y = self.textView.maxY + MARGIN;
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = BLACKCOLOR;
    textView.text = nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}


- (void)commit{

    [self uploadImageSuccess:^(NSArray *imageURLs) {
        [self uploadAnswer:imageURLs];
    }];
}


- (void)uploadAnswer:(NSArray *)imageURLs{
    if ([self.textView.text isEqualToString:textView_placeholder] || [self.textView.text isEqualToString:@""]){
        [self showHint:@"解答文字不可为空"];
        return;
    }
    
    [self.textView resignFirstResponder];
    [self showHudInView:self.view];
    
    /*接口：index/add_answer
     参数：
     @param  int     user_id             * 用户的id
     @param  string  user_name           * 用户名
     @param  int     answer_question_id     * 问题的主键
     @param  int     answer_is_voice         答案为语音作答？0：不是，1：是；默认0；
     @param  string     answer_voice         音频地址
     @param  int     answer_content         * 问题答案内容主体（现在是必填项，后期可能语音和内容二选一）
     @param  string     answer_images     回答的图片，多张使用逗号分隔
     @param  string     answer_price         设置的查看金额，默认：0元，免费
  */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/add_answer"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSString *imagesString = [imageURLs componentsJoinedByString:@","];
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"answer_question_id":@(self.questionId),
                                @"answer_is_voice":@(0),
                                @"answer_content":self.textView.text,
                                @"answer_images":imagesString,
                                @"answer_price":@(0)
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
