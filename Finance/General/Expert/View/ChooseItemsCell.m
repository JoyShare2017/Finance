//
//  ChooseItemsCell.m
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/19.
//  Copyright © 2017年 赵帅. All rights reserved.
//

#import "ChooseItemsCell.h"
#import "SubChooseModel.h"
#import "ChooseItemViewController.h"
#define kTITELFONT 15

@implementation ChooseItemsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {//添加展示控件
        
        [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        
//        _starLable = [[UILabel alloc]init];
//        _starLable.text = @"*";
//        _starLable.textColor = [UIColor redColor];
//        _starLable.font = [UIFont systemFontOfSize:kTITELFONT];
//        [self.contentView addSubview:_starLable];
        
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = [UIFont systemFontOfSize:kTITELFONT];
        [self.contentView addSubview:_titleLable];
        
//        _starLable.frame = CGRectMake(15, 0, 10, self.frame.size.height);
        _titleLable.frame = CGRectMake(15, 0, ([UIScreen mainScreen].bounds.size.width-40)/3, self.bounds.size.height);

        _theDetail=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLable.frame), 0, self.frame.size.width-CGRectGetMaxX(_titleLable.frame)-30, self.frame.size.height)];
        _theDetail.font = [UIFont systemFontOfSize:kTITELFONT];
        _theDetail.textColor=[UIColor grayColor];
        [_theDetail setTextAlignment:(NSTextAlignmentRight)];
        _theDetail.userInteractionEnabled=YES;
        [self.contentView addSubview:_theDetail];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMe)];
        [_theDetail addGestureRecognizer:tap];
        
        self.typeSelectedArr=[NSMutableArray array];
        
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray=dataArray;
    if (_dataArray.count>0) {
        SubChooseModel*th=_dataArray.firstObject;
        _theDetail.text=th.model_name;
        
    }
}

- (void)tapMe{

    
        ChooseItemViewController*choose=[ChooseItemViewController new];
        choose.num=self.num;
        choose.dataArray=self.dataArray;
        choose.typeSelectedArr=self.typeSelectedArr;
        choose.selectTheseItems = ^(NSMutableArray *items) {
            _typeSelectedArr=items;

            NSString*names=@"";
            for (SubChooseModel*the in items) {
                names=[names stringByAppendingString:the.model_name];
            }
            self.theDetail.text=names;
            if (self.selectTheseItemsInCell) {
                self.selectTheseItemsInCell(items);
            }
        };
        [self.superVC.navigationController pushViewController:choose animated:YES];
    
    
}



-(void)setTypeSelectedArr:(NSMutableArray *)typeSelectedArr{

    _typeSelectedArr=typeSelectedArr;

}



@end
