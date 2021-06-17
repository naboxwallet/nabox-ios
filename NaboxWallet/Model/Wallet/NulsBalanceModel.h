//
//  NulsBalanceModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NulsBalanceModel : BaseModel
/** 钱包别名 */
@property (nonatomic, copy) NSString *alias;
/** NULS的美元汇率 */
@property (nonatomic, strong) NSNumber *usdRate;
/** NULS的人民币汇率 */
@property (nonatomic, strong) NSNumber *cnyRate;
/** 可用余额 */
@property (nonatomic, strong) NSNumber *balance;
/** 共识锁定金额 */
@property (nonatomic, strong) NSNumber *consensusLock;
/** 交易未确认金额，冻结金额 */
@property (nonatomic, strong) NSNumber *freeze;
/** 资产的nonce值,创建交易要用 */
@property (nonatomic, copy) NSString *nonce;
/** nonce值是否已确认 0:未确认, 1:已确认 */
@property (nonatomic, strong) NSNumber *nonceType;
/** 时间锁定金额 */
@property (nonatomic, strong) NSNumber *timeLock;
/** 资产总额 */
@property (nonatomic, strong) NSNumber *totalBalance;

/** 资产的nonce值 from2,创建交易要用 */
@property (nonatomic, copy) NSString *nonce2;
@end

NS_ASSUME_NONNULL_END
