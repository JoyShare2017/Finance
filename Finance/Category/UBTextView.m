//
//  UBTextView.m
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import "UBTextView.h"

@implementation UBTextView

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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(_textViewShouldBeginEditing)
    {
        return _textViewShouldBeginEditing(textView);
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(_textViewShouldEndEditing)
    {
        return _textViewShouldEndEditing(textView);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(_textViewDidBeginEditing)
    {
        _textViewDidBeginEditing(textView);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(_textViewDidEndEditing)
    {
         _textViewDidEndEditing(textView);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(_textViewShouldChangeTextInRange)
    {
        return _textViewShouldChangeTextInRange(textView,range,text);
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(_textViewDidChange)
    {
        _textViewDidChange(textView);
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if(_textViewDidChangeSelection)
    {
        _textViewDidChangeSelection(textView);
    }
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if(_textViewShouldInteractWithURL)
    {
        return _textViewShouldInteractWithURL(textView,URL,characterRange);
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    if(_textViewShouldInteractWithTextAttachment)
    {
        return _textViewShouldInteractWithTextAttachment(textView,textAttachment,characterRange);
    }
    return YES;
}




@end
