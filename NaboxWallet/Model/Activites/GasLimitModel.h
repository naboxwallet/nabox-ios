//
//  GasLimitModel.h
//  NaboxWallet
//
//  Created by nuls on 2019/11/15.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface GasLimitModel : BaseModel

@property (nonatomic ,strong)NSString *language;
@property (nonatomic ,strong)NSString *chain;

/**
 * 合约方法参数
 */
@property (nonatomic ,copy) NSArray *args;
/**
 * 地址
 */
@property (nonatomic ,strong)NSString *address;

/**
 * 合约地址
 */
@property (nonatomic ,strong)NSString *contractAddress;
/**
 * 合约方法描述
 */
@property (nonatomic ,strong)NSString *methodDesc;
/**
 * 合约方法名
 */
@property (nonatomic ,strong)NSString *methodName;
/**
 * 合约调用人地址
 */
@property (nonatomic ,strong)NSString *sender;
/**
 * 调用人想合约地址转账金额，单位Na,没有可以不填
 */
@property (nonatomic ,strong)NSString *value;

@end

NS_ASSUME_NONNULL_END
