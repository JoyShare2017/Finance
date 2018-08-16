//
//  TopicController.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/22.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicController : UIViewController
@property (nonatomic, copy) NSString *searchTag;
@property (nonatomic, copy) void (^finishedClickTopicAction)(NSString *topicId);
@end


@interface TopicModel: NSObject
@property (nonatomic , copy) NSString  * one_tag;
@property (nonatomic , copy) NSArray   * subject_list;
@end


@interface TopicTwoModel: NSObject
@property (nonatomic , copy) NSString   * two_tag;
@property (nonatomic , copy) NSArray    * subject_content;
@end


@interface TopicContentModel: NSObject
@property (nonatomic , copy) NSString   * subject_title;
@property (nonatomic , copy) NSString   * subject_id;
@end


