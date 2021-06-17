//
//  NaboxPayModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NaboxPayModel : BaseModel
/* 金额 */
@property (nonatomic, strong) NSNumber *amount;
/* 商户ID */
@property (nonatomic, copy) NSString *shopId;
/* 金额 */
@property (nonatomic, copy) NSString *payAmount;
/* 备注 */
@property (nonatomic, copy) NSString *remark;
/* 钱包地址 */
@property (nonatomic, copy) NSString *address;
/* 资产单位缩写如NULS、CB */
@property (nonatomic, copy) NSString *symbol;
/* 钱包别名 */
@property (nonatomic, copy) NSString *alias;
/* 状态值 */
@property (nonatomic, copy) NSString *requestCode;
/** 支持的小数位数 */
@property (nonatomic, assign) NSInteger decimals;
/** 资产总额，返回最小单位number，例如地址有1NULS，NULS的decimals=8则该参数返回100000000 */
@property (nonatomic, strong) NSNumber *totalBalance;
/** 可用资产,nuls资产有可用资产参数 */
@property (nonatomic, strong) NSNumber *balance;
/* 交易完整序列化16进制字符串数据 */
@property (nonatomic, copy) NSString *txHex;
/* 交易的hash值 */
@property (nonatomic, copy) NSString *txHash;
/* 加密后的私钥 */
@property (nonatomic, copy) NSString *encryptedPrivateKey;
/* /公钥 */
@property (nonatomic, copy) NSString *pubKey;
/* 支付人地址 */
@property (nonatomic, copy) NSString *payAddress;
/* 合约地址，如果需要查询TOKEN资产填写资产合约地址 */
@property (nonatomic, copy) NSString *contractAddress;

/* 转给合约的金额，单位NULS，没有填0 */
@property (nonatomic, copy) NSString *value;
/* 汽油消耗 */
@property (nonatomic, strong) NSNumber *gasLimit;
/* 合约方法名称 */
@property (nonatomic, copy) NSString *methodName;
/* 合约方法描述，若合约内方法没有重载，则此参数可以为空 */
@property (nonatomic, copy) NSString *methodDesc;
/* 参数列表 */
@property (nonatomic, strong) NSArray *args;
/* 参数类型列表，必填 */
@property (nonatomic, strong) NSArray *argsType;
/* 调用人地址 */
@property (nonatomic, copy) NSString *sender;

/* token余额(用于支付页获取token余额后存值及外部读取使用) */
@property (nonatomic, copy) NSString *tokenBalnce;


/* token 用于地址返回替代address字段 */
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
