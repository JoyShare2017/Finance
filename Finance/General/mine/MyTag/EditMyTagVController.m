//
//  EditMyTagVController.m
//  Finance
//
//  Created by 赵帅 on 2018/4/10.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "EditMyTagVController.h"
#import "MyCollectionViewCell.h"
#import "ChannelButton.h"
#import "TagBigModel.h"
#import "TagSmallModel.h"
#import "CollectionReusableSectionView.h"
@interface EditMyTagVController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView*myChannelView,*allChannelView;
@property(nonatomic,strong)UICollectionView*myColl;
@property(nonatomic,strong)NSMutableArray*AllChannelArr;
@property(nonatomic,strong)NSMutableArray*selectedChannelArr;

@end

@implementation EditMyTagVController
{
    UICollectionViewFlowLayout*layOut;
}
NSString*cellName=@"Cell";
NSString*HeaderID=@"Header";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"标签管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.view.backgroundColor=[UIColor whiteColor];
    if (!self.selectedChannelArr) {
        self.selectedChannelArr=[NSMutableArray arrayWithArray:self.oldChannelArr];
    }
     [self layOutMyChannelViews];

    self.AllChannelArr =[NSMutableArray array];
    [self makeUI];
    [self getMyTagsIsOnlyMine:NO];
}
-(void)save:(UIBarButtonItem*)btnItem{
    NSMutableArray *idArray = [NSMutableArray array];
    for (TagSmallModel*ex in self.selectedChannelArr) {
            [idArray addObject:ex.qt_id];
    }
    if (idArray.count<=0) {
        [self showHint:@"请选择标签"];
        return;
    }
    if (self.hidMyTagPart) {
        if (self.changeedTheTags) {
            self.changeedTheTags(self.selectedChannelArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    NSString *idsStr = [idArray componentsJoinedByString:@","];
    [self showHudInView:self.view hint:@"正在保存...."];
    [KCommonNetRequest addQuetionTagWithTag:idsStr andComplete:^(BOOL success, id obj) {
        if (success) {
            [self showHint:@"保存成功"];
            if (self.changeedTheTags) {
                self.changeedTheTags(self.selectedChannelArr);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:(NSString*)obj];
        }
    }];
}
-(void)layOutMyChannelViews{
    if (self.hidMyTagPart) {
        return;
    }
    for (id obj in self.myChannelView.subviews) {

        if ([obj isKindOfClass:[ChannelButton class]]) {
            ChannelButton*cb=(ChannelButton*)obj;
            [cb removeFromSuperview];

        }
    }


    __weak typeof(self) weakSelf = self;

    if (!_myChannelView) {

        _myChannelView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 100)];
        _myChannelView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_myChannelView];

        UILabel * myLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        myLb.text = @"我的标签";
        myLb.font = [UIFont systemFontOfSize:16];
        myLb.textColor = MAJORCOLOR;
        [_myChannelView addSubview:myLb];

        //刚一进来已选或者未选频道状态



    }


    CGFloat btnWidth =(_myChannelView.frame.size.width-20)/3;
    for (int i=0; i<_selectedChannelArr.count; i++) {
        TagSmallModel*chn=_selectedChannelArr[i];
        ChannelButton*chanBtn=[[ChannelButton alloc]initWithFrame:CGRectMake((i%3)*(btnWidth+10), 40+40*(i/3),btnWidth , 30)];
        [chanBtn setTitle:chn.qt_name forState:(UIControlStateNormal)];
        chanBtn.tag=i;
        chanBtn.channel_id=[chn.qt_id integerValue];
        chanBtn.closeBtn.tag=chanBtn.channel_id;
        chanBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_myChannelView addSubview:chanBtn];
        [chanBtn addAction:^(UBButton *button) {
            
//
//            [weakSelf.selectedChannelArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//
//                if ([((TagSmallModel*)obj).qt_id integerValue]==((ChannelButton*)button).channel_id) {
//                    NSString*markTheId=((TagSmallModel*)obj).qt_id;
//                    *stop = YES;
//
//                    if (*stop == YES) {
//
//                        [weakSelf.selectedChannelArr removeObject:obj];
//
//                    }
//
//                }
//
//                [weakSelf layOutMyChannelViews];
//                //遍历总数组
//
//                for (TagBigModel*big in self.AllChannelArr) {
//                    for (TagSmallModel*small in big.tag_list) {
//                        if ([small.qt_id isEqualToString:markTheId]) {
//                            small.hasSelected=NO;
//                            [weakSelf.myColl reloadData];
//                            return;
//                        }
//                    }
//                }
//
//            }];
            
            
            NSMutableArray*tempArr=[NSMutableArray arrayWithArray:weakSelf.selectedChannelArr];
            //定义一个一模一样的数组，便利数组A然后操作数组B 防止一边遍历一遍操作同一个数组崩溃
            
            for (TagSmallModel*delMod in tempArr) {
                if ([delMod.qt_id integerValue]==((ChannelButton*)button).channel_id) {
                    NSString*markTheId=delMod.qt_id;
                    [weakSelf.selectedChannelArr removeObject:delMod];
                    [weakSelf layOutMyChannelViews];
                    //遍历总数组

                    for (TagBigModel*big in self.AllChannelArr) {
                        for (TagSmallModel*small in big.tag_list) {
                            if ([small.qt_id isEqualToString:markTheId]) {
                                small.hasSelected=NO;
                                [weakSelf.myColl reloadData];
                                return;
                            }
                        }
                    }


                }
            }
        }];
    }

    CGRect rec = _myChannelView.frame;
    rec.size.height=30+ 40*( _selectedChannelArr.count/3) + (_selectedChannelArr.count%3>0?40:0);
    _myChannelView.frame=rec;

    _allChannelView.frame=CGRectMake(0, CGRectGetMaxY(_myChannelView.frame)+30, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_myChannelView.frame)-30-NAVGATION_MAXY-HOME_HEIGHT);
    _myColl.frame=CGRectMake(0, 40, SCREEN_WIDTH, _allChannelView.frame.size.height-40);


}


-(void)makeUI{

    //所有频道view
    _allChannelView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_myChannelView.frame)+30, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_myChannelView.frame)-30-NAVGATION_MAXY-HOME_HEIGHT)];
    [_allChannelView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_allChannelView];

    UILabel * myLb2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    myLb2.text = @"标签分类";
    myLb2.font = [UIFont systemFontOfSize:16];
    myLb2.textColor = MAJORCOLOR;
    [_allChannelView addSubview:myLb2];

    // 注册头部

    layOut=[[UICollectionViewFlowLayout alloc]init];
    layOut.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.minimumLineSpacing=10;
    layOut.headerReferenceSize=CGSizeMake(180, 30);
    self.myColl=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, _allChannelView.frame.size.width, _allChannelView.frame.size.height-40) collectionViewLayout:layOut];
    self.myColl.delegate=self;
    self.myColl.dataSource=self;
    self.myColl.backgroundColor=[UIColor clearColor];

    [self.myColl registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:cellName];
    [self.myColl registerClass:[CollectionReusableSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    layOut.headerReferenceSize = CGSizeMake(180, 30);
    [_allChannelView addSubview:self.myColl];



}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(180, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{


    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
     TagBigModel*thebig=self.AllChannelArr[indexPath.section];
        CollectionReusableSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID forIndexPath:indexPath];
        headerView.lb.text=thebig.tag_type;
        return headerView;

    }
    return nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.AllChannelArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TagBigModel*thebig=self.AllChannelArr[section];
    return thebig.tag_list.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagBigModel*big=self.AllChannelArr[indexPath.section];
    TagSmallModel*small=big.tag_list[indexPath.row];
    MyCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    cell.channelName=small.qt_name;
    cell.label.font=[UIFont systemFontOfSize:14];
    cell.label.textColor=small.hasSelected?[UIColor lightGrayColor]:[UIColor darkGrayColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagBigModel*big=self.AllChannelArr[indexPath.section];
    TagSmallModel*small=big.tag_list[indexPath.row];
    CGFloat height =[NSString heightWithString:small.qt_name size:CGSizeMake(self.myColl.frame.size.width-30, 100) font:14];
    return CGSizeMake(self.myColl.frame.size.width-30, height>30?height:30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    TagBigModel*big=self.AllChannelArr[indexPath.section];
    TagSmallModel*small=big.tag_list[indexPath.row];
    
    if (small.hasSelected==NO) {
        NSInteger maxCount=self.hidMyTagPart?3:9;
        if (self.selectedChannelArr.count>=maxCount) {
            [self showHint:[NSString stringWithFormat:@"最多选择%zd个标签",maxCount]];
        }else{

            [self.selectedChannelArr addObject:small];
            small.hasSelected=YES;
            [self.myColl reloadData];
            [self  layOutMyChannelViews];
        }
    }else{
        if (self.hidMyTagPart) {//隐藏上面的部分后需要点击 collection 上的标签取消

                for (TagSmallModel*ss in self.selectedChannelArr) {
                    if ([small.qt_id isEqualToString:ss.qt_id]) {
                        small.hasSelected=NO;
                        [self.selectedChannelArr removeObject:ss];
                        [self.myColl reloadData];
                        [self  layOutMyChannelViews];
                        break;
                    }
                }

        }
    }


}

-(void)getMyTagsIsOnlyMine:(BOOL)onlyMyine{
    [self showHudInView:self.view hint:@""];
    [KCommonNetRequest getQuetionTagWithIsMytag:onlyMyine andComplete:^(NetworkResult resultCode, id obj) {

        [self hideHud];
        if (resultCode==NetworkResultSuceess) {
            for (NSDictionary *dict in obj){

                if (onlyMyine) {
                    TagSmallModel *model = [TagSmallModel mj_objectWithKeyValues:dict];
                    [self.selectedChannelArr addObject:model];
                }else{
                    TagBigModel *model = [TagBigModel mj_objectWithKeyValues:dict];
                    [self.AllChannelArr addObject:model];
                    //已经选择的在总的列表里做标记
                    for (TagSmallModel*small in model.tag_list) {
                        for (TagSmallModel*oldsmall in self.selectedChannelArr) {
                            if ([small.qt_id isEqualToString:oldsmall.qt_id]) {
                                small.hasSelected=YES;
                            }
                        }
                    }

                }
            }

            [self.myColl reloadData];
        }
    }];

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
