//
//  ConfigModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/2/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : BaseModel


@end

@class ConfigMainAssetModel;
@interface ConfigInfoModel : NSObject
@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,strong)NSString *prefix;
@property (nonatomic, assign) NSInteger chainId;
@property (nonatomic ,strong)NSDictionary *configs;
@property (nonatomic ,copy)NSArray *assets; // 存放当前链资产
@property (nonatomic ,strong)ConfigMainAssetModel *mainAsset; // 链主资产

@end

// 手续费Model也使用
@interface ConfigMainAssetModel : NSObject
@property (nonatomic ,assign)NSInteger chainId;
@property (nonatomic ,assign)NSInteger assetId;
@property (nonatomic ,strong)NSString *symbol;
@property (nonatomic ,assign)int decimals;
@property (nonatomic ,assign) double amount; // 金额

@property (nonatomic ,strong)NSString *address;
@property (nonatomic ,strong) NSString *contractAddress;


@property (nonatomic ,assign) BOOL nerveToNuls; // nerveToNuls时候需要0.01NULS和0.01nvt
@end

NS_ASSUME_NONNULL_END
