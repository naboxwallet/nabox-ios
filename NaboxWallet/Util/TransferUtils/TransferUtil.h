//
//  TransferUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionModel.h"
#import "CoinFromModel.h"
#import "CoinToModel.h"
#import "CoinDataModel.h"
#import "NulsBalanceModel.h"
#import "TransferTempModel.h"
//NS_ASSUME_NONNULL_BEGIN
/**
 * 交易工具类
 */
@interface TransferUtil : NSObject

/**
 生成NULS,NERVE转账交易的CoinData(coinData包含了交易数据)
 @param transferModel 交易Model携带了全部的交易信息
 @param locked 0普通交易，-1解锁金额交易（退出共识，退出委托）
 @param lockTime         0默认，-1加入共识
 */
+ (NSData *)getCoinDataWithTransferInfo:(TransferTempModel *)transferModel
                                locked:(NSString *)locked
                               lockTime:(NSInteger)lockTime;
/**
 生成的加入/退出共识的txData（txData包含业务数据）
 @param amount               委托的金额(取消委托时不传)
 @param address              地址
 @param agentData            agentHash or joinAgentHash
 @return value               生成的txData
 */
+ (NSData *)getTxDataWithAmount:(NSString *)amount
                        address:(NSString *)address
                      agentData:(NSData *)agentData;

/**
 生成的NERVE->异构链的txData
 @param address              地址
 @param chainId              链ID
 */
+ (NSData *)getTxDataWithAddress:(NSString *)address
                         chainId:(NSString *)chainId;

/**
 获取生成的txHash(交易的txHash序列化数据)
 
 @param transactionModel     交易对象(包含：type，coinData，txData，time，remark)
 @return value               生成的txHash
 */
+ (NSString *)getTxHashWithTransactionModel:(TransactionModel *)transactionModel;

/**
 获取生成的txSerializeHex(交易的完整序列化数据)
 
 @param transactionModel     交易对象(包含：type，coinData，txData，time，remark)
 @param privateKey           私钥
 @return value               生成的txSerializeHex
 */
+ (NSString *)getTxSerializeHexWithTransactionModel:(TransactionModel *)transactionModel
                                       privateKey:(NSString *)privateKey;

/**
 组装NULS合约转账交易
 @param senderAddress      调用地址
 @param  value      转账金额，单位最小小数
 @param  feeModel     手续费对象
 @param contractAddress          合约地址
 @param gasLimit          汽油消耗
 @param remark            备注
 @return value           生成TransactionModel 携带了coinData和txData数据
 */
+ (TransactionModel *)contractTxOffline:(NSString *)senderAddress
                           feeModel:(AssetListResModel *)feeModel
                                  value:(NSNumber *)value
                        contractAddress:(NSString *)contractAddress
                               gasLimit:(NSNumber *)gasLimit
                             methodName:(NSString *)methodName
                             methodDesc:(NSString *)methodDesc
                                   args:(NSArray *)args
                               argsType:(NSArray *)argsType
                                 remark:(NSString *)remark;


@end

//NS_ASSUME_NONNULL_END

