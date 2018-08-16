//
//  UBTextField.h
//  KUK
//
//  Created by  apple on 15/8/1.
//  Copyright (c) 2015年  apple. All rights reserved.
//

/*!
 @class         UBTextField
 @author        刘圣杰
 @version       1.0
 @discussion	UITextField的Block版本
 */
#import <UIKit/UIKit.h>


typedef BOOL(^TextFieldShouldBeginEditing)(UITextField* textField);
typedef void(^TextFieldDidBeginEditing)(UITextField* textField);
typedef BOOL(^TextFieldShouldEndEditing)(UITextField* textField);
typedef void(^TextFieldDidEndEditing)(UITextField* textField);
typedef BOOL(^TextFieldShouldChangeCharactersInRange)(UITextField* textField,NSRange range,NSString* replacementString);
typedef BOOL(^TextFieldShouldClear)(UITextField* textField);
typedef BOOL(^TextFieldShouldReturn)(UITextField* textField);

@interface UBTextField : UITextField
<UITextFieldDelegate>

@property (nonatomic,copy) TextFieldShouldBeginEditing textFieldShouldBeginEditing;
@property (nonatomic,copy) TextFieldDidBeginEditing textFieldDidBeginEditing;
@property (nonatomic,copy) TextFieldShouldEndEditing textFieldShouldEndEditing;
@property (nonatomic,copy) TextFieldDidEndEditing textFieldDidEndEditing;
@property (nonatomic,copy) TextFieldShouldChangeCharactersInRange textFieldShouldChangeCharactersInRange;
@property (nonatomic,copy) TextFieldShouldClear textFieldShouldClear;
@property (nonatomic,copy) TextFieldShouldReturn textFieldShouldReturn;

@end
