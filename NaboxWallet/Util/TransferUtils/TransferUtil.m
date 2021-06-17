//
//  TransferUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TransferUtil.h"
#import "NYMnemonic.h"
#import "BTCBase58.h"
#import "CBSecp256k1.h"
#import "NSData+BTCData.h"
#import "ConfigModel.h"
#import "AssetListModel.h"
#import "PKWeb3Objc.h"

@implementation TransferUtil

// 此方法包含nuls nerve本链转账 和nuls与nerve的跨链 和nerve与异构链的跨链交易
+ (NSData *)getCoinDataWithTransferInfo:(TransferTempModel *)transferModel
                                 locked:(NSString *)locked
                               lockTime:(NSInteger)lockTime
{
    DLog(@"获取coindata入参transferModel:%@",[transferModel mj_keyValues]);
    // 开始拼接数据
    NSMutableData *coinData = [NSMutableData data];
    // 写入fromModel  最多有三个
    [self appendLengthToData:coinData length:transferModel.fromAssetList.count];

    for (int i = 0; i < transferModel.fromAssetList.count; i ++) {
        AssetListResModel *assetModel = transferModel.fromAssetList[i];
        
        CoinFromModel *fromModel = [[CoinFromModel alloc] init];
        fromModel.assetsChainId = [NSNumber numberWithInteger:assetModel.chainId];
        fromModel.assetsId = @(assetModel.assetId);
        fromModel.nonce = [assetModel.nonce ny_dataFromHexString];
        if (assetModel.decimals > 8) {
            fromModel.amount = [Common Num1:assetModel.amount multiplyingByDecimal:assetModel.decimals];
        }else{
            fromModel.amount = [NSNumber numberWithDouble:assetModel.amount * pow(10, assetModel.decimals)];
        }
        if (transferModel.assetModel.assetId == assetModel.assetId && [locked isEqualToString:@"-1"]) {
            fromModel.amount = [NSNumber numberWithDouble:transferModel.amount.doubleValue * pow(10, assetModel.decimals)];
        }
        NSMutableData *lockedData = [NSMutableData data];
        [self appendLengthToData:lockedData length:locked.intValue];
        fromModel.locked = lockedData;
        fromModel.address = [self changeAddress:transferModel.fromAddress];
        
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
        
        DLog(@"fromModel:%d:%@",i,[fromModel mj_keyValues]);
    }
    
    
    CoinToModel *toModel = [[CoinToModel alloc] init];
    toModel.assetsChainId = [NSNumber numberWithInteger:transferModel.assetModel.chainId];
    toModel.assetsId = @(transferModel.assetModel.assetId);
    
    if (transferModel.assetModel.decimals > 8) {
        toModel.amount = [Common Num1:transferModel.amount.doubleValue multiplyingByDecimal:transferModel.assetModel.decimals];
    }else{
        toModel.amount = @(transferModel.amount.doubleValue * pow(10, transferModel.assetModel.decimals));
    }
    if ([locked isEqualToString:@"-1"]) { // 加入共识 不收手续费
        toModel.amount = [NSNumber numberWithDouble:(transferModel.amount.doubleValue - 0.001) * pow(10, 8)];
    }
    if (transferModel.extraToModel.chainId) {
        toModel.address = [self changeAddress:transferModel.destroyAddress];
    } else {
        toModel.address = [self changeAddress:transferModel.toAddress];
    }
    toModel.lockTime = [NSNumber numberWithInteger:lockTime];
    
    //判断需要几个toModel
    if (transferModel.extraToModel.chainId) {
        [self appendLengthToData:coinData length:2];
    } else {
        [self appendLengthToData:coinData length:1];
    }
    //第一个toModel
    [self appendToDataToCoinData:coinData toModel:toModel];
    
    if (transferModel.extraToModel.chainId) {
        CoinToModel *toModel2 = [[CoinToModel alloc] init];
        toModel2.assetsChainId = @(transferModel.extraToModel.chainId);
        toModel2.assetsId = @(transferModel.extraToModel.assetId);
        double toAmount2 = transferModel.extraToModel.amount * pow(10, 8);
        toModel2.amount = [NSNumber numberWithDouble:toAmount2];
        toModel2.address = [self changeAddress:transferModel.feeAddress];
        toModel2.lockTime = [NSNumber numberWithInteger:lockTime];
        DLog(@"ToModel-2%@",[toModel2 mj_keyValues]);
        //开始拼接第二个toModel
        [self appendToDataToCoinData:coinData toModel:toModel2];
    }

    
    DLog(@"fromModel-1%@",[transferModel.fromAssetList mj_keyValues]);
    DLog(@"toModel%@",[toModel mj_keyValues]);
    
    DLog(@"coinData===>: %@",[coinData ny_hexString]);
    return coinData;
}

/**
 获取生成的txData（加入委托，取消委托时使用）
 
 @param amount               委托的金额(取消委托时不传)
 @param address              地址
 @param agentData            agentHash or joinAgentHash
 @return value               生成的txData
 */
+ (NSData *)getTxDataWithAmount:(NSString *)amount
                        address:(NSString *)address
                      agentData:(NSData *)agentData
{
    NSMutableData *txData = [NSMutableData data];
    if (amount.length) {
        //类型转换->限制长度->反序->拼接
        long toAmount = amount.doubleValue * pow(10, 8);
        [txData appendData:[self setAmountDataWithAmount:toAmount]];
    }
    [txData appendData:[self changeAddress:address]];
    [txData appendData:agentData];
    return txData;
}


/** 目前没完成
 获取生成的txData（nerve->异构链时使用）
 @param address              地址
 @param chainId              链ID
 @return value               生成的txData
 */

// 例子
//{
//    "heterogeneousAddress" : "0x1F0518A1F11195e4518F1615948Fd87B4f433EE1",
//    "heterogeneousChainId" : 101
//}
// 结果:2a307831463035313841314631313139356534353138463136313539343846643837423466343333454531
// 6500
// 分为三步 :2a是0x1F0518A1F11195e4518F1615948Fd87B4f433EE1的utf8编码数组的长度
// 2a后面42字节是0x1F0518A1F11195e4518F1615948Fd87B4f433EE1的utf8编码数组
// 101的hex是65, 本应该是 0065，调个顺序，6500
+ (NSData *)getTxDataWithAddress:(NSString *)address
                      chainId:(NSString *)chainId
{
    NSMutableData *txData = [NSMutableData data];
    PKWeb3Objc *web3 = [PKWeb3Objc sharedInstance];
    NSString *addressLength= [[web3.utils numberToHex:[NSString stringWithFormat:@"%ld",address.length]] removePrefix0x];
    NSString * addressUtf8 = [[web3.utils utf8ToHex:address] removePrefix0x];
    NSString *chainIdHex = [web3.utils numberToHex:chainId];
    [txData appendData:[addressLength ny_dataFromHexString]];
    [txData appendData:[addressUtf8 ny_dataFromHexString]];
    [txData appendData:[self reverseData:[chainIdHex ny_dataFromHexString]]];
    return txData;
}

/**
 获取生成的txSerializeHex(交易的完整序列化数据)
 @param transactionModel     交易对象(包含：type，coinData，txData，time，remark) type:跨链10 交易2 异构链43
 @param privateKey           私钥
 @return value               生成的txSerializeHex
 */
+ (NSString *)getTxSerializeHexWithTransactionModel:(TransactionModel *)transactionModel
                                         privateKey:(NSString *)privateKey
{
    if (!transactionModel || !privateKey.length) {
        return nil;
    }
    NSMutableData *transactionData = [NSMutableData data];
    Byte b1 = transactionModel.type.intValue & 0xff;
    [transactionData appendBytes:&b1 length:1];
    Byte b2 = transactionModel.type.intValue >> 8 & 0xff;
    [transactionData appendBytes:&b2 length:1];
    Byte b3 = transactionModel.time.intValue & 0xff;
    [transactionData appendBytes:&b3 length:1];
    Byte b4 = transactionModel.time.intValue >> 8 & 0xff;
    [transactionData appendBytes:&b4 length:1];
    Byte b5 = transactionModel.time.intValue >> 16 & 0xff;
    [transactionData appendBytes:&b5 length:1];
    Byte b6 = transactionModel.time.intValue >> 24 & 0xff;
    [transactionData appendBytes:&b6 length:1];
    [self appendData:transactionData addData:transactionModel.remark];
    [self appendLongData:transactionData addData:transactionModel.txData];
    [self appendLongData:transactionData addData:transactionModel.coinData];
    
    //SHA256(SHA256(data))
    NSMutableData *hashData = BTCHash256(transactionData);
    BTCKey *key = [[BTCKey alloc] initWithPrivateKey:[privateKey ny_dataFromHexString]];
    NSData *signData = [key signatureForHash:hashData];
    NSData *publicKeyData = [WalletUtil getPublicKeyDataWithPrivateKey:privateKey];
    
    NSMutableData *transactionSignature = [NSMutableData data];
    [self appendLengthToData:transactionSignature length:publicKeyData.length];
    [transactionSignature appendData:publicKeyData];
    [self appendLengthToData:transactionSignature length:signData.length];
    [transactionSignature appendData:signData];
    
    
    NSMutableData *txSerializeData = [NSMutableData data];
    [txSerializeData appendBytes:&b1 length:1];
    [txSerializeData appendBytes:&b2 length:1];
    [txSerializeData appendBytes:&b3 length:1];
    [txSerializeData appendBytes:&b4 length:1];
    [txSerializeData appendBytes:&b5 length:1];
    [txSerializeData appendBytes:&b6 length:1];
    [self appendData:txSerializeData addData:transactionModel.remark];
    [self appendLongData:txSerializeData addData:transactionModel.txData];
    [self appendLongData:txSerializeData addData:transactionModel.coinData];
    
    [self appendData:txSerializeData addData:transactionSignature];
    
    NSString *txSerializeHex = [txSerializeData ny_hexString];
    DLog(@"txSerializeHex入参:%@",[transactionModel mj_keyValues]);
    DLog(@"txSerializeHex: %@",txSerializeHex);
    return txSerializeHex;
}

/**
 获取生成的txHash(交易的txHash序列化数据)
 
 @param transactionModel     交易对象(包含：type，coinData，txData，time，remark)
 @return value               生成的txHash
 */
+ (NSString *)getTxHashWithTransactionModel:(TransactionModel *)transactionModel
{
    if (!transactionModel) {
        return nil;
    }
    NSMutableData *transactionData = [NSMutableData data];
    Byte b1 = transactionModel.type.intValue & 0xff;
    [transactionData appendBytes:&b1 length:1];
    Byte b2 = transactionModel.type.intValue >> 8 & 0xff;
    [transactionData appendBytes:&b2 length:1];
    Byte b3 = transactionModel.time.intValue & 0xff;
    [transactionData appendBytes:&b3 length:1];
    Byte b4 = transactionModel.time.intValue >> 8 & 0xff;
    [transactionData appendBytes:&b4 length:1];
    Byte b5 = transactionModel.time.intValue >> 16 & 0xff;
    [transactionData appendBytes:&b5 length:1];
    Byte b6 = transactionModel.time.intValue >> 24 & 0xff;
    [transactionData appendBytes:&b6 length:1];
    [self appendData:transactionData addData:transactionModel.remark];
    
    [self appendData:transactionData addData:transactionModel.txData];
    [self appendData:transactionData addData:transactionModel.coinData];
    
    //SHA256(SHA256(data))
    NSMutableData *hashData = BTCHash256(transactionData);
    return [hashData ny_hexString];
}


/**
 组装合约转账交易，其实就是一种指定的方法
 @param senderAddress      调用地址
 @param balanceModel     余额对象
 @param value        转账给合约的金额地，单位Na  只有NULS转账时才会传value
 @param contractAddress          合约地址
 @param gasLimit          汽油消耗
 @param methodName        方法名
 @param methodDesc        方法描述
 @param args              参数列表
 @param argsType          参数类型列表
 @param remark            备注
 @return value           生成的CoinData
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
                                 remark:(NSString *)remark
{
    
    TransactionModel *transactionModel = [[TransactionModel alloc] init];
    //组装二维数组
    NSMutableArray *twoArgs = [[NSMutableArray alloc]init];
    if (args != nil && ![args isKindOfClass:[NSNull class]] && args.count != 0) {
        long int count = [args count];
        for (int i = 0 ; i < count; i++) {
            //这里需要判断args里的参数是不是数组,写不来
            NSString *tmp;
            if ([argsType[i] isEqualToString:@"BigInteger"]
                ||[argsType[i] isEqualToString:@"Integer"]
                ||[argsType[i] isEqualToString:@"Long"] || [argsType[i] isEqualToString:@"Address"]) {
                tmp = [NSString stringWithFormat:@"%@",args[i]];
//                tmp = [NSString stringWithFormat:@"%ld",(NSInteger)args[i]];
            }else {
                tmp = [args objectAtIndex :i];
            }
            NSMutableArray *array1 = [NSMutableArray arrayWithObjects:tmp,nil];
            [twoArgs addObject:array1];
        }
    }
    //组装txData
    NSNumber *dGasLimit = @(200000);
    NSInteger dGasPrice = 25;
    if (!gasLimit || [gasLimit intValue] <= 0) {
        gasLimit = dGasLimit;
    }
     NSMutableData *txData = [NSMutableData data];
    [txData appendData:[self changeAddress:senderAddress]];
    [txData appendData:[self changeAddress:contractAddress]];
    [txData appendData:[self setAmountDataWithAmount:value.stringValue.longLongValue]];
    [self writeInt64:txData addData:gasLimit];
    [self writeInt64:txData addData:[NSNumber numberWithInteger:dGasPrice]];
    [self writeString:txData addString:methodName];
    [self writeString:txData addString:methodDesc];
    if (args != nil && ![args isKindOfClass:[NSNull class]] && args.count != 0) {
        [self appendLengthToData:txData length:args.count];
        long int count = [args count];
        for (int i = 0 ; i < count; i++) {
            NSMutableArray *array1 = [twoArgs objectAtIndex :i];
            if(array1 == NULL) {
                [self appendLengthToData:txData length:0];
            }else {
                long int count1 = [array1 count];
                [self appendLengthToData:txData length:count1];
                for (int j = 0 ; j < count1; j++) {
                    NSString *val =[array1 objectAtIndex:j];
                    [self writeString:txData addString:val];
                }
            }

        }
    } else {
        [self appendLengthToData:txData length:0];
    }
    transactionModel.txData = txData;
  
    //组装coinData
    CoinFromModel *fromModel = [[CoinFromModel alloc] init];
    fromModel.assetsChainId = [NSNumber numberWithInteger:CHAINID];
    fromModel.assetsId = [NSNumber numberWithInteger:1];
    double dFee = 0.001;
    if ([value intValue]>0) {
        dFee = 0.101;
    }
    long fee =  gasLimit.longValue*dGasPrice+dFee *pow(10, 8);
    fromModel.amount = [NSNumber numberWithLong:fee];
    fromModel.nonce = [feeModel.nonce ny_dataFromHexString];
    NSMutableData *lockedData = [NSMutableData data];
    [self appendLengthToData:lockedData length:0];
    fromModel.locked = lockedData;
    fromModel.address = [self changeAddress:senderAddress];
    CoinToModel *toModel = [[CoinToModel alloc] init];
    if (value && [value intValue] > 0) {
        toModel.assetsChainId = fromModel.assetsChainId;
        toModel.assetsId = fromModel.assetsId;
        toModel.amount = value;
        toModel.address = [self changeAddress:contractAddress];
        toModel.lockTime = [NSNumber numberWithInteger:0];
    }
    NSMutableData *coinData = [NSMutableData data];
    //数组长度暂时默认为1
    [self appendLengthToData:coinData length:1];
    
    [self appendLengthToData:coinData length:fromModel.address.length];
    [coinData appendData:fromModel.address];
    
    [self writeUint16:coinData addData:fromModel.assetsChainId];
    [self writeUint16:coinData addData:fromModel.assetsId];
    
    //类型转换->限制长度->反序->拼接
    NSMutableData *fromAmountData = [self setAmountDataWithAmount:fromModel.amount.stringValue.longLongValue];
    [coinData appendData:fromAmountData];
    
    [self appendLengthToData:coinData length:fromModel.nonce.length];
    [coinData appendData:fromModel.nonce];
    [coinData appendData:fromModel.locked];
    
    //数组长度暂时默认为1
    if (value != nil && [value intValue] > 0) {
        [self appendLengthToData:coinData length:1];
        [self appendLengthToData:coinData length:toModel.address.length];
        [coinData appendData:toModel.address];
        [self writeUint16:coinData addData:fromModel.assetsChainId];
        [self writeUint16:coinData addData:fromModel.assetsId];
        //类型转换->限制长度->反序->拼接
        [coinData appendData:[self setAmountDataWithAmount:toModel.amount.stringValue.longLongValue]];
        //lockTime位移并与运算
        [self writeInt64:coinData addData:toModel.lockTime];
    } else {
        [self appendLengthToData:coinData length:0];
    }
    
    DLog(@"%@coinData",[coinData ny_hexString]);
    
    transactionModel.coinData = coinData;
    transactionModel.type = [NSNumber numberWithInteger:16];
    transactionModel.time = [NSNumber numberWithLong:[Common getNowTimeTimestamp]];
    transactionModel.remark = [remark dataUsingEncoding:NSUTF8StringEncoding];
    return transactionModel;
}

/***** 工具方法 ***/
+ (void)writeString:(NSMutableData *)data addString:(NSString*)addString{
    if(addString != nil && addString != NULL){
        NSData *stringData = [addString dataUsingEncoding:NSUTF8StringEncoding];
        [self appendLengthToData:data length:stringData.length];
        [data appendData: stringData];
    } else {
        [self appendLengthToData:data length:0];
    }
}

+ (void)writeUint16:(NSMutableData *)data addData:(NSNumber *)addData
{
    NSInteger val = addData.intValue;
    Byte b1 = val & 0xff;
    [data appendBytes:&b1 length:1];
    Byte b2 = val >> 8 & 0xff;
    [data appendBytes:&b2 length:1];
}

/**
 * 将8字节写入nsdata作为无符号64位long型数据，以小端格式
 */
+ (void)writeInt64:(NSMutableData *)data addData:(NSNumber *)addData
{
    NSInteger val = addData.intValue;
    Byte b9 = val & 0xff;
    [data appendBytes:&b9 length:1];
    Byte b10 = val >> 8 & 0xff;
    [data appendBytes:&b10 length:1];
    Byte b11 = val >> 16 & 0xff;
    [data appendBytes:&b11 length:1];
    Byte b12 = val >> 24 & 0xff;
    [data appendBytes:&b12 length:1];
    Byte b13 = val >> 32 & 0xff;
    [data appendBytes:&b13 length:1];
    Byte b14 = val >> 40 & 0xff;
    [data appendBytes:&b14 length:1];
    Byte b15 = val >> 48 & 0xff;
    [data appendBytes:&b15 length:1];
    Byte b16 = val >> 56 & 0xff;
    [data appendBytes:&b16 length:1];
    
}

/** data拼接 */
+ (void)appendData:(NSMutableData *)data addData:(NSData *)addData
{
    if (addData) {
        char lengthBytes[1] = {(int)addData.length};
        [data appendBytes:&lengthBytes length:1];
        [data appendData:addData];
    }else {
        char lengthBytes[1] = {0};
        [data appendBytes:&lengthBytes length:1];
    }
}

/** data拼接 */
+ (void)appendLongData:(NSMutableData *)data addData:(NSData *)txData
{
    if (txData) {
        int length = (int)txData.length;
        if (length < 253) {
            char lengthBytes[1] = {length};
            [data appendBytes:&lengthBytes length:1];
            [data appendData:txData];
        }else{ // 大于253 加三个字节 第一个字节存253 第二个字节 txData长度length 第三个是length向右右移8位
            char lengthBytes[3] = {253,length,length >> 8};
            [data appendBytes:&lengthBytes length:3];
            [data appendData:txData];
        }
    }else {
        char lengthBytes[1] = {0};
        [data appendBytes:&lengthBytes length:1];
    }
}

/** data反序 */
+ (NSMutableData *)reverseData:(NSData *)data
{
    NSMutableData *newData = [NSMutableData data];
    const Byte *point = data.bytes;
    for (int i = 0; i < data.length; i ++) {
        Byte b = point[data.length - i - 1];
        [newData appendBytes:&b length:1];
    }
    return newData;
}

/** 重新处理地址 */
+ (NSData *)changeAddress:(NSString*)address{
    NSString *prefix = @"";
    if ([address containsString:@"NULS"]) {
        prefix = PREFIX;
    }else{
        prefix = NVT_PREFIX;
    }
    NSData *data = BTCDataFromBase58([address substringFromIndex:prefix.length + 1]);
    NSMutableData *cb = [NSMutableData dataWithData:data];
    [cb replaceBytesInRange:NSMakeRange(data.length-1, 1) withBytes:NULL length:0];
    return cb;
}


/** 重新处理amount */
+ (NSMutableData *)setAmountDataWithAmount:(long)amount
{
    //类型转换->限制长度->反序
    NSMutableData *amountData = [NSMutableData dataWithLength:32];
    NSData *tempAmountData = [[NSData alloc] initWithLong:amount];
    [amountData replaceBytesInRange:NSMakeRange(amountData.length - tempAmountData.length, tempAmountData.length) withBytes:tempAmountData.bytes];
    return [self reverseData:amountData];
}

/** 拼接长度，拼接进去默认长度都为1 */
+ (void)appendLengthToData:(NSMutableData *)data length:(NSInteger)length
{
    char lengthBytes[1] = {length};
    [data appendBytes:&lengthBytes length:1];
}

/** 拼接toModel数据到coinData */
+ (void)appendToDataToCoinData:(NSMutableData *)coinData toModel:(CoinToModel *)toModel
{
    [self appendLengthToData:coinData length:toModel.address.length];
    //将address写入
    [coinData appendData:toModel.address];
    //位移并与运算
    Byte b5 = toModel.assetsChainId.intValue & 0xff;
    [coinData appendBytes:&b5 length:1];
    Byte b6 = toModel.assetsChainId.intValue >> 8 & 0xff;
    [coinData appendBytes:&b6 length:1];
    Byte b7 = toModel.assetsId.intValue & 0xff;
    [coinData appendBytes:&b7 length:1];
    Byte b8 = toModel.assetsId.intValue >> 8 & 0xff;
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
}

@end
