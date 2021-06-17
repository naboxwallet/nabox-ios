//
//  HUDUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "HUDUtil.h"
#import "SVProgressHUD.h"

@implementation HUDUtil

/**
 *  显示加载，不允许用户交互
 */
+ (void)showHUD
{
    [SVProgressHUD showWithStatus:KLocalizedString(@"loading")];
    [self setCustomStyleAndSetCanTouch:NO];
}

+ (void)showHUDWithMessage:(NSString *)message;
{
    [SVProgressHUD showWithStatus:message];
    [self setCustomStyleAndSetCanTouch:NO];
}

/**
 *  自定义样式并设置是否允许用户交互
 */
+ (void)setCustomStyleAndSetCanTouch:(BOOL)canTouch
{
    [SVProgressHUD setRingThickness:4];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setForegroundColor:KColorPrimary];
    [SVProgressHUD setDefaultMaskType:canTouch ? SVProgressHUDMaskTypeNone : SVProgressHUDMaskTypeClear];
}

/**
 *  显示加载，允许用户交互
 */
+ (void)showNoneHUD
{
    [SVProgressHUD show];
    [self setCustomStyleAndSetCanTouch:YES];
}

+ (void)showNoneHUDWithMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];
    [self setCustomStyleAndSetCanTouch:YES];
}

/**
 *  显示进度，不允许用户交互
 */
+ (void)showProgressHUD:(float)progress
{
    [SVProgressHUD showProgress:progress];
    [self setCustomStyleAndSetCanTouch:NO];
}

+ (void)showProgressHUD:(float)progress message:(NSString *)message
{
    [SVProgressHUD showProgress:progress status:message];
    [self setCustomStyleAndSetCanTouch:NO];
}

/**
 *  修改HUD显示内容
 */
+ (void)setHUDMessage:(NSString *)message
{
    [SVProgressHUD setStatus:message];
}

/*
 *  多状态显示提示信息、显示后自动消失
 */
+ (void)showInfoWithHUD:(NSString *)message
{
    [SVProgressHUD showInfoWithStatus:message];
    [self setCustomStyleAndSetCanTouch:NO];
}

+ (void)showSuccessWithHUD:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
    [self setCustomStyleAndSetCanTouch:NO];
}

+ (void)showFailedWithHUD:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
    [self setCustomStyleAndSetCanTouch:NO];
}

/**
 *  隐藏
 */
+ (void)hideHUD
{
    [SVProgressHUD dismiss];
}

@end
