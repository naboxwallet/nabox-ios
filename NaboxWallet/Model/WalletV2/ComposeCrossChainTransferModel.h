//
//  ComposeCrossChainTransferModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/13.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeCrossChainTransferModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *fromChain;
@property (nonatomic ,strong) NSString *toChain;
@property (nonatomic ,strong) NSString *fromAddress;
@property (nonatomic ,strong) NSString *toAddress;
@property (nonatomic ,strong) NSString *txHex;
@property (nonatomic ,assign) NSInteger chainId;
@property (nonatomic ,assign) NSInteger assetId;
@property (nonatomic ,strong) NSString *contractAddress;
@property (nonatomic ,strong) NSString *crossTxHex;
@end

NS_ASSUME_NONNULL_END
