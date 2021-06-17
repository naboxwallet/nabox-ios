//
//  TradeInfoModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/7.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TradeInfoResModel;
@class CrossTxModel;
@interface TradeInfoModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *chain;
@property (nonatomic ,strong) NSString *txHash;
@property (nonatomic ,assign) NSInteger transCoinId;

@property (nonatomic ,strong) CrossTxModel *crossTx;
@property (nonatomic ,strong) TradeInfoResModel *tx;
@end

@interface TradeInfoResModel : NSObject
@property (nonatomic ,strong) NSNumber *amount;
@property (nonatomic ,strong) NSString *fee;
@property (nonatomic ,strong) NSString *froms;
@property (nonatomic ,strong) NSString *tos;
@property (nonatomic ,assign) int decimals;
@property (nonatomic ,strong) NSString *remark;
@property (nonatomic ,strong) NSString *status;
@property (nonatomic ,strong) NSString *createTime;
@property (nonatomic ,strong) NSString *symbol;
@property (nonatomic ,strong) NSString *transType;
@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) NSString *txId;
@property (nonatomic ,strong) NSString *height;

@end

@interface CrossTxModel : NSObject
@property (nonatomic ,strong) NSString *crossTxHash;
@property (nonatomic ,strong) NSString *fromAddress;
@property (nonatomic ,strong) NSString *fromChain;
@property (nonatomic ,strong) NSString *toAddress;
@property (nonatomic ,strong) NSString *toChain;
@property (nonatomic ,strong) NSString *txHash;
@property (nonatomic ,strong) NSString *status;
@end

NS_ASSUME_NONNULL_END
