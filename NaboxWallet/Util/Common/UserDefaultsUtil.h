//
//  UserDefaultsUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsUtil : NSObject

/**
 *  保存到keystore数据
 *  @param  keystore   待保存的keystore数据
 */
+ (void)saveToAllKeyStore:(NSDictionary *)keystore;

/**
 *  获取所有keystore数据
 *  @return  所有keystore数据
 */
+ (NSArray *)getAllKeyStore;

/**
 *  保存当前钱包数据
 *  @param  walletDict   待保存的钱包数据
 */
+ (void)saveNowWallet:(NSDictionary *)walletDict;

/**
 *  获取当前钱包数据
 *  @return  当前钱包数据
 */
+ (NSDictionary *)getNowWallet;


/**
 *  保存到钱包数据
 *  @param  walletDict   待保存的钱包数据
 */
+ (void)saveToAllWallet:(NSDictionary *)walletDict;

/**
 *  获取所有钱包数据
 *  @return  所有钱包数据
 */
+ (NSArray *)getAllWallet;

/**
 *  删除钱包数据
 *  @param  address   待删除的钱包地址
 */
+ (void)deleteWallet:(NSString *)address;

/**
 *  保存公共数据
 *  @param  value   待保存的数据
 *  @param  key     待保存的键
 */
+ (void)saveValue:(id)value forKey:(NSString *)key;

/**
 *  获取保存的公共数据
 *  @param  key     待取数据的键
 *  @return 保存的公共数据
 */
+ (id)getValueWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
