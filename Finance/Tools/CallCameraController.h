//
//  CallCameraController.h
//  Finance
//
//  Created by 郝旭珊 on 2018/1/16.
//  Copyright © 2018年 郝旭珊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallCameraController : UIViewController
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) NSMutableArray *photos;
- (void)uploadImageSuccess:(void(^)(NSArray *))finishedUploadImage;
@end
