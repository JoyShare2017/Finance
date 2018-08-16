//
//  RegionParserTool.m
//  MyKomastu2
//
//  Created by 赵帅 on 16/11/23.
//  Copyright © 2016年 lsj. All rights reserved.
//

#import "RegionParserTool.h"
#import "Country.h"
#import "City.h"
#import "Province.h"

@interface RegionParserTool ()<NSXMLParserDelegate>
@property (nonatomic,strong)Country* county;
@property (nonatomic,strong)City* city;
@property (nonatomic,strong)Province* province;
@end


@implementation RegionParserTool
-(void)beginToParseRegionXmlWithRegionName:(NSString*)regionName andComplete:(void (^)(id regionArr))complete{

    NSString *documentPath = [[NSBundle mainBundle]pathForResource:@"region.xml" ofType:@""];;
    
    NSData *xmlData2;
    NSData *data = [[NSData alloc] initWithContentsOfFile:documentPath];
    if(data.length!=0)//存在
    {
        xmlData2=data;
    }
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData2];
    self.xmlParser.delegate = self;
    if( [self.xmlParser parse] )
    {

        complete(self.provinceArr);
    }
    else
    {
        complete(nil);
    }




}



#pragma mark - XMLPraser

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.keyString = nil;
    self.xmlString = nil;
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.keyString = nil;
    self.xmlString = nil;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
    
    if ([elementName isEqualToString:@"root"])
    {
        self.provinceArr = [NSMutableArray array];
    }
    
    if ([elementName isEqualToString:@"province"])
    {
        _province = [[Province alloc]init];
    }
    else if([elementName isEqualToString:@"city"])
    {
        _city = [[City alloc]init];
    }
    else if([elementName isEqualToString:@"county"])
    {
        _county = [[Country alloc]init];
    }
   
    
    self.xmlString = nil;
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
   
    if ([elementName isEqualToString:@"province"])
    {
        
        [self.provinceArr addObject:_province];
        _province = nil;
    }
    else if([elementName isEqualToString:@"city"])
    {
        [_province.citys addObject:_city];
        _city = nil;
    }
    else if([elementName isEqualToString:@"county"])
    {
        [_city.countrys addObject:_county];
        _county = nil;
    }
    else if([elementName isEqualToString:@"id"])
    {
        if(_county)
        {
            _county.id_self = [self.xmlString intValue];
        }
        else
        {
            if(_city)
            {
                _city.id_self = [self.xmlString intValue];
            }
            else
            {
                if(_province)
                {
                    _province.id_self = [self.xmlString intValue];
                }
            }
        }
    }
    else if([elementName isEqualToString:@"name"])
    {
        if(_county)
        {
            _county.name = self.xmlString;
        }
        else
        {
            if(_city)
            {
                _city.name = self.xmlString;
            }
            else
            {
                if(_province)
                {
                    _province.name = self.xmlString;
                }
            }
        }
    }
    
    self.xmlString = nil;
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if(self.xmlString == nil )
    {
        self.xmlString = [[NSMutableString alloc] init];
        [self.xmlString appendString:string];
    }
    else
    {
        [self.xmlString appendString:string];
    }
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}

@end
