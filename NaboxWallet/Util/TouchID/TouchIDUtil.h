//
//  TouchIDUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchIDBlock)(BOOL success, BOOL inputPassword, NSString *message);

@interface TouchIDUtil : NSObject

//- (instancetype)init NS_UNAVAILABLE;
//+ (instancetype)new NS_UNAVAILABLE;

+ (TouchIDUtil *)shareTouchIDUtil;

//存储指纹库数据
- (void)saveEvaluatedPolicyDomainState:(NSData *)data;
//获取指纹库数据
- (NSData *)getEvaluatedPolicyDomainState;

/// 开启指纹扫描的函数
- (void)openTouchID:(TouchIDBlock)block;
/// 开启指纹扫描的函数 是否显示验证登录密码
- (void)openTouchID:(TouchIDBlock)block showVerify:(BOOL)showVerify;

//获取是否支持指纹
- (BOOL)canEvaluate;

@end

NS_ASSUME_NONNULL_END
