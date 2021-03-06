//
//  UBTableviewTool.m
//  KOFACS
//
//  Created by zhaoshuai on 16/9/2.
//  Copyright © 2016年  apple. All rights reserved.
//

#import "UBTableviewTool.h"
@implementation UBTableviewTool

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if (self) {
        self.delegate=self;
        self.dataSource=self;
        
    }
     return  self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.numberOfSection) {
        return 1;
    }
    return  self.numberOfSection(tableView);


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.heightHeader) {
     return    self.heightHeader(tableView,section);
    }else
        return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.numberOfRow) {
     return    self.numberOfRow(tableView,section);
    }else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.viewHeader) {
        return self.viewHeader(tableView,section);
    }else
        return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.heightForRow) {
        return self.heightForRow(tableView,indexPath);
    }else
        return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellForRow) {
       return  self.cellForRow(tableView,indexPath);
    }else
        return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectRow) {
        self.selectRow(tableView,indexPath);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollDidScroll) {
        _scrollDidScroll(scrollView);
    }
}
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.titleForHeaderInSection) {
        self.titleForHeaderInSection(tableView, section);
    }
    return nil;
}

//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
   
    if (self.sectionIndexTitles) {
        self.sectionIndexTitles(tableView);
    }
    return nil;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.sectionIndexTitle) {
        self.sectionIndexTitle(tableView, title, index);
    }
    return 0;
}

@end
