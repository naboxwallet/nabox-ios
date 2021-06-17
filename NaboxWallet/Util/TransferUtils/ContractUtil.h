//
//  ContractUtil.h
//  NaboxWallet
//  合约资产交易工具类
//  Created by nuls on 2019/11/15.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractUtil : NSObject




/**
 获取生成的CoinData
 
 @param fromAddress      付款地址
 @param balanceModel     余额对象
 @param toAddress        收款地址
 @param contractAddress  合约地址
 @param gasLimit         汽油消耗
 @param amount           转账金额（输入框中输入的金额）
 @param remark           备注
 @return value           生成的CoinData
 */
+ (NSData *)tokenTransferTxOffline:(NSString *)fromAddress
                          balanceModel:(NulsBalanceModel *)balanceModel
                             toAddress:(NSString *)toAddress
                       contractAddress:(NSString *)contractAddress
                              gasLimit:(NSNumber *)gasLimit
                                amount:(NSString *)amount
                                remark:(NSString *)remark;







@end

NS_ASSUME_NONNULL_END
