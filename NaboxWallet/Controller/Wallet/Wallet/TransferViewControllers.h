//
//  TransferViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransferViewControllers : BaseViewController
@property (nonatomic ,strong) AssetListModel *assetListModel;
@property (nonatomic ,strong) NSString *address; // 扫码进入地址
@end

NS_ASSUME_NONNULL_END
