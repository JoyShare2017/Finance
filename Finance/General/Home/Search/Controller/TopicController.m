//
//  TopicController.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/22.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "TopicController.h"

#define leftView_width 100

@interface TopicController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *leftView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *littleLine;
@property (nonatomic, strong) NSMutableArray *tagList;

@end

@implementation TopicController

- (NSMutableArray *)tagList{
    if (_tagList == nil){
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}


- (UIButton *)selectedButton{
    if (_selectedButton == nil){
        _selectedButton = [UIButton new];
    }
    return _selectedButton;
}


- (UIScrollView *)leftView{
    if (_leftView == nil){
        _leftView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, leftView_width, USEABLE_VIEW_HEIGHT)];
        _leftView.backgroundColor = GRAYCOLOR_BACKGROUND;
    }
    return _leftView;
}


- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(leftView_width,0, SCREEN_WIDTH-leftView_width, USEABLE_VIEW_HEIGHT-SWITCH_BUTTON_VIEW_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}


- (UIView *)littleLine{
    if (_littleLine == nil){
        _littleLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 30)];
        _littleLine.backgroundColor = MAJORCOLOR;
    }
    return _littleLine;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.leftView];
    [self.view addSubview:self.tableView];

    [self loadTags];
}


#pragma mark - 界面

- (void)addLeftCategory{
    CGFloat btnH = 60;
    for (int i=0;i<self.tagList.count;i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnH*i, leftView_width, btnH)];
        TopicModel *model = self.tagList[i];
        [btn setTitle:model.one_tag forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_NORMAL;
        [btn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [btn setTitleColor:MAJORCOLOR forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(chooseTopicFirstCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftView addSubview:btn];
        [self.leftView addSubview:self.littleLine];
        btn.tag = i;

        if (i==0){
            btn.selected = YES;
            self.selectedButton = btn;
            self.littleLine.y = btn.y+(btn.height-self.littleLine.height)/2;
        }
    }
}


- (void)chooseTopicFirstCategory:(UIButton *)sender{
    self.littleLine.y = sender.y+(sender.height-self.littleLine.height)/2;
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    sender.selected = YES;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tagList.count > 0){
        TopicModel *oneTag = self.tagList[self.selectedButton.tag];
        return oneTag.subject_list.count;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TopicModel *oneTag = self.tagList[self.selectedButton.tag];
    TopicTwoModel *twoTag = oneTag.subject_list[section];

    UILabel *label = [UILabel labelWithFirstIndent:MARGIN frame:CGRectMake(MARGIN, MARGIN_BIG, tableView.width-MARGIN*2, 35) text:twoTag.two_tag textFont:FONT_BIG textColor:BLACKCOLOR backgroundColor:GRAYCOLOR_BACKGROUND];
    return label;

}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TopicModel *oneTag = self.tagList[self.selectedButton.tag];
    TopicTwoModel *twoTag = oneTag.subject_list[section];
    return twoTag.subject_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TopicModel *oneTag = self.tagList[self.selectedButton.tag];
    TopicTwoModel *twoTag = oneTag.subject_list[indexPath.section];
    TopicContentModel *content = twoTag.subject_content[indexPath.row];

    cell.textLabel.text = content.subject_title;
    cell.textLabel.font = FONT_SMALL;
    cell.textLabel.textColor = BLACKCOLOR;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel *oneTag = self.tagList[self.selectedButton.tag];
    TopicTwoModel *twoTag = oneTag.subject_list[indexPath.section];
    TopicContentModel *content = twoTag.subject_content[indexPath.row];
    NSString *tagId = content.subject_id;
    //传递点击事件
    if (self.finishedClickTopicAction){
        self.finishedClickTopicAction(tagId);
    }

}



#pragma mark - Network

- (void)loadTags{
    [self showHudInView:self.view];
     /*
      接口：index/subject_tag
      参数：
      @param  string  search_name     搜索专题关键字
      */
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/subject_tag"];
    NSString *searchText = self.searchTag ? self.searchTag : @"";
    NSDictionary *parameter = @{@"search_name":searchText};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        [self hideHud];
        if (resultCode != NetworkResultSuceess){
            [self showHint:(NSString *)responseObject];
            return;
        }

        NSArray *array;
        if ([responseObject isKindOfClass:[NSDictionary class]]){
//            array = responseObject[@"data_list"];
//            NSString *searchCount = responseObject[@"search_count"];
//            if (self.finishedSearchQuestion){
//                self.finishedSearchQuestion(searchCount);
//            }
        }else{
            array = (NSArray *)responseObject;
        }

        for (NSDictionary *dict in array){
            TopicModel *model = [TopicModel mj_objectWithKeyValues:dict];
            [self.tagList addObject:model];
        }

        [self addLeftCategory];
        [self.tableView reloadData];

    }];
}

@end



@implementation TopicModel

//模型嵌套模型
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subject_list": @"TopicTwoModel"};
}

@end


@implementation TopicTwoModel

//模型嵌套模型
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subject_content": @"TopicContentModel"};
}

@end


@implementation TopicContentModel

@end

