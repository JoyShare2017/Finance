//
//  HeadAndNameCell.h
//  Finance
//
//  Created by 赵帅 on 2018/4/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadAndNameCell : UITableViewCell
@property (nonatomic, strong) UBButton *headBtn,*loginBtn,*exitBtn;
@property (nonatomic, strong) UILabel *nameLb,*qianminglb;
@property (nonatomic, strong) UIViewController *superVc;

@end
