//
//  ReviewController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "ReviewController.h"
#import "DrawLineView.h"
#import "ExpertTimelineCell.h"
#import "BecomeExpertController.h"
@interface ReviewController ()
@property (nonatomic, strong) UBTableviewTool *tvTimeline;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核状态";
    self.view.backgroundColor = GRAYCOLOR_BACKGROUND;

    self.tvTimeline=[[UBTableviewTool alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, USEABLE_VIEW_HEIGHT) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tvTimeline];

    __weak typeof(self) weakSelf = self;

    self.tvTimeline.heightForRow = ^CGFloat(UITableView *tv, NSIndexPath *index) {
        return 130;
    };
    self.tvTimeline.numberOfRow = ^NSInteger(UITableView *tv, NSInteger section) {
        return weakSelf.dataArr.count;
    };
    self.tvTimeline.cellForRow = ^UITableViewCell *(UITableView *tv, NSIndexPath *indexPath) {
        ExpertTimelineCell*cell=[tv dequeueReusableCellWithIdentifier:@"ExpertTimelineCell"];
        if (!cell) {
            cell=[[ExpertTimelineCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ExpertTimelineCell"];
        }
        TimelineModel*theModel=weakSelf.dataArr[indexPath.row];;
        theModel.index=indexPath.row;
        cell.modeltimeline=theModel;


        [cell.editBtn addAction:^(UBButton *button) {
            BecomeExpertController*become=[[UIStoryboard storyboardWithName:@"BecomeExpertController" bundle:nil] instantiateViewControllerWithIdentifier:@"BecomeExpert"];
            become.oldExpertModel=weakSelf.oldModel;
            [weakSelf.navigationController pushViewController:become animated:YES];

        }];
        return cell;

    };

    //请求数据
    [self showHudInView:self.view];
    [KCommonNetRequest getExpertProgressStateAndComplete:^(BOOL success, id obj) {
        [self hideHud];
        if (success) {
            if ([obj isKindOfClass:[NSMutableArray class]]) {
                self.dataArr=obj;
                [self.tvTimeline reloadData];
            }
        }else{
            [self showHint:(NSString *)obj];
        }
    }];


/*
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 260)];
    backView.backgroundColor = WHITECOLOR;
    [self.view addSubview:backView];

    CGFloat lineViewH = (backView.height - MARGIN_BIG*2)/2;
    DrawLineView *lineView1 = [[DrawLineView alloc]initWithFrame:CGRectMake(10, MARGIN_BIG, 10, lineViewH)];
    lineView1.backgroundColor = WHITECOLOR;
    lineView1.isStroke = YES;
    [backView addSubview:lineView1];

    DrawLineView *lineView2 = [[DrawLineView alloc]initWithFrame:CGRectMake(10, lineView1.maxY, 10, lineViewH)];
    lineView2.isStroke = NO;
    lineView2.backgroundColor = WHITECOLOR;
//    [backView addSubview:lineView2];

    CGRect rect1 = CGRectMake(lineView1.maxX+MARGIN_BIG, lineView1.y, SCREEN_WIDTH-lineView1.maxX-MARGIN_BIG*2, lineView1.height);
    UIView *progressView1 =  [self setupProgressViewWithFrame:rect1 name:@"提交申请" description:@"财搜已收到您的专家申请"];
    [backView addSubview:progressView1];

    NSString *descriptionText2 = @"财搜正在耐心处理您的专家申请";
    CGRect rect2 = CGRectMake(lineView2.maxX+MARGIN_BIG, lineView2.y, SCREEN_WIDTH-lineView2.maxX-MARGIN_BIG*2, lineView2.height);
    UIView *progressView2 =  [self setupProgressViewWithFrame:rect2 name:@"处理中" description:descriptionText2];
    [backView addSubview:progressView2];
*/
}


- (UIView *)setupProgressViewWithFrame:(CGRect)frame
                              name:(NSString *)nameText
                           description:(NSString *)descriptionText{
    UIView *containerView = [[UIView alloc]initWithFrame:frame];
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(0, 0, containerView.width/2, 20) text:nameText textFont:FONT_NORMAL textColor:BLACKCOLOR];
    [containerView addSubview:nameLabel];

    UILabel *descriptionLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.maxY+MARGIN, containerView.width, 20) text:descriptionText textFont:FONT_SMALL textColor:GRAYCOLOR_TEXT];
    [containerView addSubview:descriptionLabel];

    NSDate *date = [NSDate date];
    NSString *timeStr = [date dateToString:@"yyyy-MM-dd HH:mm"];
    UILabel *timeLabel = [UILabel labelWithFrame:CGRectMake(containerView.width/2, 0, containerView.width/2, 20) text:timeStr textFont:FONT_SMALL textColor:GRAYCOLOR_TEXT_LIGHT];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:timeLabel];

    return containerView;
}



@end
