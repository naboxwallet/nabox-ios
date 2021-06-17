//
//  NeverMapAssetModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/20.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NeverMapAssetModel : BaseModel

@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,assign)NSInteger chainId;
@property (nonatomic ,assign)NSInteger assetId;
@property (nonatomic ,strong)NSString *contractAddress;

@end

NS_ASSUME_NONNULL_END
