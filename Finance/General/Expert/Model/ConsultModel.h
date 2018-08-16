//
//  ConsultModel.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/15.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultModel : NSObject

@property (nonatomic , copy) NSString              * mes_unit;
@property (nonatomic , copy) NSString              * mes_price;
@property (nonatomic , copy) NSString              * mes_name,*mes_state;
@property (nonatomic , copy) NSString              * mes_es_id;
@property (nonatomic , copy) NSString              *mes_id;
//上面是专家详情里面用的

//下面的是申请专家的时候用的
@property (nonatomic) BOOL add_ok;
@property (nonatomic , copy) NSString* es_id,*es_price,*es_unit,*es_name;
@end
