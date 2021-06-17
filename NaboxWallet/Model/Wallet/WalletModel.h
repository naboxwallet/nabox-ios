//
//  WalletModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"
#import "NulsBalanceModel.h"
#import "ConfigModel.h"
@interface WalletModel : BaseModel
/** 余额对象 */
@property (nonatomic, strong) NulsBalanceModel *balanceModel;

/** 资产总额 */
@property (nonatomic, assign) double totalBalance;
/** 可用余额 */
@property (nonatomic, assign) double balance;
/* 标识当前钱包是否为已选择 */
@property (nonatomic, assign) BOOL selected;

/* 合约地址，如果需要查询TOKEN资产填写资产合约地址，非必填 */
@property (nonatomic, copy) NSString *contractAddress;

/* 地址 */
@property (nonatomic, copy) NSString *address;
/* 币种 */
@property (nonatomic, copy) NSString *coinType;
/* 钱包别名 */
@property (nonatomic, copy) NSString *alias;
/* 密码 */
@property (nonatomic, copy) NSString *password;
/* 钱包颜色 */
@property (nonatomic, strong) NSNumber *colorIndex;
/* 皮肤名称 */
@property (nonatomic, copy) NSString *skinName;
/* 皮肤背景图名称 */
@property (nonatomic, copy) NSString *skinImageName;
/* 助记词 */
@property (nonatomic, copy) NSString *mnemonicStr;
/* 加密助记词 */
@property (nonatomic, copy) NSString *encryptMnemonic;
/* 公钥 */
@property (nonatomic, copy) NSString *publicKey;
/* 私钥 */
@property (nonatomic, copy) NSString *privateKey;
/* 加密私钥 */
@property (nonatomic, copy) NSString *encryptPrivateKey;
/**种子私钥地址
 * 自建钱包用于恢复助记词和关联地址
 */
@property (nonatomic, copy) NSString *rootAddress;
/**自建钱包子秘钥的父路径
 * 例如 M/44H/0H/0H/0
 */
@property (nonatomic, copy) NSString *bip44ParentPath;
/**自建钱包地址个数索引
 * 例如父路径为M/44H/0H/0H/0,索引为0
 * 则和索引组成路径M/44H/0H/0H/0/0 为M/44H/0H/0H/0路径下第一个子秘钥
 */
@property (nonatomic, strong) NSNumber *addressIndex;
/**终端唯一标识 */
@property (nonatomic, copy) NSString *terminal;
/**推送tag */
@property (nonatomic, copy) NSString *tag;
/**推送type */
@property (nonatomic, copy) NSString *type;
/* 语言 */
@property (nonatomic, copy) NSString *language;
/* 时区 */
@property (nonatomic, copy) NSString *timeZone;

/* 当前选择的链名称 */
@property (nonatomic, copy) NSString *chain;

/* 地址字典 缓存地址字典 格式为@{chain:address} */
@property (nonatomic ,strong) NSDictionary *addressDict;
/* 链配置数组 整体缓存config接口返回值 */
@property (nonatomic ,strong) NSArray *chainConfig;


/**
 模型转字典并只解析需要上传的部分参数
 */
- (NSDictionary *)getWalletDictIgnoredKeys;

@end

