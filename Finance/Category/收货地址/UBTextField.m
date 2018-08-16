//
//  UBTextField.m
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import "UBTextField.h"

@implementation UBTextField

-(id)init
{
    self = [super init];
    if(self)
    {
        self.delegate = self;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.delegate = self;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.delegate = self;
    }
    return self;
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_textFieldShouldBeginEditing)
    {
        return _textFieldShouldBeginEditing(textField);
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_textFieldDidBeginEditing)
    {
        _textFieldDidBeginEditing(textField);
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(_textFieldShouldEndEditing)
    {
        _textFieldShouldEndEditing(textField);
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_textFieldDidEndEditing)
    {
        _textFieldDidEndEditing(textField);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_textFieldShouldChangeCharactersInRange)
    {
        return _textFieldShouldChangeCharactersInRange(textField,range,string);
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(_textFieldShouldClear)
    {
        _textFieldShouldClear(textField);
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_textFieldShouldReturn)
    {
        _textFieldShouldReturn(textField);
    }
    return NO;
}
@end
