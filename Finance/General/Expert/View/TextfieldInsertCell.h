//
//  TextfieldInsertCell.h
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/17.
//  Copyright © 2017年 赵帅. All rights reserved.
//
/**************************************************************
 @header TextfieldInsertCell
 @version 1.0
 创建时间:2017年07月17日
 @author 赵帅
 @abstract 输入框的cell 有多种类型   依赖UBTextField ChooseYMDayView
 @discussion 
 变更历史:
 
 **************************************************************/
#import <UIKit/UIKit.h>

enum TEXTFIELDTYPE{

    TEXTFIELDTYPECOMMON=0,
    TEXTFIELDTYPENUMBER,
    TEXTFIELDTYPEMOBILE,
    TEXTFIELDTYPECANCLEAR,
    TEXTFIELDTYPEINSURE,
    TEXTFIELDTYPEDATE,


};


@interface TextfieldInsertCell : UITableViewCell
@property (nonatomic,strong) UILabel *starLable;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UITextField *subTextField;
@property (nonatomic,strong) UIImageView *rightImageView;

@property(nonatomic,assign)NSInteger insertType;

@property (nonatomic,strong) UIViewController *superVC;

@end
