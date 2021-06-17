//
//  ContractUtil.m
//  NaboxWallet
//
//  Created by nuls on 2019/11/15.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "ContractUtil.h"
#import "TransferUtil.h"
#import "NYMnemonic.h"
#import "BTCBase58.h"
#import "CBSecp256k1.h"
#import "NSData+BTCData.h"

@implementation ContractUtil

/**
 离线组织合约交易
 
 @param fromAddress      付款地址
 @param balanceModel     余额对象
 @param toAddress        收款地址
 @param contractAddress  合约地址
 @param gasLimit         汽油消耗
 @param amount           转账金额（输入框中输入的金额）
 @param remark           备注
 @return value           生成的CoinData
 */
+ (TransactionModel *)contractTxOffline:(NSString *)senderAddress
                      balanceModel:(NulsBalanceModel *)balanceModel
                                  value:(NSNumber *)value
                         toAddress:(NSString *)toAddress
                   contractAddress:(NSString *)contractAddress
                          gasLimit:(NSNumber *)gasLimit
                            methodName:(NSString *)methodName
                            methodDesc:(NSString *)methodDesc
                                   args:(NSArray *)args
                               argsType:(NSArray *)argsType
                                 remark:(NSString *)remark
{
    
    TransactionModel *transactionModel = [[TransactionModel alloc] init];
    //组装二维数组
    NSMutableArray *twoArgs = [[NSMutableArray alloc]init];
    if (args != nil && ![args isKindOfClass:[NSNull class]] && args.count != 0) {
        long int count = [args count];
        for (int i = 0 ; i < count; i++) {
            NSMutableArray *array1 = [NSMutableArray arrayWithObjects:[args objectAtIndex :i],nil];
            [twoArgs addObject:array1];
        }
    }
    
    CoinFromModel *fromModel = [[CoinFromModel alloc] init];
    fromModel.assetsChainId = [NSNumber numberWithInteger:CHAINID];
    fromModel.assetsId = [NSNumber numberWithInteger:1];
    double newAmount = (amount.doubleValue + 0.001) * pow(10, 8);
    fromModel.amount = [NSNumber numberWithDouble:newAmount];
    if ([locked isEqualToString:@"-1"]) {
        fromModel.amount = [NSNumber numberWithDouble:amount.doubleValue  * pow(10, 8)];
    }
    fromModel.nonce = [balanceModel.nonce ny_dataFromHexString];
    NSMutableData *lockedData = [NSMutableData data];
    [self appendLengthToData:lockedData length:0];
    fromModel.locked = lockedData;
    fromModel.address = senderAddress;
    
    if (value != nil && value > 0) {
        CoinToModel *toModel = [[CoinToModel alloc] init];
        toModel.assetsChainId = fromModel.assetsChainId;
        toModel.assetsId = fromModel.assetsId;
        double toAmount = amount.doubleValue * pow(10, 8);
        toModel.amount = [NSNumber numberWithDouble:toAmount];
        if ([locked isEqualToString:@"-1"]) {
            toModel.amount = [NSNumber numberWithDouble:(amount.doubleValue - 0.001) * pow(10, 8)];
        }
        toModel.address = [self changeAddress:toAddress];
        toModel.lockTime = [NSNumber numberWithInteger:lockTime];
    }
    
    
    NSMutableData *coinData = [NSMutableData data];
    //数组长度暂时默认为1
    [self appendLengthToData:coinData length:1];
    [self appendLengthToData:coinData length:fromModel.address.length];
    
    //将address写入
    [coinData appendData:fromModel.address];
    //位移并与运算
    Byte b1 = fromModel.assetsChainId.intValue & 0xff;
    [coinData appendBytes:&b1 length:1];
    Byte b2 = fromModel.assetsChainId.intValue >> 8 & 0xff;
    [coinData appendBytes:&b2 length:1];
    Byte b3 = fromModel.assetsId.intValue & 0xff;
    [coinData appendBytes:&b3 length:1];
    Byte b4 = fromModel.assetsId.intValue >> 8 & 0xff;
    [coinData appendBytes:&b4 length:1];
    
    //类型转换->限制长度->反序->拼接
    NSMutableData *fromAmountData = [self setAmountDataWithAmount:fromModel.amount.stringValue.longLongValue];
    [coinData appendData:fromAmountData];
    
    [self appendLengthToData:coinData length:fromModel.nonce.length];
    [coinData appendData:fromModel.nonce];
    [coinData appendData:fromModel.locked];
    
    //数组长度暂时默认为1
    [self appendLengthToData:coinData length:1];
    [self appendLengthToData:coinData length:toModel.address.length];
    //将address写入
    [coinData appendData:toModel.address];
    //位移并与运算
    Byte b5 = fromModel.assetsChainId.intValue & 0xff;
    [coinData appendBytes:&b5 length:1];
    Byte b6 = fromModel.assetsChainId.intValue >> 8 & 0xff;
    [coinData appendBytes:&b6 length:1];
    Byte b7 = fromModel.assetsId.intValue & 0xff;
    [coinData appendBytes:&b7 length:1];
    Byte b8 = fromModel.assetsId.intValue >> 8 & 0xff;
    [coinData appendBytes:&b8 length:1];
    //类型转换->限制长度->反序->拼接
    NSData *toAmountData = [self setAmountDataWithAmount:toModel.amount.stringValue.longLongValue];
    [coinData appendData:toAmountData];
    
    //lockTime位移并与运算
    NSInteger tempLockTime = toModel.lockTime.intValue;
    Byte b9 = tempLockTime & 0xff;
    [coinData appendBytes:&b9 length:1];
    Byte b10 = tempLockTime >> 8 & 0xff;
    [coinData appendBytes:&b10 length:1];
    Byte b11 = tempLockTime >> 16 & 0xff;
    [coinData appendBytes:&b11 length:1];
    Byte b12 = tempLockTime >> 24 & 0xff;
    [coinData appendBytes:&b12 length:1];
    Byte b13 = tempLockTime >> 32 & 0xff;
    [coinData appendBytes:&b13 length:1];
    Byte b14 = tempLockTime >> 40 & 0xff;
    [coinData appendBytes:&b14 length:1];
    Byte b15 = tempLockTime >> 48 & 0xff;
    [coinData appendBytes:&b15 length:1];
    Byte b16 = tempLockTime >> 56 & 0xff;
    [coinData appendBytes:&b16 length:1];
    DLog(@"%@",[coinData ny_hexString]);
    
    NSData *coinData = [TransferUtil getCoinDataWithFromAddress:depositModel.address
                                                   balanceModel:self.walletModel.balanceModel
                                                      toAddress:depositModel.address
                                                         amount:amount
                                                         locked:@"-1"
                                                       lockTime:0];
    transactionModel.coinData = coinData;
    transactionModel.type = [NSNumber numberWithInteger:6];
    transactionModel.time = [NSNumber numberWithLong:[Common getNowTimeTimestamp]];
    //    transactionModel.time = @(1571410980);
  
    return transactionModel;
}

@end
