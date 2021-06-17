//
//  TouchIDUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TouchIDUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define TouchIDData @"TouchIDData"

@interface TouchIDUtil ()
@property (nonatomic, copy) TouchIDBlock block;
@property (nonatomic, assign) BOOL showVerify;
@end

@implementation TouchIDUtil

+ (TouchIDUtil *)shareTouchIDUtil
{
    static TouchIDUtil *touchIDUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchIDUtil = [[TouchIDUtil alloc] init];
    });
    return touchIDUtil;
}

- (void)saveEvaluatedPolicyDomainState:(NSData *)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:TouchIDData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSData *)getEvaluatedPolicyDomainState
{
    NSData *evaluatedPolicyDomainState = [[NSUserDefaults standardUserDefaults] objectForKey:TouchIDData];
    return evaluatedPolicyDomainState ? evaluatedPolicyDomainState : nil;
}

/// 开启指纹扫描的函数
- (void)openTouchID:(TouchIDBlock)block {
    self.block = block;
    [self openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics touchIDBlock:block];
    
}

/// 开启指纹扫描的函数 是否显示验证登录密码
- (void)openTouchID:(TouchIDBlock)block showVerify:(BOOL)showVerify
{
    self.block = block;
    self.showVerify = showVerify;
    [self openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics touchIDBlock:block];
}

/// 验证指纹
- (BOOL)canEvaluate
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL can = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (!can) {
        return NO;
    }
    if (@available(iOS 9.0, *)) {
        NSData *data = [self getEvaluatedPolicyDomainState];
        if (data && ![context.evaluatedPolicyDomainState isEqualToData:data]) {
            return NO;
        }
    }
    return YES;
}

/// 开启指纹扫描
- (void)openTouchIDWithPolicy:(LAPolicy )policy touchIDBlock:(TouchIDBlock)block {
    LAContext *context = [[LAContext alloc] init];
    if (self.showVerify) {
        context.localizedFallbackTitle = @"请验证登录密码";//
    }else {
        context.localizedFallbackTitle = @"";//
    }
    WS(weakSelf);
    NSString *reason = @"请验证指纹";
    if (iPhoneX) {
        reason = @"请验证人脸";
    }
    [context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError * _Nullable error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *message = @"";
             if (success) {
                 message = @"指纹验证成功！";
                 if (iPhoneX) {
                     message = @"人脸验证成功！";
                 }
                 block(YES, NO, message);
                 [weakSelf saveEvaluatedPolicyDomainState:context.evaluatedPolicyDomainState];
             } else {
                 //失败操作
                 LAError errorCode = error.code;
                 BOOL inputPassword = NO;
                 switch (errorCode) {
                     case LAErrorAuthenticationFailed: {
                         // -1
                         message = @"连续指纹识别错误！";
                     }
                         break;
                         
                     case LAErrorUserCancel: {
                         // -2
                         // message = @"用户取消验证";
                     }
                         break;
                         
                     case LAErrorUserFallback: {
                         // -3
                         inputPassword = YES;
                         message = @"用户选择输入密码！";
                     }
                         break;
                         
                     case LAErrorSystemCancel: {
                         // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                         message = @"已取消验证！";
                     }
                         break;
                         
                     case LAErrorPasscodeNotSet: {
                         // -5
                         message = @"设备系统未设置密码！";
                     }
                         break;
                         
                     case LAErrorTouchIDNotAvailable: {
                         // -6
                         message = @"此设备不支持TouchID或者FaceID！";
                     }
                         break;
                         
                     case LAErrorTouchIDNotEnrolled: {
                         // -7
                         message = @"用户未录入指纹！";
                     }
                         break;
                         
                     case LAErrorTouchIDLockout: {
                         // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                         // if (iOS9) {
                         //  [weakSelf openTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication touchIDBlock:block];
                         //  }
                         message = @"您需要先关闭一次本机屏幕再重新操作！";
                     }
                         break;
                         //
                         //                    case LAErrorAppCancel: {
                         //                        // -9 如突然来了电话，电话应用进入前台，APP被挂起啦
                         //                        message = @"用户不能控制情况下APP被挂起";
                         //                    }
                         //                        break;
                         //
                     case LAErrorInvalidContext: {
                         // -10
                         message = @"TouchID失效！";
                     }
                         break;
                         
                     default:
                         break;
                 }
                 NSLog(@"指纹识别:%@",message);
                 block(success, inputPassword, message);
             }
         });
     }];
}


@end
