//
//  GlobalVariable.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

/** 全局变量 */
@interface GlobalVariable : NSObject
//单例
+ (instancetype)sharedInstance;

/** NULS的美元汇率 目前已不使用*/
@property (nonatomic, strong) NSNumber *usdRate;
/** usdt的人民币汇率 */
@property (nonatomic, strong) NSNumber *cnyRate;
/** usdt的比特币汇率 */
@property (nonatomic, strong) NSNumber *btcRate;
/** 传入资产余额根据货币类型及汇率得出相应结果 */
- (NSString *)getAssetsNumWithNum:(double)num;
/** 传入美元根据货币类型及汇率得出相应结果 */
- (NSString *)getAssetsAmountWithNum:(NSNumber *)num;
/** 传入美元根据货币类型及汇率得出相应结果 自定义小数点*/
- (NSString *)getAssetsAmountWithNum:(NSNumber *)num andDecimals:(int)decimals;


@property (nonatomic ,strong)NSArray *configList; // 获取全局链配置列表

/** 通过chain获取chain配置整个数据 包含 资产列表 主资产信息 config等等 **/
- (ConfigInfoModel *)getChainConfigWithChain:(NSString *)chain;
/** 通过chain获取当前链主资产model **/
- (ConfigMainAssetModel *)getMainAssetWithChain:(NSString *)chain;

/*** 保存当前用户选择手续费级别 因为临时新增加速功能把用户加速等级存储在单例中不修改业务代码 **/
@property (nonatomic ,assign) float feeLevel;
@end

NS_ASSUME_NONNULL_END
