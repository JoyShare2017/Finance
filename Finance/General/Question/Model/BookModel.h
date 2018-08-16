//
//  BookModel.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/12.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (nonatomic , copy) NSString  * book_user_id;
@property (nonatomic , copy) NSString  * book_describe;
@property (nonatomic , copy) NSString  * book_addtime;
@property (nonatomic , copy) NSString  * book_id;
@property (nonatomic , copy) NSString  * book_author;
@property (nonatomic , copy) NSString  * book_cover_image;
@property (nonatomic , copy) NSString  * book_question_tag;
@property (nonatomic , copy) NSString  * book_title;
@property (nonatomic , copy) NSString  * book_price;

@property(nonatomic)BOOL collection_check;//是否收藏

@property(nonatomic)BOOL isEditSelected;//用于编辑模式下是否选中
@end
