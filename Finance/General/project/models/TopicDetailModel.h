//
//  TopicDetailModel.h
//  Finance
//
//  Created by 赵帅 on 2018/5/18.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDetailModel : NSObject
@property (nonatomic , assign) BOOL   follow_ok;
@property (nonatomic , copy) NSString   * subject_title;
@property (nonatomic , copy) NSString   * subject_content_shicao;
@property (nonatomic , copy) NSString   * subject_content_anli;
@property (nonatomic , copy) NSString   * subject_content_gainian;
@end
