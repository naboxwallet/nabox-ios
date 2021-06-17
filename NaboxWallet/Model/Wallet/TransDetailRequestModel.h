//
//  TransDetailRequestModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransDetailRequestModel : BaseModel

/**
 * 交易Hash Hex值
 * hash作为交易的索引
 */
@property (nonatomic, copy) NSString *txHex;
/**
 * 地址
 */
@property (nonatomic, copy) NSString *address;
/**
 * 出入金类型
 */
@property (nonatomic, copy) NSString *coinType;
/**
 * 合约资产地址
 */
@property (nonatomic, copy) NSString *contractAddress;

@end

NS_ASSUME_NONNULL_END
