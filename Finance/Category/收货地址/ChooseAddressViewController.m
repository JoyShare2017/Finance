//
//  ChooseAddressViewController.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "RegionParserTool.h"
#import "Province.h"
#import "City.h"
#import "Country.h"

@interface ChooseAddressViewController ()
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)UBTableviewTool*tableviewRegion;

@property(nonatomic,strong)Province*selectProvince;
@property(nonatomic,strong)City*selectity;
@property(nonatomic,strong)Country*selectCounty;

@property(nonatomic,assign)int hasSelected;//1 省  2 市 3 县



@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    self.title=@"地区";
    self.automaticallyAdjustsScrollViewInsets = NO;
    RegionParserTool * tool =[RegionParserTool new];
    [tool beginToParseRegionXmlWithRegionName:@"" andComplete:^(id regionArr) {
        if (regionArr) {
           self.dataArr = regionArr;
           self.hasSelected=1;
           [self makeUI];
            
        }
        
    }];
    
}


-(void)makeUI{
    _tableviewRegion=[[UBTableviewTool alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVGATION_MAXY)style:UITableViewStyleGrouped];
   
    [self.view addSubview:_tableviewRegion];
    __weak typeof(self) weakSelf = self;
    _tableviewRegion.numberOfRow=^NSInteger(UITableView*tv,NSInteger section){
    
        return weakSelf.dataArr.count;
    
    };
    
    _tableviewRegion.heightHeader = ^CGFloat(UITableView *tv, NSInteger section) {
        return 0.1f;
    };
    
    
    _tableviewRegion.cellForRow=^UITableViewCell*(UITableView*tv,NSIndexPath*indexPath){
    
    static NSString * cellId=@"regioncell";
        
        UITableViewCell*cell =[tv dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        
        if (weakSelf.hasSelected==3) {
            [cell setAccessoryType:(UITableViewCellAccessoryNone)];
        }else{
            if (weakSelf.hasSelected == 2) {
                City *city = ((City*)weakSelf.dataArr[indexPath.row]);
                
                if (city.countrys.count == 0) {
                    [cell setAccessoryType:(UITableViewCellAccessoryNone)];
                }
                else{
                   [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
                }

            }
            else{
               [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            }
            

        }
        
        if (weakSelf.hasSelected ==1) {
            NSString *cellTextName = ((Province*)weakSelf.dataArr[indexPath.row]).name;
            if ([cellTextName isEqualToString:@"内蒙古"]||
                [cellTextName isEqualToString:@"西藏"]) {
                cellTextName = [[[NSMutableString alloc]initWithString:cellTextName]stringByAppendingString:@"自治区"];
            }
            if ([cellTextName isEqualToString:@"新疆"]
                ) {
                cellTextName = [[[NSMutableString alloc]initWithString:cellTextName]stringByAppendingString:@"维吾尔自治区"];
            }
            if ([cellTextName isEqualToString:@"宁夏"]) {
                cellTextName = [[[NSMutableString alloc]initWithString:cellTextName]stringByAppendingString:@"回族自治区"];
            }
            if ([cellTextName isEqualToString:@"广西省"]) {
                cellTextName = [[[[NSMutableString alloc]initWithString:cellTextName] substringToIndex:2]stringByAppendingString:@"壮族自治区"];
            }
            if ([cellTextName isEqualToString:@"香港"]||
                [cellTextName isEqualToString:@"澳门"]) {
                cellTextName = [[[NSMutableString alloc]initWithString:cellTextName]stringByAppendingString:@"特别行政区"];
            }
            cell.textLabel.text = cellTextName;
        }else if (weakSelf.hasSelected ==2) {
            cell.textLabel.text=((City*)weakSelf.dataArr[indexPath.row]).name;
        }else if (weakSelf.hasSelected ==3) {
            cell.textLabel.text=((Country*)weakSelf.dataArr[indexPath.row]).name;
        }
       
        
        
        return cell;
    
    };
    
    _tableviewRegion.selectRow = ^(UITableView*tv ,NSIndexPath*index){
    
        if (weakSelf.hasSelected ==1) {
            weakSelf.selectProvince = weakSelf.dataArr[index.row];
            weakSelf.dataArr = weakSelf.selectProvince.citys;
            [weakSelf.tableviewRegion reloadData];
            weakSelf.hasSelected =2;
        }else  if (weakSelf.hasSelected ==2) {
            weakSelf.selectity = weakSelf.dataArr[index.row];
            weakSelf.dataArr = weakSelf.selectity.countrys;
            //有的地区没有县区  需要判断一下
            if (weakSelf.dataArr.count>0) {
                [weakSelf.tableviewRegion reloadData];
                weakSelf.hasSelected =3;
            }else{
                if (weakSelf.SelectTheRegion) {
                    weakSelf.SelectTheRegion(weakSelf.selectProvince,weakSelf.selectity,weakSelf.selectCounty);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            
            }
           
            

        }else if (weakSelf.hasSelected ==3) {
            weakSelf.selectCounty = weakSelf.dataArr[index.row];
            if (weakSelf.SelectTheRegion) {
                weakSelf.SelectTheRegion(weakSelf.selectProvince,weakSelf.selectity,weakSelf.selectCounty);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
           
        }
        
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
