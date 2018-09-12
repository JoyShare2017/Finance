//
//  UBTextView.h
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

/*!
 @class         UBTextView
 @author        刘圣杰
 @version       1.0
 @discussion	UITextView的Block版本
 */
#import <UIKit/UIKit.h>


typedef BOOL(^TextViewShouldBeginEditing)(UITextView* textView);
typedef BOOL(^TextViewShouldEndEditing)(UITextView* textView);
typedef void(^TextViewDidBeginEditing)(UITextView* textView);
typedef void(^TextViewDidEndEditing)(UITextView* textView);
typedef BOOL(^TextViewShouldChangeTextInRange)(UITextView* textView,NSRange range,NSString * replacementText);
typedef void(^TextViewDidChange)(UITextView* textView);
typedef void(^TextViewDidChangeSelection)(UITextView* textView);
typedef BOOL(^TextViewShouldInteractWithURL)(UITextView* textView,NSURL* URL,NSRange characterRange);
typedef BOOL(^TextViewShouldInteractWithTextAttachment)(UITextView* textView,NSTextAttachment * textAttachment,NSRange characterRange);

@interface UBTextView : UITextView
<UITextViewDelegate>

@property (nonatomic,copy) TextViewShouldBeginEditing textViewShouldBeginEditing;
@property (nonatomic,copy) TextViewShouldEndEditing textViewShouldEndEditing;
@property (nonatomic,copy) TextViewDidBeginEditing textViewDidBeginEditing;
@property (nonatomic,copy) TextViewDidEndEditing textViewDidEndEditing;
@property (nonatomic,copy) TextViewShouldChangeTextInRange textViewShouldChangeTextInRange;
@property (nonatomic,copy) TextViewDidChange textViewDidChange;
@property (nonatomic,copy) TextViewDidChangeSelection textViewDidChangeSelection;
@property (nonatomic,copy) TextViewShouldInteractWithURL textViewShouldInteractWithURL;
@property (nonatomic,copy) TextViewShouldInteractWithTextAttachment textViewShouldInteractWithTextAttachment;

@end
