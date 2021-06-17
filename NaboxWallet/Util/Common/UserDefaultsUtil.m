//
//  UserDefaultsUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

/**
 *  保存到keystore数据
 *  @param  keystore   待保存的keystore数据
 */
+ (void)saveToAllKeyStore:(NSDictionary *)keystore
{
    if (!keystore) {
        return;
    }
    NSMutableArray *keystoreArr = [NSMutableArray arrayWithArray:[self getAllKeyStore]];
    NSDictionary *tempDict = [NSDictionary dictionary];
    for (NSDictionary *dict in keystoreArr) {
        if (dict.allKeys.count && [dict[@"address"] isEqualToString:keystore[@"address"]]) {
            tempDict = dict;
        }
    }
    if (tempDict.allKeys.count) {
        [keystoreArr removeObject:tempDict];
    }
    [keystoreArr insertObject:keystore atIndex:0];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_KEYSTORE];
    [userDefaults setObject:keystoreArr forKey:KEY_ALL_KEYSTORE];
    [userDefaults synchronize];
}

/**
 *  获取所有keystore数据
 *  @return  所有keystore数据
 */
+ (NSArray *)getAllKeyStore
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_KEYSTORE];
    id object = [userDefaults objectForKey:KEY_ALL_KEYSTORE];
    return object ? : nil;
}

/**
 *  保存当前钱包数据
 *  @param  walletDict   待保存的钱包数据
 */
+ (void)saveNowWallet:(NSDictionary *)walletDict
{
    if (!walletDict) {
        return;
    }
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_WALLET];
    [userDefaults setObject:walletDict forKey:KEY_NOW_WALLET];
    [userDefaults synchronize];
}

/**
 *  获取当前钱包数据
 *  @return  当前钱包数据
 */
+ (NSDictionary *)getNowWallet
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_WALLET];
    id object = [userDefaults objectForKey:KEY_NOW_WALLET];
    return object ? : nil;
}

/**
 *  保存到钱包数据
 *  @param  walletDict   待保存的钱包数据
 */
+ (void)saveToAllWallet:(NSDictionary *)walletDict
{
    if (!walletDict) {
        return;
    }
    NSMutableArray *walletArr = [NSMutableArray arrayWithArray:[self getAllWallet]];
    NSDictionary *tempDict = [NSDictionary dictionary];
    for (NSDictionary *dict in walletArr) {
        if (dict.allKeys.count && [dict[@"address"] isEqualToString:walletDict[@"address"]]) {
            tempDict = dict;
        }
    }
    if (tempDict.allKeys.count) {
        [walletArr removeObject:tempDict];
    }
    [walletArr insertObject:walletDict atIndex:0];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_WALLET];
    [userDefaults setObject:walletArr forKey:KEY_ALL_WALLET];
    [userDefaults synchronize];
}

/**
 *  获取所有钱包数据
 *  @return  所有钱包数据
 */
+ (NSArray *)getAllWallet
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_WALLET];
    id object = [userDefaults objectForKey:KEY_ALL_WALLET];
    return object ? : nil;
}

/**
 *  删除钱包数据
 *  @param  address   待删除的钱包地址
 */
+ (void)deleteWallet:(NSString *)address
{
    if (!address) {
        return;
    }
    NSDictionary *nowWalletDict = [self getNowWallet];
    NSMutableArray *walletArr = [NSMutableArray arrayWithArray:[self getAllWallet]];
    NSDictionary *tempDict = [NSDictionary dictionary];
    for (NSDictionary *dict in walletArr) {
        if (dict.allKeys.count && [dict[@"address"] isEqualToString:address]) {
            tempDict = dict;
        }
    }
    if (tempDict.allKeys.count) {
        [walletArr removeObject:tempDict];
    }
    if (nowWalletDict.allKeys.count && [nowWalletDict[@"address"] isEqualToString:address]) {
        if (walletArr.count) {
            [self saveNowWallet:[walletArr firstObject]];
        }else {
            [self saveNowWallet:[NSDictionary dictionary]];
        }
    }
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:KEY_WALLET];
    [userDefaults setObject:walletArr forKey:KEY_ALL_WALLET];
    [userDefaults synchronize];
}

/**
 *  保存公共数据
 *  @param  value   待保存的数据
 *  @param  key     待保存的键
 */
+ (void)saveValue:(id)value forKey:(NSString *)key
{
    if (!key.length || !value) {
        return;
    }
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass([self class])];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

/**
 *  获取保存的公共数据
 *  @param  key     待取数据的键
 *  @return 保存的数据
 */
+ (id)getValueWithKey:(NSString *)key
{
    if (!key.length) {
        return nil;
    }
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass([self class])];
    id object = [userDefaults objectForKey:key];
    return object ? : nil;
}

@end
