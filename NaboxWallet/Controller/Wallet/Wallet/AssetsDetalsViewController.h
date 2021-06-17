//
//  AssetsDetalsViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetalsViewController : BaseViewController
@property (nonatomic ,assign) BOOL backRoot; // 支付成后跳转过来 返回时返回到首页

@property (nonatomic ,strong)AssetInfoModel *assetInfoModel;
@end

NS_ASSUME_NONNULL_END
