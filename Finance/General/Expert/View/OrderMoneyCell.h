//
//  OrderMoneyCell.h
//  Finance
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMoneyCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLable;
//@property(nonatomic,copy)NSString* money;
-(void)updateCount:(NSInteger)count andMoney:(NSString*)money;
@end
