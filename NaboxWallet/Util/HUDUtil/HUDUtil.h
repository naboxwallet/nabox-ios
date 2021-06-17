//
//  HUDUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDUtil : NSObject

/**
 *  显示加载，不允许用户交互
 */
+ (void)showHUD;
+ (void)showHUDWithMessage:(NSString *)message;

/**
 *  显示加载，允许用户交互
 */
+ (void)showNoneHUD;
+ (void)showNoneHUDWithMessage:(NSString *)message;

/**
 *  显示进度，不允许用户交互
 */
+ (void)showProgressHUD:(float)progress;
+ (void)showProgressHUD:(float)progress message:(NSString *)message;

/**
 *  修改HUD显示内容
 */
+ (void)setHUDMessage:(NSString *)message;

/*
 *  多状态显示提示信息、显示后自动消失
 */
+ (void)showInfoWithHUD:(NSString *)message;
+ (void)showSuccessWithHUD:(NSString *)message;
+ (void)showFailedWithHUD:(NSString *)message;

/**
 *  隐藏
 */
+ (void)hideHUD;

@end
