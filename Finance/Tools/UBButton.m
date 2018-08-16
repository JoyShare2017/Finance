//
//  UBButton.m
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import "UBButton.h"

@implementation UBButton

-(void)addAction:(TouchUp)touchUp
{
    _action = touchUp;
    [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClicked:(UBButton*) button
{
    if(_action)
    {
        _action(button);
    }
}
-(void)setHighlighted:(BOOL)highlighted{}

@end
