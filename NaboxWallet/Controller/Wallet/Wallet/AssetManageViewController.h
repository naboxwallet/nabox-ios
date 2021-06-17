//
//  AssetManageViewController.h
//  NaboxWallet 
//
//  Created by Admin on 2021/3/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetManageViewController : BaseViewController
@property (nonatomic, strong) WalletModel *walletModel; // 当前钱包数据model
@end

NS_ASSUME_NONNULL_END
