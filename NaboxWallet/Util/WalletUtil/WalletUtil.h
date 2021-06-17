//
//  WalletUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaSecurity.h"
#import "BTCKey.h"
#import "BTCData.h"
#import "BTCBase58.h"
#import "NYMnemonic.h"
#import "BTCKeychain.h"
#import "BTCNetwork.h"
#import <CBSecp256k1.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CreateAddressBlock)(NSDictionary * addressDict);
/** 钱包工具类 */
@interface WalletUtil : NSObject

/**
 生成助记词
 
 @return words 生成的助记词（数组类型）
 */
+ (NSArray *)getMnemonic;

/**
 生成助记词
 
 @return words 生成的助记词（字符串类型）
 */
+ (NSString *)getMnemonicStr;

/**
 根据助记词生成私钥
 
 @param mnemonic 助记词（空格分割的字符串）
 @return value   由助记词生成的私钥（16进制数据类型）
 */
+ (NSString *)getPrivateKeyWithMnemonic:(NSString *)mnemonic;

/**
 根据私钥生成公钥
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的公钥（16进制数据类型）
 */
+ (NSString *)getPublicKeyWithPrivateKey:(NSString *)privateKey;

/**
 根据私钥生成公钥
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的公钥（NSData数据类型）
 */
+ (NSData *)getPublicKeyDataWithPrivateKey:(NSString *)privateKey;

/**
 根据私钥生成钱包地址
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的地址
 */
+ (NSString *)getAddressWithPrivateKe:(NSString *)privateKey;


/**
 根据私钥生成钱包地址集合
 
 @param privateKey 私钥（16进制数据类型）
 */
+ (void )getAddressDictWithPrivateKey:(NSString *)privateKey Callback:(CreateAddressBlock)block;

/**
 进行私钥加密
 
 @param privateKey 私钥（16进制数据类型）
 @param password   密码（字符串类型）
 @return value     由加密后的密码当秘钥，私钥当value进行AES加密的结果
 */
+ (NSString *)encryptPrivateKey:(NSString *)privateKey password:(NSString *)password;

/**
 进行私钥解密
 
 @param encryptPrivateKey 加密后私钥（16进制数据类型）
 @param password          密码（字符串类型）
 @return value            由加密后的密码当秘钥，对加密后的私钥进行AES解密结果
 */
+ (NSString *)decryptPrivateKey:(NSString *)encryptPrivateKey password:(NSString *)password;

/**
 进行助记词加密
 
 @param mnemonic   助记词
 @param password   密码（字符串类型）
 @return value     由加密后的密码当秘钥，助记词当value进行AES加密的结果
 */
+ (NSString *)encryptMnemonic:(NSString *)mnemonic password:(NSString *)password;

/**
 进行助记词解密
 
 @param encryptMnemonic   加密后助记词
 @param password          密码（字符串类型）
 @return value            由加密后的密码当秘钥，对加密后的助记词进行AES解密结果
 */
+ (NSString *)decryptMnemonic:(NSString *)encryptMnemonic password:(NSString *)password;




@end

NS_ASSUME_NONNULL_END
