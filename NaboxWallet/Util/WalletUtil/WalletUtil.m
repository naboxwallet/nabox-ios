//
//  WalletUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletUtil.h"
#import "SyncWalletWithDeviceModel.h"
#import "PKWeb3Objc.h"
#import "CVETHWallet.h"
#import "rlp.h"
#import "CVBTCWallet.h"
@implementation WalletUtil

/**
 生成助记词
 
 @return words 生成的助记词（数组类型）
 */
+ (NSArray *)getMnemonic
{
    NSString *mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    if (![mnemonic isHaveValue]) {
        return nil;
    }
    NSArray *words = [mnemonic componentsSeparatedByString:@" "];
    return words;
}

/**
 生成助记词
 
 @return words 生成的助记词（字符串类型）
 */
+ (NSString *)getMnemonicStr
{
    NSString *mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    if (![mnemonic isHaveValue]) {
        return @"";
    }
    return mnemonic;
}

/**
 根据助记词生成私钥
 
 @param mnemonic 助记词（空格分割的字符串）
 @return value   由助记词生成的私钥（16进制数据类型）
 */
+ (NSString *)getPrivateKeyWithMnemonic:(NSString *)mnemonic
{
    if (![mnemonic isHaveValue]) {
        return nil;
    }
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:nil
                                                                  language:@"english"];
    NSData *seedData = [seed ny_dataFromHexString];
    BTCKeychain *keyChain = [[BTCKeychain alloc] initWithSeed:seedData network:[BTCNetwork testnet]];
    return [keyChain.key.privateKey ny_hexString];
}

/**
 根据私钥生成公钥
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的公钥（16进制数据类型）
 */
+ (NSString *)getPublicKeyWithPrivateKey:(NSString *)privateKey
{
    if (![privateKey isHaveValue]) {
        return nil;
    }
    BTCKey *bt =  [[BTCKey alloc] initWithPrivateKey:[privateKey ny_dataFromHexString]];
    return   [bt.compressedPublicKey ny_hexString];
}

/**
 根据私钥生成公钥
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的公钥（NSData数据类型）
 */
+ (NSData *)getPublicKeyDataWithPrivateKey:(NSString *)privateKey
{
    if (![privateKey isHaveValue]) {
        return nil;
    }
    BTCKey *bt =  [[BTCKey alloc] initWithPrivateKey:[privateKey ny_dataFromHexString]];
    return bt.compressedPublicKey;
}

/**
 根据私钥生成所有钱包地址
 @param privateKey 私钥（16进制数据类型）
 */

+(void)getAddressDictWithPrivateKey:(NSString *)privateKey Callback:(CreateAddressBlock)block{
    NSString *Nuls = [self getAddressWithPrivateKe:privateKey];
    NSString *Nerve = [self getNerveAddressWithPrivateKe:privateKey];
    PKWeb3Objc *web3 = [PKWeb3Objc sharedInstance];
    NSString *Ethereum = [web3.eth.accounts privateKeyToAccount:privateKey];
    // 生成地址后需要同步账户才可以生效
    NSDictionary *addressDict = @{@"NULS":Nuls,@"NERVE":Nerve,@"Ethereum":Ethereum,@"BSC":Ethereum,@"Heco":Ethereum,@"OKExChain":Ethereum};
    DLog(@"生成地址%@",addressDict);
    NSMutableArray *addressList = [NSMutableArray new];
    for (NSString *chain in [addressDict allKeys]) {
        NSDictionary *dict = @{@"chain":chain,@"address":[addressDict objectForKey:chain]};
        [addressList addObject:dict];
    }
    SyncWalletWithDeviceModel *syncModel = [SyncWalletWithDeviceModel new];
    syncModel.addressList = addressList;
    BTCKey *bt =  [[BTCKey alloc] initWithPrivateKey:[privateKey ny_dataFromHexString]];
    syncModel.pubKey = [bt.compressedPublicKey ny_hexString];
    DLog(@"同步钱包入参%@",[syncModel mj_keyValues]);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_SYNC dataModel:syncModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        DLog(@"同步钱包返回%@",dataObj);
        block(addressDict); // 不管是否同步成功都要返回地址集合
    }];
}

/**
 根据私钥生成nuls钱包地址
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的地址
 */
+ (NSString *)getAddressWithPrivateKe:(NSString *)privateKey
{
    if (![privateKey isHaveValue]) {
        return nil;
    }
    NSData *publicKeyData = [self getPublicKeyDataWithPrivateKey:privateKey];
    //Hash160哈希计算
    NSData *encryptPublicKeyData = BTCHash160(publicKeyData);
    NSMutableData *addData = [[NSMutableData alloc] init];
    char byteChars[3] = {CHAINID,'\0',ADDRESSTYPE};
    //前三位拼接字节
    [addData appendBytes:&byteChars length:3];
    [addData appendData:encryptPublicKeyData];
    
    //异或运算获取校验位
    const Byte *point = addData.bytes;
    Byte b = 0x00;
    for (int i = 0; i < addData.length; i++) {
        b ^= point[i];
    }
    //追加字节
    [addData appendBytes:&b length:1];
    //获取校验位
    NSString *lengthPrefixStr = LENGTHPREFIX[PREFIX.length];
    //加密
    NSString *base58Str = BTCBase58StringWithData(addData);
    //地址拼接
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",PREFIX,lengthPrefixStr,base58Str];
    return addressStr;
}

/**
 根据私钥生成Nerve钱包地址
 
 @param privateKey 私钥（16进制数据类型）
 @return value     由私钥生成的地址
 */
+ (NSString *)getNerveAddressWithPrivateKe:(NSString *)privateKey
{
    if (![privateKey isHaveValue]) {
        return nil;
    }
    NSData *publicKeyData = [self getPublicKeyDataWithPrivateKey:privateKey];
    //Hash160哈希计算
    NSData *encryptPublicKeyData = BTCHash160(publicKeyData);
    NSMutableData *addData = [[NSMutableData alloc] init];
    char byteChars[3] = {CHAINID_NVT,'\0',ADDRESSTYPE};
    //前三位拼接字节
    [addData appendBytes:&byteChars length:3];
    [addData appendData:encryptPublicKeyData];
    
    //异或运算获取校验位
    const Byte *point = addData.bytes;
    Byte b = 0x00;
    for (int i = 0; i < addData.length; i++) {
        b ^= point[i];
    }
    //追加字节
    [addData appendBytes:&b length:1];
    //获取校验位
    NSString *lengthPrefixStr = LENGTHPREFIX[NVT_PREFIX.length];
    //加密
    NSString *base58Str = BTCBase58StringWithData(addData);
    //地址拼接
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",NVT_PREFIX,lengthPrefixStr,base58Str];
    return addressStr;
}



/**
 进行私钥加密
 
 @param privateKey 私钥（16进制数据类型）
 @param password   密码（字符串类型）
 @return value     由加密后的密码当秘钥，私钥当value进行AES加密的结果
 */
+ (NSString *)encryptPrivateKey:(NSString *)privateKey password:(NSString *)password
{
    if (![privateKey isHaveValue] || ![password isHaveValue]) {
        return nil;
    }
    NSMutableData *ivData = [NSMutableData dataWithLength:16];
    NSData *passwordSecurity = [[CocoaSecurity sha256:password].hexLower ny_dataFromHexString];
    CocoaSecurityResult *result = [CocoaSecurity aesEncryptWithData:[privateKey ny_dataFromHexString] key:passwordSecurity iv:ivData];
    return result.hexLower;
}

/**
 进行私钥解密
 
 @param encryptPrivateKey 加密后私钥（16进制数据类型）
 @param password          密码（字符串类型）
 @return value            由加密后的密码当秘钥，对加密后的私钥进行AES解密结果
 */
+ (NSString *)decryptPrivateKey:(NSString *)encryptPrivateKey password:(NSString *)password
{
    if (![encryptPrivateKey isHaveValue] || ![password isHaveValue]) {
        return nil;
    }
    NSMutableData *ivData = [NSMutableData dataWithLength:16];
    NSData *passwordSecurity = [[CocoaSecurity sha256:password].hexLower ny_dataFromHexString];
    CocoaSecurityResult *decryptResult = [CocoaSecurity aesDecryptWithData:[encryptPrivateKey ny_dataFromHexString] key:passwordSecurity iv:ivData];
    return decryptResult.hexLower;
}

/**
 进行助记词加密
 
 @param mnemonic   助记词
 @param password   密码（字符串类型）
 @return value     由加密后的密码当秘钥，助记词当value进行AES加密的结果
 */
+ (NSString *)encryptMnemonic:(NSString *)mnemonic password:(NSString *)password
{
    if (![mnemonic isHaveValue] || ![password isHaveValue]) {
        return nil;
    }
    NSMutableData *ivData = [NSMutableData dataWithLength:16];
    NSData *passwordSecurity = [[CocoaSecurity sha256:password].hexLower ny_dataFromHexString];
    //场景区分，此处mnemonic转data需用系统方法
    CocoaSecurityResult *result = [CocoaSecurity aesEncryptWithData:[mnemonic dataUsingEncoding:(NSUTF8StringEncoding)] key:passwordSecurity iv:ivData];
    return result.hexLower;
}

/**
 进行助记词解密
 
 @param encryptMnemonic   加密后助记词
 @param password          密码（字符串类型）
 @return value            由加密后的密码当秘钥，对加密后的助记词进行AES解密结果
 */
+ (NSString *)decryptMnemonic:(NSString *)encryptMnemonic password:(NSString *)password
{
    if (![encryptMnemonic isHaveValue] || ![password isHaveValue]) {
        return nil;
    }
    NSMutableData *ivData = [NSMutableData dataWithLength:16];
    NSData *passwordSecurity = [[CocoaSecurity sha256:password].hexLower ny_dataFromHexString];
    //场景区分，此处encryptMnemonic转data需用ny_dataFromHexString方法
    CocoaSecurityResult *decryptResult = [CocoaSecurity aesDecryptWithData:[encryptMnemonic ny_dataFromHexString] key:passwordSecurity iv:ivData];
    return decryptResult.utf8String;
}

@end
