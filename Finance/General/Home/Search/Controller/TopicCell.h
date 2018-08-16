//
//  TopicCell.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/30.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UITableViewCell

@property (nonatomic, copy) NSString *lableText;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGFloat cellHeight;

@end
