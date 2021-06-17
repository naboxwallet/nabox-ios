//
//  TransactionModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionModel : BaseModel

/**
 * 交易类型 转账：2，加入委托：5 ，退出委托：6
 */
@property (nonatomic, strong) NSNumber *type;
/**
 * 出金入金的信息
 */
@property (nonatomic, strong) NSData *coinData;

@property (nonatomic, strong) NSData *txData;
/**
 * 当前时间戳，秒
 */
@property (nonatomic, strong) NSNumber *time;
/**
 * 签名信息
 */
@property (nonatomic, strong) NSData *transactionSignature;
/**
 * 备注 界面输入的备注，字符串 转NSData ，字符集UTF-8 (remark不超过100位)
 */
@property (nonatomic, strong) NSData *remark;
/**
 * 默认-1
 */
@property (nonatomic, strong) NSNumber *blockHeight;

@property (nonatomic, strong) NSNumber *status;//status = 0

@property (nonatomic, strong) NSNumber *size;
/**
 * 在区块中的顺序，存储在rocksDB中是无序的，保存区块时赋值，取出后根据此值排序
 */
@property (nonatomic, strong) NSNumber *inBlockIndex;

//@property (nonatomic, strong) NSData *hash;


//private int type;
//
//private byte[] coinData;
//
//private byte[] txData;
//
//private long time;
//
//private byte[] transactionSignature;
//
//private byte[] remark;
//
//private transient NulsHash hash;
//
//private transient long blockHeight = -1L;
//
//private transient TxStatusEnum status = TxStatusEnum.UNCONFIRM;
//
//private transient int size;
//
///**
// * 在区块中的顺序，存储在rocksDB中是无序的，保存区块时赋值，取出后根据此值排序
// */
//private int inBlockIndex;

@end

NS_ASSUME_NONNULL_END
