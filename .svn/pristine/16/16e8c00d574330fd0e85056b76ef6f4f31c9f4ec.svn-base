//
//  drawLineView.m
//  Finance
//
//  Created by 郝旭珊 on 2018/2/2.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import "DrawLineView.h"

@implementation DrawLineView

- (void)drawRect:(CGRect)rect {

    self.backgroundColor = WHITECOLOR;
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 233/255.0, 137/255.0, 14/255.0, 1);


    if (self.isStroke){
        CGContextSetRGBStrokeColor(context, 233/255.0, 137/255.0, 14/255.0, 0);
    }else if (self.darwIndex==1){
        CGContextSetRGBStrokeColor(context, 233/255.0, 137/255.0, 14/255.0, 1);
    }else{
        CGContextSetRGBStrokeColor(context, 199/255.0, 199/255.0, 199/255.0, 1);
    }
    CGPoint aPoints0[2];//坐标点
    aPoints0[0] =CGPointMake(5, 0);//坐标1
    aPoints0[1] =CGPointMake(5, 25);//坐标2
    CGContextAddLines(context, aPoints0, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径


    CGContextAddArc(context, 5, 30, 5, 0, 2*M_PI, 0); //添加一个圆 改变参数3可以改变它的y原点

    if (self.isStroke){
        //填充颜色
        CGContextSetFillColorWithColor(context, MAJORCOLOR.CGColor);
        CGContextDrawPath(context, kCGPathFill);//绘制填充
    }else{
        CGContextSetLineWidth(context, 1.0);//线的宽度
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    }
//
//
//    /*画线及孤线*/
//    //画线
//    //233 137 14
    if (self.isStroke){
        CGContextSetRGBStrokeColor(context, 233/255.0, 137/255.0, 14/255.0, 1);
    }else{
        CGContextSetRGBStrokeColor(context, 199/255.0, 199/255.0, 199/255.0, 1);
    }
    CGPoint aPoints[2];//坐标点
    aPoints[0] =CGPointMake(5, 35);//坐标1
    aPoints[1] =CGPointMake(5, rect.size.height);//坐标2
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

}


@end
