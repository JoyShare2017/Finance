//
//  MyAskCell.m
//  Finance
//
//  Created by 郝旭珊 on 2018/1/31.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "MyAskCell.h"

@implementation MyAskCell

- (void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"circle_tick_orange"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"circle_empty"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


@end
