//
//  KCommonNetRequest.h
//  Finance
//
//  Created by 赵帅 on 2018/4/9.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCommonNetRequest : NSObject
typedef void(^NetworkcompleteCallback)(BOOL success ,id obj);
/**
 * 查询个人资料
 **/
+(void) getMyInfoDetailAndComplete:(void(^)(BOOL success ,id obj)) complete;
/*
 十三、添加我的关注 — 关注的是专家
 接口：member/index/add_member_follow
 参数：
 @param  int        user_id                * 用户的id
 @param  string    user_name            * 用户名
 @param  int        user_expert_id        * 专家的id
 示例：*/
+(void)addMemberFollowWithExpertID:(NSString*)expertId andComplete:(NetworkcompleteCallback) complete;
/*
 十三、删除我的关注
 接口：member/index/member_follow_del
 参数：
 @param  int        user_id                * 用户的id
 @param  string    user_name            * 用户名
 @param  string    user_expert_id        * 专家id（多个逗号分隔）
*/
+(void)deleteMemberFollowWithExpertID:(NSString*)expertId andComplete:(NetworkcompleteCallback) complete;
/**
 * 删除收藏的问题
 **/
+(void)deleteSubjectFollowWithQuestion_id:(NSString*)question_id andComplete:(void(^)(BOOL success ,id obj)) complete;


/**
 * 收藏或者删除收藏的专题 isFollow yes收藏 no删除
**/
+(void)followOrDeleteSubjectFollowWithSubject_id:(NSString*)subject_id andISFollow:(BOOL)isFollow andComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 收藏或者删除收藏图书 isFollow yes收藏 no删除
 **/
+(void)deleteSubjectFollowWithBook_id:(NSString*)book_id andISFollow:(BOOL)isFollow andComplete:(void(^)(BOOL success ,id obj)) complete;

/**
 * 十七、我的问题标签
 **/
+(void)getQuetionTagWithIsMytag:(BOOL)isMyTag andComplete:(void(^)(NetworkResult resultCode ,id obj)) complete;
/**
 * 十七、添加我的问题标签
 **/
+(void)addQuetionTagWithTag:(NSString*)tag andComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 十七、一、专题标签&&专题文章列表
 **/
+(void)getSubjectTagWithSearchName:(NSString*)name andComplete:(void(^)(NetworkResult resultCode ,id obj)) complete;
/**
 * 查询专家信息（包括自己的）
 **/
+(void)getExpertInfoWithExpertId:(NSString*)expertId andComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 查询申请专家的时间轴
 **/
+(void)getExpertProgressStateAndComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 查询专家可选服务列表
 **/
+(void)getExpertServerListAndComplete:(void(^)(BOOL success ,id obj)) complete;

/**
 * 检查版本
 **/
+(void)checkBanbenAndComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 专家服务状态切换 自动判断
 **/
+(void)switchExpertServerWithServerId:(NSString*)serverId andComplete:(void(^)(BOOL success ,id obj)) complete;
/**
 * 客服信息
 **/
+(void)getServiceNumberAndComplete:(void(^)(BOOL success ,id obj)) complete;
@end
