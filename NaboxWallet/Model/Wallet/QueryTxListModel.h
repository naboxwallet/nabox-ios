//
//  QueryTxListModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QueryTxListModel : BaseModel

/**
 * 页码
 */
@property (nonatomic, assign) NSInteger current;
/**
 * 每页的条数
 */
@property (nonatomic, assign) NSInteger size;
/**
 * 钱包地址
 */
@property (nonatomic, copy) NSString *address;
/**
 * 订单类型
 */
@property (nonatomic, strong) NSArray *types;
/**
 * 开始时间 yyyy-MM-dd hh:mm:ss
 */
@property (nonatomic, copy) NSString *startTime;
/**
 * 结束时间yyyy-MM-dd hh:mm:ss
 */
@property (nonatomic, copy) NSString *endTime;
/**
 * 交易类型 in:转入  out 转出；
 */
@property (nonatomic, copy) NSString *transCoinType;
/**
 * 合约资产地址
 */
@property (nonatomic, copy) NSString *contractAddress;

@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,assign)NSInteger chainId;
@property (nonatomic ,assign)NSInteger assetId;

/**
 * 语言：EN/CHS
 */
@property (nonatomic, copy) NSString *language;

/**
 * 页码
 */
@property (nonatomic, assign) NSInteger pageNumber;
/**
 * 每页的条数
 */
@property (nonatomic, assign) NSInteger pageSize;
@end

NS_ASSUME_NONNULL_END
