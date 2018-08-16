//
//  UBTableviewTool.h
//  KOFACS
//
//  Created by zhaoshuai on 16/9/2.
//  Copyright © 2016年  apple. All rights reserved.
//
/*!
 @class         UBTableviewTool
 @author        赵帅
 @version
 @discussion	uitableview工具类
 */
#import <UIKit/UIKit.h>

typedef NSInteger (^numberOfRowsInSection)(UITableView*tv,NSInteger section);
typedef NSInteger (^numberOfSections)(UITableView*tv);
typedef CGFloat (^HeightOfHeader)(UITableView*tv,NSInteger section);

typedef CGFloat (^heightForRow)(UITableView*tv,NSIndexPath*index);
typedef UITableViewCell* (^cellForRow)(UITableView*tv,NSIndexPath*indexPath);
typedef void (^selectRow)(UITableView*tv ,NSIndexPath*index);
typedef UIView* (^ViewOfHeader)(UITableView*tv,NSInteger section);

typedef NSString *(^TitleForHeaderInSection)(UITableView *tableView,NSInteger section);
typedef NSArray *(^SectionIndexTitlesForTableView)(UITableView *tableView);
typedef NSInteger (^SectionIndexTitle)(UITableView *tableView,NSString *title,NSInteger index);
@interface UBTableviewTool : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)numberOfRowsInSection numberOfRow;
@property(nonatomic,strong)heightForRow heightForRow;
@property(nonatomic,strong)cellForRow cellForRow;
@property(nonatomic,strong)selectRow selectRow;
@property(nonatomic,strong)numberOfSections numberOfSection;

@property(nonatomic,strong)HeightOfHeader heightHeader;
@property(nonatomic,strong)ViewOfHeader  viewHeader;
@property(nonatomic,strong)void(^scrollDidScroll)(UIScrollView *scrollView);

@property(nonatomic,strong)TitleForHeaderInSection  titleForHeaderInSection;
@property(nonatomic,strong)SectionIndexTitlesForTableView sectionIndexTitles;
@property(nonatomic,strong)SectionIndexTitle sectionIndexTitle;



@end
