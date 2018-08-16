//
//  MyHeadCell.h
//  Finance
//
//  Created by 赵帅 on 2018/4/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadCell : UITableViewCell
@property (nonatomic, strong) UILabel *itemLb;
@property (nonatomic, strong) UBButton *headbtn;
@property (nonatomic, strong) UIViewController *superVc;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, copy) void (^getTheHeadImgUrl)(NSString * imgUrl);

@end
