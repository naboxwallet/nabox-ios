//
//  TransferTempModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"
#import "AssetListModel.h"
#import "ConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransferTempModel : BaseModel

/**
 * 付款网络链
 */
@property (nonatomic, copy) NSString *fromChain;

/**
 * 收款网络链
 */
@property (nonatomic, copy) NSString *toChain;

/**
 * 付款地址
 */
@property (nonatomic, copy) NSString *fromAddress;
/**
 * 收款地址
 */
@property (nonatomic, copy) NSString *toAddress;
/**
 * 转账金额（输入框中输入的金额）
 */
@property (nonatomic, copy) NSString *amount;
/**
 * 转账金额（输入框中输入的金额+手续费的金额）
 */
@property (nonatomic, assign) double addFeeAmount;
/**
 * 备注 界面输入的备注，字符串 转NSData ，字符集UTF-8 (remark不超过100位)
 */
@property (nonatomic, copy) NSString *remark;


/**
 * 转账资产
 */
@property (nonatomic,strong) AssetListResModel *assetModel;

/** from转账资产列表(构造交易数据使用) */
@property (nonatomic, copy) NSArray *fromAssetList;
/** toModel(构造交易数据使用) */
@property (nonatomic, strong, nullable) AssetListResModel *extraToModel;

/**
 * 手续费资产第一个
 */
@property (nonatomic,strong) ConfigMainAssetModel *feeAssetModel;

/**
 * 手续费资产第二个
 */
@property (nonatomic,strong) ConfigMainAssetModel *feeAssetModel2;

/**
 * gas
 */
@property (nonatomic, strong) NSNumber* gasLimit;


/**
 * 手续费
 */
@property (nonatomic, assign) double fee;

/**
 * 合约地址
 */
@property (nonatomic, strong) NSString* contractAddress;

/**
 * nerve黑洞地址
 */
@property (nonatomic, strong) NSString* destroyAddress;

/**
 * nerve黑洞手续费地址
 */
@property (nonatomic, strong) NSString* feeAddress;

@end

NS_ASSUME_NONNULL_END
