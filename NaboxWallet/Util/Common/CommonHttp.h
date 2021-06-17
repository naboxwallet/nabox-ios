//
//  CommonHttp.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NulsBalanceModel.h"

typedef void(^NulsBalanceBlock)(NulsBalanceModel * _Nullable balanceModel,NSArray * _Nullable walletArr);

NS_ASSUME_NONNULL_BEGIN

/** 公共请求类 */
@interface CommonHttp : NSObject

//单例
+ (instancetype)sharedInstance;

/**
 查询钱包余额
 isAll:YES(查询所有钱包余额)，NO（查询当前选择钱包余额）
 balanceBlock:回调
 */
- (void)getNulsBalanceWithIsAll:(BOOL)isAll balanceBlock:(NulsBalanceBlock)balanceBlock;
/**
 查询自定义钱包余额
 address:自定义钱包余额
 isAll:对外默认都传NO
 balanceBlock:回调
 */
- (void)getNulsBalanceWithAddress:(NSString *)address isAll:(BOOL)isAll balanceBlock:(NulsBalanceBlock)balanceBlock;

/**
 获取账户信息
 address: 地址
 accountBlock:回调
 */
- (void)getNulsAccountWithAddress:(NSString *)address accountBlock:(ResponseDataBlock)accountBlock;

@end

NS_ASSUME_NONNULL_END
