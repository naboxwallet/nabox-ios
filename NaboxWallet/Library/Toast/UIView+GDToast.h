//
//  UIView+GDToast.h
//  Admin
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

typedef enum : NSUInteger {
    GDToastShowTypeNormal = 1,//正常提示
    GDToastShowTypeSuccess,   //成功提示
    GDToastShowTypeWarning,   //警告提示
    GDToastShowTypeFail,      //失败提示
} GDToastShowType;

@interface UIView (GDToast)

/**
 快速显示吐司，默认3秒，正常提示
 @param message   消息内容
 */
- (void)showNormalToast:(NSString *)message;

/**
 @param message   消息内容
 @param duration  时长
 @param type      显示类型
 */
- (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
             type:(GDToastShowType)type;

@end
