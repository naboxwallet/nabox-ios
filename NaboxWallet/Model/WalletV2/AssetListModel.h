//
//  AssetListModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/2/28.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AssetListResModel;
@interface AssetListModel : BaseModel
@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,strong)NSString *address;
@property (nonatomic ,strong) NSString *language;

@end

@interface AssetListResModel : NSObject
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSNumber *total;
@property (nonatomic ,strong) NSNumber *usdPrice;
@property (nonatomic ,strong) NSString *icon;
@property (nonatomic ,strong) NSString *chain;
@property (nonatomic ,strong) NSString *symbol;
@property (nonatomic, assign) NSInteger assetId;
@property (nonatomic, strong) NSString * registerChain;
@property (nonatomic, assign) BOOL nulsCross; 
@property (nonatomic, assign) NSInteger chainId;
@property (nonatomic, assign) int decimals;
@property (nonatomic, assign) NSInteger configType; // 0和1 不允许取消关注
@property (nonatomic ,strong) NSString *nonce;
@property (nonatomic ,strong) NSNumber *balance;
@property (nonatomic ,strong) NSNumber *locked;
@property (nonatomic ,copy) NSArray *heterogeneousList;
@property (nonatomic ,strong) NSString *contractAddress;
@property (nonatomic ,strong) NSString *nonce2; // 第二个nonce2这块写的不合理 因为目前最多可能存在3个nonce
@property (nonatomic ,strong) NSString *nonce3;

@property (nonatomic ,assign) BOOL noFollowed; // 是否关注资产  默认是关注

@property (nonatomic ,assign) BOOL extra; // 这里处理交易时候拼接Model状态跟业务无关
@property (nonatomic ,assign) double amount; // 手续费金额
@end
@interface  HeterogeneousListModel: NSObject
@property (nonatomic ,strong) NSString *chainName;
@property (nonatomic ,strong) NSString *contractAddress;
@property (nonatomic ,assign) NSInteger heterogeneousChainId;
@property (nonatomic ,strong) NSString *heterogeneousChainMultySignAddress;
@property (nonatomic ,strong) NSString *token;

@end
NS_ASSUME_NONNULL_END
