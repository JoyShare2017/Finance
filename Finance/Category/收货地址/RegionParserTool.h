//
//  RegionParserTool.h
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionParserTool : NSObject
@property(nonatomic,strong)NSXMLParser*xmlParser;
@property(nonatomic,strong)NSMutableString *keyString;
@property(nonatomic,strong)NSMutableString *xmlString;
@property(nonatomic,strong)NSMutableArray *provinceArr ,*cityArr ,*contyArr;

-(void)beginToParseRegionXmlWithRegionName:(NSString*)regionName andComplete:(void (^)(id regionArr))complete;



@end
