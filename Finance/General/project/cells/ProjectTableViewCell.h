//
//  ProjectTableViewCell.h
//  Finance
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIView *poloView;
@property (strong, nonatomic)  UBLabel *nameLabel;
@property(nonatomic,copy)NSString* title;
@end
