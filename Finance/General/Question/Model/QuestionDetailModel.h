//
//  QuestionDetailModel.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/11.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhuanjiadayiModel.h"

@interface QuestionDetailModel : NSObject

@property (nonatomic , copy) NSString              * question_price;
@property (nonatomic , copy) NSString              * user_image;
@property (nonatomic , assign) NSInteger              answer_count;
@property (nonatomic , copy) NSString              * question_is_del;
@property (nonatomic , copy) NSString              * question_title;
@property (nonatomic , copy) NSString              *question_statu;
@property (nonatomic , copy) NSString              *question_describe;
@property (nonatomic , copy) NSString              * question_mode;
@property (nonatomic , copy) NSString              * question_addtime;
@property (nonatomic , copy) NSString              * user_nick_name;
@property (nonatomic , copy) NSString              * question_id;
@property (nonatomic , copy) NSString              * question_lable;
@property (nonatomic , copy) NSString              * count_read;
@property (nonatomic , copy) NSString              * question_user_id;
@property (nonatomic , assign) BOOL                collection_check;
@property (nonatomic , copy) NSArray               *question_images;

@property (nonatomic , strong)ZhuanjiadayiModel            *zhuanjiadayi;
@property (nonatomic , copy) NSArray               *xiangguanwenti;
@property (nonatomic , copy) NSArray               *xiangguantushu;


@end






