//
//  AskController.m
//  Finance
//
//  Created by 郝旭珊 on 2017/12/27.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import "AskController.h"
#import "UserAccount.h"
#import "EditMyTagVController.h"
#import "TagSmallModel.h"
#import "ChannelButton.h"
#define textView_placeholder @"请写下相关问题描述信息(选填)"
@interface AskController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *questionTf;
@property (weak, nonatomic) IBOutlet UITextView *describeTv;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (nonatomic, strong) NSMutableArray *selectedTagArr;


@end

@implementation AskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提问";
    self.selectedTagArr=[NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"递交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    _tagButton.layer.borderColor = GRAYCOLOR_BORDER.CGColor;
    _tagButton.layer.borderWidth = 1;
    _questionTf.delegate = self;
    _describeTv.delegate = self;
    _describeTv.text = textView_placeholder;

    self.imageContentView.y = self.tagView.maxY;
    [self makeTagViewUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 退出第一响应
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}



-(void)makeTagViewUI{
    for (id obj in _tagView.subviews) {
        if ([obj isKindOfClass:[ChannelButton class]]) {
            [(ChannelButton*)obj removeFromSuperview];
        }
    }
    CGFloat btnWidth =(_tagView.frame.size.width-40)/3;
    CGFloat maxX=10;
    for (int i=0; i<_selectedTagArr.count; i++) {
        TagSmallModel*chn=_selectedTagArr[i];
        ChannelButton*chanBtn=[[ChannelButton alloc]initWithFrame:CGRectMake((i%3)*(btnWidth+10)+10, 10,btnWidth ,40)];
        [chanBtn setTitle:chn.qt_name forState:(UIControlStateNormal)];
        chanBtn.tag=i;
        chanBtn.channel_id=[chn.qt_id integerValue];
        chanBtn.closeBtn.tag=chanBtn.channel_id;
        chanBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_tagView addSubview:chanBtn];
        [chanBtn addAction:^(UBButton *button) {
            for (TagSmallModel*small in _selectedTagArr) {
                if ([small.qt_id integerValue]==((ChannelButton*)button).channel_id) {
                    [_selectedTagArr removeObject:small];
                    [self makeTagViewUI];
                    break;
                }
            }
        }];
        maxX=CGRectGetMaxX(chanBtn.frame)+10;

    }
    if (_selectedTagArr.count<3) {
        ChannelButton*chanBtn=[[ChannelButton alloc]initWithFrame:CGRectMake(maxX,10,btnWidth ,40)];
        [chanBtn setTitle:@"+标签(选填)" forState:(UIControlStateNormal)];
        chanBtn.backgroundColor=WHITECOLOR;
        [chanBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        chanBtn.layer.borderColor=GRAYCOLOR_BORDER.CGColor;
        chanBtn.layer.borderWidth=1;
        chanBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        chanBtn.closeBtn.hidden=YES;
        [chanBtn addAction:^(UBButton *button) {
            [self chooseTage];
        }];
        [_tagView addSubview:chanBtn];
    }
}

#pragma mark - 响应事件

- (void)chooseTage{
    EditMyTagVController*choosetag=[EditMyTagVController new];
    choosetag.oldChannelArr=[self.selectedTagArr mutableCopy];
    choosetag.hidMyTagPart=YES;
    __weak typeof(self) weakSelf = self;
    choosetag.changeedTheTags = ^(NSMutableArray *tags) {
        weakSelf.selectedTagArr=tags;
        [weakSelf makeTagViewUI];
    };
    [self.navigationController pushViewController:choosetag animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text  isEqualToString: textView_placeholder]){
        textView.text = @"";
        textView.textColor = BLACKCOLOR;
    }

}


- (void)submit{

    if (!self.questionTf.text){
        [self showHint:@"问题不可为空"];
        return;
    }

    if ([self.questionTf.text isEqualToString:@""]){
        [self showHint:@"问题不可为空"];
        return;
    }

    [self uploadImageSuccess:^(NSArray *imageURLs) {
        [self uploadQuestion:imageURLs];
    }];
}


- (void)uploadQuestion:(NSArray *)imageURLs{
    NSString *urlString = [OPENAPIHOST stringByAppendingString:@"index/add_question"];
    /*@param  int        user_id            * 用户的id
     @param  string    user_name        * 用户名
     @param  string  question_title       * 问题题目
     @param  string  question_describe   问题描述。500字以内
     @param  string  question_lable       问题标签：多个逗号分开
     @param  string  question_images        问题的图片：多个逗号分开。[至多三张]
     @param  string  question_mode       问题模式：1：普通、2：赏金；默认：“1”普通问题
     @param  string  question_price       赏金金额；默认0   */
    NSMutableArray *idArray = [NSMutableArray array];
    for (TagSmallModel*ex in self.selectedTagArr) {
        [idArray addObject:ex.qt_id];
    }

    NSString*desStr=self.describeTv.text;
    if ([desStr isEqualToString:textView_placeholder]) {
        desStr=@"";
    }
    NSString *idsStr = [idArray componentsJoinedByString:@","];
    NSString *imagesString = [imageURLs componentsJoinedByString:@","];
    UserAccount *userAccount = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":userAccount.user_id,
                                @"user_name":userAccount.user_name,
                                @"question_title":self.questionTf.text,
                                @"question_describe":desStr,
                                @"question_lable":idsStr,
                                @"question_images":imagesString,
                                @"question_mode":@"",
                                @"question_price": @"0"
                                };
    [self showHudInView:self.view];
    [[NetworkManager sharedManager]request:POST URLString:urlString parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }else{
            [self showHint:@"问题提交成功"];
             [self.photos removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}









@end
