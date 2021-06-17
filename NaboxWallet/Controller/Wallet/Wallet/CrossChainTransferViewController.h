//
//  CrossChainTransferViewController.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/14.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CrossChainTransferViewController : BaseViewController
@property (nonatomic ,strong) AssetListModel *assetListModel; // 当前链资产

@end

NS_ASSUME_NONNULL_END
