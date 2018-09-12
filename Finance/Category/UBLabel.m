//
//  UBLabel.m
//  KOFACS
//
//  Created by  apple on 16/6/6.
//  Copyright © 2016年  apple. All rights reserved.
//

#import "UBLabel.h"

@implementation UBLabel
-(void)addAction:(TapUp)touchUp
{
    self.userInteractionEnabled = YES;
    _action = touchUp;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
    [self addGestureRecognizer:tap];
}

-(void)tapLabel:(UBLabel*) button
{
    if(_action)
    {
        _action(button);
    }
}
@end
