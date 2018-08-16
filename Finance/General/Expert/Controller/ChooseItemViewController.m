//
//  ChooseItemViewController.m
//  PrivacyManager
//
//  Created by 赵帅 on 2017/7/19.
//  Copyright © 2017年 赵帅. All rights reserved.
//

#import "ChooseItemViewController.h"

@interface ChooseItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseItemViewController
{
    int _tempNum;
    NSMutableArray*modelNameArr;//已经选择的item的name
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *upButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = upButton;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:0.4f];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (self.num>self.typeSelectedArr.count) {
        _tempNum=self.num-(int)self.typeSelectedArr.count;

    }else{
        _num=(int)self.typeSelectedArr.count;
        _tempNum=0;

    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SubChooseModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.model_name;
    if ([model.model_name hasPrefix:@"微信"]) {
        cell.imageView.image=[UIImage imageNamed:@"wx"];
    }else if ([model.model_name hasPrefix:@"支付宝"]){
        cell.imageView.image=[UIImage imageNamed:@"zfb"];
    }
    if ([modelNameArr containsObject:model.model_name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubChooseModel*clickTheModel=[self.dataArray objectAtIndex:indexPath.row];
    
    
    if (self.num<=1) {
        //单选
        if (self.selectTheseItems) {
            self.selectTheseItems([NSMutableArray arrayWithObject:clickTheModel]);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        
        
        //多选
        
        BOOL isContaining=NO;
        
        for (SubChooseModel*tempModel in self.typeSelectedArr) {
            
            if ([tempModel.model_name isEqualToString:clickTheModel.model_name]) {
                isContaining=YES;
               
                    _tempNum ++;
                    [self.typeSelectedArr removeObject:tempModel];
                    [modelNameArr removeObject:clickTheModel.model_name];
               
                
                break;
            }
            
        }
        
        if (!isContaining) {
             if (_tempNum>=1) {
                    _tempNum --;
                    [self.typeSelectedArr addObject:clickTheModel];
                    [modelNameArr addObject:clickTheModel.model_name];

            }else{
               
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多只能选择%zd个",_num] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //及时回到主线程防止延迟
                    [self presentViewController:alertController animated:YES completion:^{
                        
                    }];
                });
               
                
                
                

            }
        }
        

         [_tableView reloadData];
        
        
        }
    
    
}

-(void)confirm{

    if (self.selectTheseItems) {
        self.selectTheseItems(self.typeSelectedArr);
    }
    [self.navigationController popViewControllerAnimated:YES];

}



-(void)setTypeSelectedArr:(NSMutableArray *)typeSelectedArr{

    _typeSelectedArr=typeSelectedArr;
    
    modelNameArr=[NSMutableArray array];
    for (SubChooseModel*mmm in _typeSelectedArr) {
        [modelNameArr addObject:mmm.model_name];
    }

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
