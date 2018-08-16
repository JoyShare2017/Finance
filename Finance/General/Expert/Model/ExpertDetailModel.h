//
//  ExpertDetailModel.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/15.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsultModel.h"

@interface ExpertDetailModel : NSObject

@property (nonatomic , copy) NSArray     * expert_server;

@property (nonatomic , copy) NSString  * expert_phone;
@property (nonatomic , copy) NSString  * expert_addtime;
@property (nonatomic , copy) NSString  * expert_lingyu,*expert_lingyu_value;
@property (nonatomic , copy) NSString  * expert_jianjie;
@property (nonatomic , copy) NSString  * expert_user_id;
@property (nonatomic , copy) NSString  * expert_dengji,*expert_dengji_value;
@property (nonatomic , copy) NSString  * expert_yaoqingma;
@property (nonatomic , copy) NSString  * expert_img_zhengshu;
@property (nonatomic , copy) NSString  * follow_count;
@property (nonatomic , copy) NSString  * expert_progress_msg;
@property (nonatomic , copy) NSString  * expert_full_name;
@property (nonatomic , copy) NSString  * expert_hangye,*expert_hangye_value;
@property (nonatomic , copy) NSString  * expert_city;
@property (nonatomic , copy) NSString  * expert_zhuanye;
@property (nonatomic , copy) NSString  * expert_images;
@property (nonatomic , copy) NSString  * baozhang;
@property (nonatomic , assign) BOOL  follow_ok;
@property (nonatomic , copy) NSString  * expert_renzhijigou;
@property (nonatomic , copy) NSString  * expert_zhiwei;
@property (nonatomic , copy) NSString  * expert_id_card;
@property (nonatomic , copy) NSString  * expert_id;
@property (nonatomic , copy) NSString  * expert_progress;//成为专家的进度：1：等待审核、2：驳回申请、99：审核完成（已经是专家）



@end
