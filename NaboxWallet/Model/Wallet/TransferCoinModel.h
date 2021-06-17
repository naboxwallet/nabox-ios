//
//  TransferCoinModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferCoinModel : BaseModel

@property (nonatomic, copy) NSString *ID;
/**
 * 交易Hash Hex值
 * hash作为交易的索引
 */
@property (nonatomic, copy) NSString *txHex;
/**
 * 交易金额
 */
@property (nonatomic, strong) NSNumber *amount;
/**
 * 地址
 */
@property (nonatomic, copy) NSString *address;
/**
 * 链id
 */
@property (nonatomic, assign) NSInteger chainId;
/**
 * 资金id
 */
@property (nonatomic, assign) NSInteger assetId;
/**
 * 交易类型
 */
@property (nonatomic, assign) NSInteger type;
/**
 * 出入金类型
 */
@property (nonatomic, copy) NSString *coinType;

@property (nonatomic, copy) NSString *symbol;
@end

NS_ASSUME_NONNULL_END
