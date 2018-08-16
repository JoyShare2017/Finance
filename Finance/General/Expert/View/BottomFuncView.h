//
//  BottomFuncView.h
//  CarRepairExpert
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 emof. All rights reserved.
//  底部功能view

#import <UIKit/UIKit.h>
 enum FUNCKTYPE{
    FUNC_MONEYAGREEREFUSE=0,
    FUNC_AGREEREFUSE,
    FUNC_AGREED,
    FUNC_REFUSED,
    FUNC_GOTOFACTORYCHECK,//专家到场检验
    FUNC_GOTOFACTORYRECORD,  //专家的到场记录
    FUNC_GOTOFACTORYSAMEORNOT,  //专家的到场记录查看一致不一致
    FUNC_EDITYANSHOUDAN,  //监理查看上下架照片 填写验收单
    FUNC_JUNGONGDANHEGEORNOT //监理填写竣工单选择合格或者不合格
};


@interface BottomFuncView : UIView
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *price;
@property (nonatomic, strong) void (^clickRefuse)(NSString*reason);
@property (nonatomic, strong) void (^clickAgree)(id obj);


//专家 意见详情用
@property(nonatomic,copy)NSString *realPrice;

@property (nonatomic, strong) void (^clickGofactoryCheck)(id obj);

@property (nonatomic, strong) void (^clickGofactoryRecord)(id obj);


@end
