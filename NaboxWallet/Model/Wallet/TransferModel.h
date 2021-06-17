//
//  TransferModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"
#import "TransferCoinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferModel : BaseModel

/**
 * 界面类型：0~交易类型，1~其他类型
 */
@property (nonatomic, assign) NSInteger itemType;

@property (nonatomic, copy) NSString *ID;
/**
 * 交易Hash Hex值
 * hash作为交易的索引
 */
@property (nonatomic, copy) NSString *txHex;

@property (nonatomic, copy) NSString *txSerializeHex;
/**
 * 节点hash
 */
@property (nonatomic, copy) NSString *agentHash;

/**
 * 共识节点id
 */
@property (nonatomic, copy) NSString *agentId;

/**
 * 共识节点别名
 */
@property (nonatomic, copy) NSString *agentAlias;

/**
 * 打包出块地址
 */
@property (nonatomic, copy) NSString *packingAddress;


/**
 * 图标地址
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 * 奖励地址
 */
@property (nonatomic, copy) NSString *rewardAddress;

/**
 * 备注
 */
@property (nonatomic, copy) NSString *remark;
/**
 * 交易金额
 */
@property (nonatomic, strong) NSNumber *amount;
/**
 * 交易状态
 */
@property (nonatomic, copy) NSString *transState;

/**
 * dapp商户名 中文
 */
@property (nonatomic, copy) NSString *partnerName;

/**
 * dapp商户名 英文
 */
@property (nonatomic, copy) NSString *partnerNameEn;

/**
 * 链id
 */
@property (nonatomic, assign) NSInteger chainId;
/**
 * 块高度
 */
@property (nonatomic, strong) NSNumber *height;

/**
 * nuls交易类型
 */
@property (nonatomic, assign) NSInteger type;
/**
 * 交易状态
 */
@property (nonatomic, assign) NSInteger status;

/**
 * 推送状态
 */
@property (nonatomic, copy) NSString *pushState;

/**
 * 结束时间即打包时间
 */
@property (nonatomic, copy) NSString *finishTime;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, copy) NSString *updateTime;

/**
 * 合约资产地址
 */
@property (nonatomic, copy) NSString *contractAddress;

/**
 * 交易金额 货币缩写
 */
@property (nonatomic, copy) NSString *symbol;

/**
 * 小数点位数
 */
@property (nonatomic, assign) int decimals;

/**
 * 手续费单位
 */
@property (nonatomic, copy) NSString *feeSymbol;

@property (nonatomic, strong) NSArray *coinEntityList;
/**
 * 出金列表
 */
@property (nonatomic, strong) NSArray *coinFroms;
/**
 * 入金列表
 */
@property (nonatomic, strong) NSArray *coinTos;

/**
 * 出入金类型
 */
@property (nonatomic, copy) NSString *coinType;


// publicServer更改字段

// nuls
/**
 *  出入金类型
 */
@property (nonatomic, assign) NSInteger transferType;

/**
 *  手续费
 */
@property (nonatomic, strong) NSDictionary *fee;
@property (nonatomic, strong) NSString *txHash;

/**
 * 交易金额
 */
@property (nonatomic, strong) NSNumber *values;


// token
@property (nonatomic, strong) NSNumber *toBalance;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *fromAddress;


@end


@interface FeeModel : NSObject
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *symbol;
@end

NS_ASSUME_NONNULL_END
