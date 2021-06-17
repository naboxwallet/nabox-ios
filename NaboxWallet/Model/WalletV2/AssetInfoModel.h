//
//  AssetInfoModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/6.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetInfoModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,strong)NSString *address;
@property (nonatomic ,assign)NSInteger chainId;
@property (nonatomic ,assign)NSInteger assetId;
@property (nonatomic ,strong)NSString *contractAddress;
@property (nonatomic ,assign)BOOL refresh;
@end

NS_ASSUME_NONNULL_END
