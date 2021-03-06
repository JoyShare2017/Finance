//
//  KCommonNetRequest.m
//  Finance
//
//  Created by 赵帅 on 2018/4/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "KCommonNetRequest.h"
#import "ExpertDetailModel.h"//专家信息
#import "TimelineModel.h"
#import "ConsultModel.h"
@implementation KCommonNetRequest
/**
 * 查询个人资料
 **/
+(void) getMyInfoDetailAndComplete:(void(^)(BOOL success ,id obj)) complete{
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (user.user_id.length<=0) {
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/get_member_info"];
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode == NetworkResultSuceess){
            [UserAccountManager sharedManager].userAccount = [UserAccount mj_objectWithKeyValues:responseObject];
            [[UserAccountManager sharedManager] saveAccount];
        }
    }];

}
+(void)addMemberFollowWithExpertID:(NSString*)expertId andComplete:(NetworkcompleteCallback) complete{
    if (!expertId) {
        complete(NO,@"用户不存在");
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/add_member_follow"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"user_expert_id":expertId
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}
+(void)deleteMemberFollowWithExpertID:(NSString*)expertId andComplete:(NetworkcompleteCallback) complete{
    if (!expertId) {
        complete(NO,@"用户不存在");
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_follow_del"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"user_expert_id":expertId
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}
+(void)deleteSubjectFollowWithQuestion_id:(NSString*)question_id andComplete:(void(^)(BOOL success ,id obj)) complete{
    if (!question_id) {
        complete(NO,@"问题不存在");
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_question_del"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"question_id":question_id
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}
/**
 * 收藏或者删除收藏的专题 isFollow yes收藏 no删除
 **/
+(void)followOrDeleteSubjectFollowWithSubject_id:(NSString*)subject_id andISFollow:(BOOL)isFollow andComplete:(void(^)(BOOL success ,id obj)) complete{
    if (!subject_id) {
        complete(NO,@"专题不存在");
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_subject_del"];//删除
    if (isFollow) {
        urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_subject"];//收藏
    }
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"subject_id":subject_id
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}
+(void)deleteSubjectFollowWithBook_id:(NSString*)book_id andISFollow:(BOOL)isFollow andComplete:(void(^)(BOOL success ,id obj)) complete{
    if (!book_id) {
        complete(NO,@"图书不存在");
        return;
    }
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_book_del"];
    if (isFollow) {
         urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_collection_book"];
    }
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{@"user_id":@([user.user_id integerValue]),
                                @"user_name":user.user_name,
                                @"book_id":book_id
                                };
    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}
/**
 * 十七、我的问题标签
 **/
+(void)getQuetionTagWithIsMytag:(BOOL)isMyTag andComplete:(void(^)(NetworkResult resultCode ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/member_question_tag"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter = @{};
    if (isMyTag) {
        parameter=@{
                    @"user_name":user.user_name,
                    @"user_id":user.user_id
                    };
    }

    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        if (resultCode != NetworkResultSuceess){
            complete(resultCode,responseObject);
//            return;
//
//        }else{
//            complete(YES,responseObject);
//        }

    }];
}
/**
 * 十七、添加我的问题标签
 **/
+(void)addQuetionTagWithTag:(NSString*)tag andComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/add_member_question_tag"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    NSDictionary *parameter =@{
                    @"user_name":user.user_name,
                    @"user_id":user.user_id,
                    @"question_tag":tag
                    };


    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
            return;

        }else{
            complete(YES,@"");
        }

    }];
}

/**
 * 十七、一、专题标签&&专题文章列表
 **/
+(void)getSubjectTagWithSearchName:(NSString*)name andComplete:(void(^)(NetworkResult resultCode ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/subject_tag"];

    NSDictionary *parameter =@{
                               @"search_name":name
                           };


    [[NetworkManager sharedManager]request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {
//        if (resultCode != NetworkResultSuceess){
            complete(resultCode,responseObject);
//            return;
//
//        }else{
//            complete(YES,responseObject);
//        }

    }];
}
/**
 * 查询专家信息（包括自己的）expertId传 nil 指的是查询自己专家状态
 **/
+(void)getExpertInfoWithExpertId:(NSString*)expertId andComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"index/expert_info"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!expertId) {expertId=user.user_id;}//user x
    if (!user) { user=[[UserAccount alloc]init];}
    NSDictionary *parameter = @{
                                @"expert_user_id":@([expertId integerValue]),
                                @"user_id":user.user_id,
                                @"user_name":user.user_name};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            ExpertDetailModel *model = [ExpertDetailModel mj_objectWithKeyValues:responseObject];
            complete(YES,model);
        }
    }];

}

/**
 * 查询申请专家的时间轴
 **/
+(void)getExpertProgressStateAndComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/expert_progress_state"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!user) { user=[[UserAccount alloc]init];}
    NSDictionary *parameter = @{@"user_id":user.user_id,
                                @"user_name":user.user_name};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            NSMutableArray*arr=[NSMutableArray array];
            for (NSDictionary*dic in responseObject[@"expert_state"]) {
               TimelineModel *model = [TimelineModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            complete(YES,arr);
        }
    }];
}
/**
 * 查询专家可选服务列表
 **/
+(void)getExpertServerListAndComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/expert_server_list"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!user) { user=[[UserAccount alloc]init];}
    NSDictionary *parameter = @{@"user_id":user.user_id,@"user_name":user.user_name};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            NSMutableArray*arr=[NSMutableArray array];
            for (NSDictionary*dic in responseObject) {
                ConsultModel *model = [ConsultModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            complete(YES,arr);
        }
    }];
}
/**
 * 检查版本
 **/
+(void)checkBanbenAndComplete:(void(^)(BOOL success ,id obj)) complete{
NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/check_banben_ios"];
    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:nil callback:^(NetworkResult resultCode, id responseObject) {
        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            if ([responseObject[@"banbenhao"] compare:KSOFTVERSION options:NSNumericSearch] ==NSOrderedDescending) {
                complete(YES,responseObject);
            }else{
                complete(NO,@"");
            }
        }

    }];

}





/**
 * 专家服务状态切换 自动判断
 **/
+(void)switchExpertServerWithServerId:(NSString*)serverId andComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/expert_server_switch"];
    UserAccount *user = [UserAccountManager sharedManager].userAccount;
    if (!serverId) {complete(NO,@"服务异常");}
    if (!user) { user=[[UserAccount alloc]init];}
    NSDictionary *parameter = @{
                                @"expert_server_id":@([serverId integerValue]),
                                @"user_id":user.user_id,
                                @"user_name":user.user_name};

    [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:parameter callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            complete(YES,responseObject);
        }
    }];

}
/**
 * 客服信息
 **/
+(void)getServiceNumberAndComplete:(void(^)(BOOL success ,id obj)) complete{
    NSString *urlStr = [OPENAPIHOST stringByAppendingString:@"member/index/service_telephone_numbers"];
       [[NetworkManager sharedManager] request:POST URLString:urlStr parameters:nil callback:^(NetworkResult resultCode, id responseObject) {

        if (resultCode != NetworkResultSuceess){
            complete(NO,responseObject);
        }else{
            complete(YES,responseObject);
        }
    }];

}
@end
